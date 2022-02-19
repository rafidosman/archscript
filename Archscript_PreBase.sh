# == MY ARCH SETUP INSTALLER == #
#part1
printf '\033c'
echo "Welcome to fido's arch installer script"
# Making downloads faster
pacman --noconfirm -Sy reflector
reflector --latest 20 --sort rate --save /etc/pacman.d/mirrorlist --protocol https --download-timeout 5
sed -i "s/^#ParallelDownloads = 5$/ParallelDownloads = 15/" /etc/pacman.conf
pacman --noconfirm -Sy archlinux-keyring

# Setting keymap and time stuff
loadkeys us
timedatectl set-ntp true


# Drive selection
clear
lsblk
echo -ne "Drive to install to: "
read -r drive
cfdisk "$drive"


# Partition slection
clear
lsblk "$drive"

echo -ne "Enter EFI partition: "
read -r efipartition

read -r -p "Should we format the EFI partition? [y/n]: " answer
if [[ $answer = y ]]; then
    echo "There it goes then"
    mkfs.vfat -F 32 "$efipartition"
else
    echo "Alright, skipping EFI partition formatting"
fi

echo -ne "Enter swap partition: "
read -r swappartition
mkswap "$swappartition"

echo -ne "Enter root/home partition: "
read -r rootpartition
mkfs.ext4 "$rootpartition"

# Mounting filesystems
mount "$rootpartition" /mnt
mkdir -p /mnt/boot/efi
mount "$efipartition" /mnt/boot/efi
swapon "$swappartition"

# Initial Install
pacstrap /mnt base base-devel linux linux-firmware git nano vim intel-ucode
genfstab -U /mnt >> /mnt/etc/fstab


cp  Archscript_Base.sh > /mnt/arch_install2.sh
chmod +x /mnt/arch_install2.sh
arch-chroot /mnt ./arch_install2.sh
exit 

