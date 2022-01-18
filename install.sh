# This file is used to partition, mount and install arch linux on UEFI systems.

# Default keyboard layout is US.
# To change layout :
# 1. Use `localectl list-keymaps` to display liste of keymaps.
# 2. Use  `loadkeys [keymap]` to set keyboard layout.
#    ex : `loadkeys de-latin1` to set a german keyboard layout.

# Check if system is booted in UEFI mode.
if [ ! -d "/sys/firmware/efi/efivars" ] 
then
    # If not, then exit installer.
    echo "[Error!] System is not booted in UEFI mode. Please boot in UEFI mode & try again."
    exit 9999
fi

# Figure out how much RAM the system has an set a variable
# ramTotal=$(grep MemTotal /proc/meminfo | awk '{print $2 / 1024 / 1024}')
ramTotal=$(free | awk '/^Mem:/{print $2 / 1024 / 1024}'  | awk -F. {'print$1'})

# Update system clock.
timedatectl set-ntp true

# Load kernel modules
modprobe dm-crypt
modprobe dm-mod

# Detect and list the drives.
lsblk -f

# Choice the drive to use :
# 1. 
echo "----------"
echo ""
echo "Which drive do we want to use for this installation?"
read driveName

echo "----------"
echo ""
echo "Enable Hibernation?"
echo "1) Yes"
echo "2) No"
echo -n "Enter choice: "; read hibState

case "$hibState" in

1)

(
echo g       # Create new GPT partition table
echo n       # Create new partition (for EFI).
echo         # Set default partition number.
echo         # Set default first sector.
echo +512M   # Set +512M as last sector.
echo n       # Create new partition (for root).
echo         # Set default partition number.
echo         # Set default first sector.
echo "-$ramTotal"G # Set Max RAM as last sector.
# echo -4096M  # Set -4096 as last sector.
echo n       # Create new partition (for swap).
echo         # Set default partition number.
echo         # Set default first sector.
echo         # Set default last sector (rest of the disk).
echo t       # Change partition type.
echo 1       # Pick first partition.
echo 1       # Change first partition to EFI system.
echo t       # Change partition type.
echo 3       # Pick third partition.
echo 19      # Change third partition to Linux swap.
echo w       # write changes. 
) | fdisk $driveName -w always -W always
;;

2) 

(
echo g       # Create new GPT partition table
echo n       # Create new partition (for EFI).
echo         # Set default partition number.
echo         # Set default first sector.
echo +512M   # Set +512M as last sector.
echo n       # Create new partition (for root).
echo         # Set default partition number.
echo         # Set default first sector.
echo -4096M  # Set -4096 as last sector.
echo n       # Create new partition (for swap).
echo         # Set default partition number.
echo         # Set default first sector.
echo         # Set default last sector (rest of the disk).
echo t       # Change partition type.
echo 1       # Pick first partition.
echo 1       # Change first partition to EFI system.
echo t       # Change partition type.
echo 3       # Pick third partition.
echo 19      # Change third partition to Linux swap.
echo w       # write changes. 
) | fdisk $driveName -w always -W always
;;

esac

# List the new partitions.
lsblk -f

# Format the partitions :
echo "----------"
echo ""
echo "Which is the EFI partition?"
read efiName

echo ""
echo "Which is the root partition?"
read rootName

echo ""
echo "Which is the swap partition?"
read swapName

# Encrypt the root partition
cryptsetup luksFormat -v -s 512 -h sha512 $rootName

# Open the encrypted root partition
cryptsetup luksOpen $rootName crypt-root

mkfs.fat -F32 -n EFI $efiName # EFI partition
mkfs.ext4 -L root /dev/mapper/crypt-root # /   partition
mkswap -L swap $swapName # swap partition

# 0. Mount the filesystems.
mount /dev/mapper/crypt-root /mnt
swapon $swapName

# 1. Create directory to mount EFI partition.
mkdir /mnt/boot/

# 2.Mount the EFI partition.
mount $efiName /mnt/boot

# Select mirrors :
# Use `reflector --list-countries` and replace "IN" with your country code.

# 1. Install reflector.
# pacman -Syy reflector --noconfirm
# 2. Update the mirror list. 
# reflector -c "US" -f 12 -l 10 -n 12 --save /etc/pacman.d/mirrorlist

# Install essential packages.
pacstrap /mnt base base-devel linux linux-headers linux-firmware nano lvm2

# This is to workaround this issue:
# error: could not open file /mnt/var/lib/pacman/sync/core.db: Unrecognized archive format
# error: could not open file /mnt/var/lib/pacman/sync/extra.db: Unrecognized archive format
# error: could not open file /mnt/var/lib/pacman/sync/community.db: Unrecognized archive format
rm -R /mnt/var/lib/pacman/sync/
pacman -Syuf

# Retrying to install the essential packages.
pacstrap /mnt base base-devel linux linux-headers linux-firmware vim intel-ucode nano lvm2

# Generate fstab file.
genfstab -U /mnt >> /mnt/etc/fstab

# Fetch script for `arch-chroot`.
curl https://gitlab.com/ahoneybun/arch-itect/-/raw/main/setup.sh > /mnt/setup.sh

# Change root into the new system & run script.
arch-chroot /mnt sh setup.sh

# Removed downloaded script.
rm install.sh

# Unmount all filesystems & reboot.
# umount -a
# reboot

