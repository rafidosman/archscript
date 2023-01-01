#part2
#!/bin/bash

# Setting things so things are faster
#pacman -S --noconfirm sed
#sed -i "s/^#ParallelDownloads = 5$/ParallelDownloads = 15/" /etc/pacman.conf

# Setting timezone stuff
ln -sf /usr/share/zoneinfo/Asia/Kuala_Lumpur /etc/localtime
hwclock --systohc

# Setting language stuff
echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" > /etc/locale.conf
echo "KEYMAP=us" > /etc/vconsole.conf

# Setting hostname
clear
echo -ne "Enter your desired hostname: "
read -r hostname
echo "$hostname" > /etc/hostname

echo "127.0.0.1      localhost" >> /etc/hosts
echo "::1            localhost" >> /etc/hosts
echo "127.0.1.1      $hostname.localdomain $hostname" >> /etc/hosts

# First making of initcpio
mkinitcpio -P

passwd

#install grub
pacman --noconfirm -S grub efibootmgr os-prober mtools
# "Enter EFI partition: " 
# read efipartition
# mkdir /boot/efi
# mount $efipartition /boot/efi 
grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=GRUB
#sed -i 's/quiet/pci=noaer/g' /etc/default/grub
#sed -i 's/GRUB_TIMEOUT=5/GRUB_TIMEOUT=0/g' /etc/default/grub
grub-mkconfig -o /boot/grub/grub.cfg

pacman -S xorg xorg-server xorg-xinit xorg-xkill xorg-xsetroot xorg-xbacklight xorg-xprop xorg-xrandr xorg-xinput 
pacman -S dunst libnotify acpi acpi_call lxappearance papirus-icon-theme arc-gtk-theme rofi nitrogen
pacman -S zsh zsh-syntax-highlighting zsh-autosuggestions kitty ranger mpd playerctl mpc ncmpcpp 
pacman -S neofetch htop bashtop
pacman -S feh firefox starship dust bat exa rsync maim xdotool 
pacman -S noto-fonts noto-fonts-emoji ttf-joypixels ttf-font-awesome 
pacman -S sxiv mpv imagemagick fzf gzip p7zip libzip zip unzip yt-dlp xclip
pacman -S dhcpcd networkmanager pamixer paprefs pulseaudio pulseaudio-alsa pulsemixer pavucontrol alsa-utils alsa-firmware sof-firmware man-db
pacman -S zathura zathura-pdf-mupdf xdg-user-dirs xdg-utils unclutter qtile lightdm lightdm-gtk-greeter
pacman -S dialog wpa_supplicant linux-headers gvfs gvfs-smb nfs-utils inetutils dnsutils firewalld dosfstools ntfs-3g


#pacman -S --noconfirm mesa xf86-video-intel libva-intel-driver intel-media-driver libva-vdpau-driver libvdpau-va-gl
pacman -S --noconfirm nvidia nvidia-utils nvidia-settings 

pacman -S arandr vlc noto-fonts-cjk noto-fonts-emoji pacman-contrib



systemctl enable NetworkManager.service 
systemctl enable lightdm.service
#systemctl enable tlp # You can comment this command out if you didn't install tlp, see above
systemctl enable fstrim.timer
systemctl enable firewalld
#systemctl enable acpid

#rm /bin/sh
#ln -s dash /bin/sh
#chsh -s /usr/bin/zsh fido

# Settings up a user
echo "%wheel ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
echo "Enter Username: "
read username
useradd -m -G wheel -s /bin/zsh $username
passwd $username

# Paru
# git clone https://aur.archlinux.org/yay.git
# cd yay
# makepkg -si

#yay -S polybar picom-jonaburg-git mpd-mpris pfetch xcursor-breeze nerd-fonts-complete brave-bin mailspring


exit 
