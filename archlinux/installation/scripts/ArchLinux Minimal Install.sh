[Minimal Install]
# -- Global Variables
is_uefi=False

# ------------------- Get User Info  ------------------- #

# -- User data
# Keyboard Layout
read -p "Change Keyboard Layout? [Y|N]: " key_layout_change
if [ "$key_layout_change" == "Y" ]; then
	ls /usr/share/kbd/keymaps/**/*.map.gz
	read -p "Keyboard Layout?: " key_layout
fi

# Get Partition
sudo fdisk -l 
lsblk
read -p "Disk Label [msdos (for MBR)|gpt (for UEFI)]: " disk_label
read -p "Disk Partition (/dev/sda, /dev/sdb, /dev/sdc etc - no numbers behind): " disk_part

# Get Packages
pacstrap_pkgs=""
default_pacstrap="base base-devel linux linux-lts linux-firmware linux-headers linux-lts-headers sudo"
echo "Default Pacstrap: $default_pacstrap"
read -p "Add anymore packages? [Y|N]: " add_additional
if [ "$add_additional" == "Y" ]; then
	read -p "Other packages: " other_pkgs
	default_pacstrap+=$other_pkgs
fi
pacstrap_pkgs=$default_pacstrap

# Get User info
ls /usr/share/zoneinfo/
read -p "Region?: " region
ls /usr/share/zoneinfo/$region/
read -p "City?: " city
ln -sf /usr/share/zoneinfo/$region/$city /etc/localtime 				# Set timezone
hwclock --systohc 									# Sync and Generate /etc/adjtime using hwclock
read -p "Locale code? [en_SG.UTF-8, en_US.UTF-8] (Type 'h' to view locales): " locale_code
if [ "$locale_code" == "h" ]; then
	cat /etc/locale.gen
	read -p "Locale code? [en_SG.UTF-8, en_US.UTF-8]: " locale_code
fi

# Get multilib enable/disable confirmation
read -p "Enable multilib 64-bit control? [Y|N]: " enable_multilib			# To enable multilib/leave it

# Bootloader
read -p "Bootloader [Grub/Syslinux]: " bootloader

# ------------------- End of User Info ------------------- #

# -- Process
if [ ! -z "$key_layout" ]; then
	# Not empty
	loadkeys $key_layout
fi
if [ "$(ls /sys/firmware/efi/efivars)" ]; then
	is_uefi=True
fi
timedatectl set-ntp true
parted $disk_part mklabel $disk_label							#msdos (MBR)/gpt (UEFI)
parted $disk_part mkpart primary ext4 1MiB 1024MiB
parted $disk_part set 1 boot on								# Enable Bootable for Boot Partition
parted $disk_part mkpart primary ext4 1024MiB 51200MiB
parted $disk_part mkpart primary ext4 51200MiB 100%					# Use Remainder of the space
mkfs.ext4 $disk_part									# ext4 
mkfs.ext4 $disk_part2
mkfs.ext4 $disk_part3
# Mount
mount $disk_part2 /mnt
mkdir -p /mnt/boot
mount $disk_part1 /mnt/boot
mkdir -p /mnt/home
mount $disk_part3 /mnt/home
pacstrap /mnt $pacstrap_pkgs  								# NOTES: These are the minimal for installations; Strap libraries to /mnt (ArchLinux Kernel etc.)
genfstab -U /mnt >> /mnt/etc/fstab 							# Generate an fstab file
arch-chroot /mnt 									# Change root to Arch Mount/Root
# After mounting
sed -i '/$locale_code/s/^#//g' /etc/locale.gen 						# Uncomment locale
locale-gen 										# Generate locale
echo "LANG=$locale_code" >> /etc/locale.conf 						# Create Locale Cnfig
echo "KEYMAP=$key_layout" >> /etc/vconsole.conf
if [ "$enable_multilib" == "Y" ]; then
	sed -i "/\[multilib\]/,/Include/"'s/^#//' /etc/pacman.conf
fi
echo "Hostname: " hostname
echo "$hostname" >> /etc/hostname # Create Hostname
echo "127.0.0.1	localhost" >> /etc/hosts 
echo "::1       localhost" >> /etc/hosts # 7 empty spaces to localhost
echo "127.0.1.1	$hostname.localdomain	$hostname" >> /etc/hosts
mkinitcpio -P linux	# Initialize and create new ram file system
mkinitcpio -P linux-lts # Initialize and create new ram file system
passwd 			# Set Root Password
sed -i '/%wheel ALL=(ALL) ALL/s/^#//g' /etc/sudoers 					# Allow new users to run sudo; PLEASE DO NOT USE SCRIPTS TO EDIT SUDOERS, use [EDITOR=<your editor> visudo]
pacman -S os-prober
cd /boot
# Install Bootloader
case "$bootloader" in 
	"Grub")
		pacman -S grub
		mkdir grub
		cd grub
		grub-mkconfig -o grub.cfg
		grub-install --target=i386-pc --debug $disk_part
		;;
	*) echo "Invalid Bootloader, apologies - you will need to install the bootloader manually"
		;;
esac

echo "Installation process via script has been completed."

read -p "Reboot? [Y|N]: " reboot_confirm
if [ "$reboot_confirm" == "Y" ]; then
	exit
	umount -l /mnt
	reboot
fi