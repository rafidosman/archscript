#part2
#!/bin/bash

# Setting things so things are faster
#pacman -S --noconfirm sed
#sed -i "s/^#ParallelDownloads = 5$/ParallelDownloads = 15/" /etc/pacman.conf

# Setting timezone stuff
#ln -sf /usr/share/zoneinfo/Asia/Kuala_Lumpur /etc/localtime
#hwclock --systohc

# Setting language stuff
#echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
#locale-gen
#echo "LANG=en_US.UTF-8" > /etc/locale.conf
#echo "KEYMAP=us" > /etc/vconsole.conf

# Setting hostname
#clear
#echo -ne "Enter your desired hostname: "
#read -r hostname
#echo "$hostname" > /etc/hostname

#echo "127.0.0.1      localhost" >> /etc/hosts
#echo "::1            localhost" >> /etc/hosts
#echo "127.0.1.1      $hostname.localdomain $hostname" >> /etc/hosts
#
# First making of initcpio
#mkinitcpio -P

#passwd

#install grub
#pacman --noconfirm -S grub efibootmgr os-prober
# "Enter EFI partition: " 
# read efipartition
# mkdir /boot/efi
# mount $efipartition /boot/efi 
#grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=GRUB
#sed -i 's/quiet/pci=noaer/g' /etc/default/grub
#sed -i 's/GRUB_TIMEOUT=5/GRUB_TIMEOUT=0/g' /etc/default/grub
#grub-mkconfig -o /boot/grub/grub.cfg

pacman -S xorg xorg-server xorg-xinit xorg-xkill xorg-xsetroot xorg-xbacklight xorg-xprop xorg-xrandr xorg-xinput bspwm sxhkd dunst pavucontrol libnotify lxappearance papirus-icon-theme arc-gtk-theme rofi nitrogen zsh zsh-syntax-highlighting zsh-autosuggestions kitty ranger mpd playerctl mpc ncmpcpp neofetch lolcat htop bashtop neovim hunspell hunspell-en_us hyphen hyphen-en feh firefox starship bat exa duf xfce4-clipman-plugin rsync maim xdotool noto-fonts noto-fonts-emoji ttf-joypixels ttf-font-awesome sxiv mpv imagemagick fzf gzip p7zip libzip zip unzip yt-dlp xclip alsa-utils alsa-firmware sof-firmware man-db zathura zathura-pdf-mupdf xdg-user-dirs xdg-utils unclutter lightdm lightdm-gtk-greeter dialog wpa_supplicant mtools gvfs gvfs-smb nfs-utils inetutils dnsutils 


#pacman -S --noconfirm mesa xf86-video-intel libva-intel-driver intel-media-driver libva-vdpau-driver libvdpau-va-gl
#pacman -S --noconfirm nvidia nvidia-utils nvidia-settings 

pacman -S arandr vlc ttf-bitstream-vera ttf-croscore ttf-dejavu ttf-droid gnu-free-fonts ttf-ibm-plex ttf-liberation ttf-linux-libertine ttf-roboto tex-gyre-fonts ttf-ubuntu-font-family ttf-anonymous-pro ttf-cascadia-code ttf-fantasque-sans-mono ttf-fira-mono ttf-hack ttf-fira-code ttf-inconsolata ttf-jetbrains-mono ttf-monofur adobe-source-code-pro-fonts cantarell-fonts inter-font ttf-opensans gentium-plus-font ttf-junicode adobe-source-han-sans-otc-fonts adobe-source-han-serif-otc-fonts noto-fonts-cjk noto-fonts-emoji ttf-font-awesome awesome-terminal-fonts  pacman-contrib



#systemctl enable NetworkManager.service 
systemctl enable lightdm.service
#systemctl enable tlp # You can comment this command out if you didn't install tlp, see above
systemctl enable fstrim.timer
#systemctl enable firewalld
#systemctl enable acpid

#rm /bin/sh
#ln -s dash /bin/sh
#chsh -s /usr/bin/zsh fido

# Settings up a user
#echo "%wheel ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
#echo "Enter Username: "
#read username
#useradd -m -G wheel -s /bin/zsh $username
#passwd $username

# Paru
#git clone https://aur.archlinux.org/yay.git
#cd yay
#makepkg -si

yay -S polybar picom-jonaburg-git mpd-mpris pfetch xcursor-breeze nerd-fonts-complete


exit 
