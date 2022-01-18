# This file is used to configure the installed arch linux for daily use.

# Enable network time sync
timedatectl set-ntp true

# Set the timezone.
# Use `timedatectl list-timezones` and replace America/Denver with your country code.
timedatectl set-timezone Asia/Kuala_Lumpur
ln -sf /usr/share/zoneinfo/Asia/Kuala_Lumpur /etc/localtime
hwclock --systohc

# Localization :

# 1. Generate '/etc/adjtime'.
hwclock --systohc

# 2. Set system locale :

    # a. Uncomment required locales from '/etc/locale.gen'.
    sed -i 's/#en_US.UTF-8/en_US.UTF-8/' /etc/locale.gen
    # b. Generate locale.
    locale-gen
    # c. Set system locale. (creates locale.conf)
    localectl set-locale LANG=en_US.UTF-8

# 3. set LANG variable system-wide.
echo 'export LANG=en_US.UTF-8' | tee -a /etc/profile

# Network configuration :

# 1. Create the hostname file.
echo "----------"
echo ""
echo "Specify hostname. This will be used to identify your machine on a network."
read hostName; echo $hostName > /etc/hostname

# 2. Add matching entries to '/etc/hosts'.
# If the system has a permanent IP address, it should be used instead of 127.0.1.1. 
echo -e 127.0.0.1'\t'localhost'\n'::1'\t\t'localhost'\n'127.0.1.1'\t'$hostName >> /etc/hosts

# Create regular user :

# 1. Add regular user.
echo "----------"
echo ""
echo "Specify username. This will be used to identify your account on this machine."
read userName;
useradd -m -G wheel -s /bin/bash $userName

# 2. Set password for new user.
echo "----------"
echo ""
echo "Specify password for regular user : $userName."; passwd $userName

# 3. Enable sudo for wheel group.
sed -i 's/# %wheel ALL=(ALL) ALL/%wheel ALL=(ALL) ALL/' /etc/sudoers

# Set the root password.
echo "----------"
echo ""
echo "Specify root password. This will be used to authorize root commands."
passwd

# Edit mkinitcpio hooks

echo "----------"
echo ""
echo "Did you enable Hibernation?"
echo "1) Yes"
echo "2) No"
echo -n "Enter choice: "; read hibState

case "$hibState" in
    1)
    sed -i 's/HOOKS=(base udev autodetect modconf block filesystems keyboard fsck)/HOOKS=(base udev autodetect modconf block keyboard encrypt lvm2 filesystems resume fsck)/g' /etc/mkinitcpio.conf
    ;;
    2) 
    sed -i 's/HOOKS=(base udev autodetect modconf block filesystems keyboard fsck)/HOOKS=(base udev autodetect modconf block keyboard encrypt lvm2 filesystems fsck)/g' /etc/mkinitcpio.conf
    ;;
 esac

# Create initramfs.
mkinitcpio -p linux

# Install systemd-boot bootloader :

# 0. Set root partition

lsblk -f 

echo ""
echo "----------"
echo ""
echo "Which is the root partition?"
read rootName

echo ""
echo "----------"
echo ""
echo "Which is the swap partition?"
read swapName

# 1. Install required packages.
pacman -S efibootmgr --noconfirm
bootctl install

# 2. Generate systemd-boot entry.
touch /boot/loader/entries/arch.conf

if [ $hibState = 1 ]; then
   echo 'title Arch Linux' | tee -a /boot/loader/entries/arch.conf
   echo 'linux /vmlinuz-linux' | tee -a /boot/loader/entries/arch.conf
   echo 'initrd /initramfs-linux.img' | tee -a /boot/loader/entries/arch.conf
   echo "options cryptdevice=$rootName:crypt-root root=/dev/mapper/crypt-root resume=$swapName rw" | tee -a /boot/loader/entries/arch.conf

else

if [ $hibState = 2 ]; then
   echo 'title Arch Linux' | tee -a /boot/loader/entries/arch.conf
   echo 'linux /vmlinuz-linux' | tee -a /boot/loader/entries/arch.conf
   echo 'initrd /initramfs-linux.img' | tee -a /boot/loader/entries/arch.conf
   echo "options cryptdevice=$rootName:crypt-root root=/dev/mapper/crypt-root rw" | tee -a /boot/loader/entries/arch.conf

fi

fi

# Set default editor.
echo 'export VISUAL=nano' | tee -a /etc/profile
echo 'export EDITOR=$VISUAL' | tee -a /etc/profile

# Install must have packages.
pacman -S git fish networkmanager --noconfirm
xdg-user-dirs-update

# Install development packages.
pacman -S neofetch rust tree rygel make openssh --noconfirm

# Install virt-manager packages and services.
#ipacman -S virt-manager edk2-ovmf --noconfirm; systemctl enable libvirtd 

# Install additional fonts
pacman -S ttf-indic-otf noto-fonts-cjk noto-fonts-emoji noto-fonts --noconfirm

# Change shell to fish for the new user
chsh --shell /usr/bin/fish $userName

# Setting up Yubikey support
#echo 'KERNEL=="hidraw*", SUBSYSTEM=="hidraw", MODE="0664", GROUP="users", ATTRS{idVendor}=="2581", ATTRS{idProduct}=="f1d0"' | tee /etc/udev/rules.d/10-security-key.rules
#pacman -S libu2f-server pam-u2f --noconfirm
#systemctl enable pcscd

# Start and enable systemd services
systemctl enable NetworkManager
#systemctl enable iwd

#echo ""
#echo "1) AMD"
#echo "2) Intel"
#echo -n "Enter CPU: "; read $cpuName

#case "$cpuName" in
#   1) 
#   pacman -S amd-ucode --noconfirm
#   ;;
#   2) 
#   pacman -S intel-ucode --noconfirm
#   ;;
#   0)
#   exit
#   ;;
#esac

# Pick a desktop [WIP]
curl https://gitlab.com/ahoneybun/arch-itect/-/raw/main/desktop.sh > desktop.sh; sh desktop.sh

# Enable TRIM for SSDs
systemctl enable fstrim.timer
