# [Minimal Install]

# -- Global Variables
is_uefi=False

# -- Defaults
pacstrap_pkgs=""
default_pacstrap="base base-devel linux linux-lts linux-firmware linux-headers linux-lts-headers sudo"

# ------------------- Get User Info  ------------------- #

# Usage:
#
# ArchLinux Minimal Install - Self-partition v0.2.sh $1 $2 $3 $4 $5 $6 $7
#  $1 : Keyboard Layout change confirmation - either {"Y" | "N"}
#  $2 : Any additional packages confirmation - either {"Y" | "N"}
#  $3 : Region (i.e. Asia)
#  $4 : City   (i.e. Singapore)
#  $5 : Locale code (i.e. en_SG.UTF-8) - 'h' to view
#  $6 : Enable multilib 64-bit controls - either {"Y" | "N"}
#  $7 : Bootloader [Grub/Syslinux]
# 
# Example:
# 
# ArchLinux Minimal Install - Self-partition v0.2.sh "N" "Y" "Asia" "Singapore" "en_SG.UTF-8" "Y" "Grub"
#

if [ -z "$1" ]; then
	# -- User data
	# Keyboard Layout
	read -p "Change Keyboard Layout? [Y|N]: " key_layout_change
	if [ "$key_layout_change" == "Y" ]; then
		ls /usr/share/kbd/keymaps/**/*.map.gz
		read -p "Keyboard Layout?: " key_layout
	fi

	# Get Packages
	echo "Default Pacstrap: $default_pacstrap"
	read -p "Add anymore packages? [Y|N]: " add_additional
	if [ "$add_additional" == "Y" ]; then
		read -p "Other packages: " other_pkgs
		default_pacstrap+=" $other_pkgs"
	fi
	pacstrap_pkgs=$default_pacstrap

	# Get User info
	ls /usr/share/zoneinfo/
	read -p "Region?: " region
	ls /usr/share/zoneinfo/$region/
	read -p "City?: " city
	read -p "Locale code? [en_SG.UTF-8, en_US.UTF-8] (Type 'h' to view locales): " locale_code
	if [ "$locale_code" == "h" ]; then
		cat /etc/locale.gen
		read -p "Locale code? [en_SG.UTF-8, en_US.UTF-8]: " locale_code
	fi

	# Get hostname
	read -p "Hostname: " hostname

	# Get multilib enable/disable confirmation
	read -p "Enable multilib 64-bit control? [Y|N]: " enable_multilib			# To enable multilib/leave it

	# Bootloader
	read -p "Bootloader [Grub/Syslinux]: " bootloader
else
	key_layout_change="$1"
	if [ "$key_layout_change" == "Y" ]; then
		ls /usr/share/kbd/keymaps/**/*.map.gz
		read -p "Keyboard Layout?: " key_layout
	fi

	if [ -z "$2" ]; then
		# Get Packages
		echo "Default Pacstrap: $default_pacstrap"
		read -p "Add anymore packages? [Y|N]: " add_additional
		if [ "$add_additional" == "Y" ]; then
			read -p "Other packages: " other_pkgs
			default_pacstrap+=" $other_pkgs"
		fi
		pacstrap_pkgs=$default_pacstrap

		# Get User info
		ls /usr/share/zoneinfo/
		read -p "Region?: " region
		
		ls /usr/share/zoneinfo/$region/
		read -p "City?: " city
		read -p "Locale code? [en_SG.UTF-8, en_US.UTF-8] (Type 'h' to view locales): " locale_code
		if [ "$locale_code" == "h" ]; then
			cat /etc/locale.gen
			read -p "Locale code? [en_SG.UTF-8, en_US.UTF-8]: " locale_code
		fi

		# Get hostname
		read -p "Hostname: " hostname

		# Multilib
		# Get multilib enable/disable confirmation
		read -p "Enable multilib 64-bit control? [Y|N]: " enable_multilib

		# Bootloader
		read -p "Bootloader [Grub/Syslinux]: " bootloader
	else
		add_additional="$2"
		if [ "$add_additional" == "Y" ]; then
			read -p "Other packages: " other_pkgs
			default_pacstrap+=" $other_pkgs"
		fi
		pacstrap_pkgs=$default_pacstrap

		if [ -z "$3" ]; then
			# Get User info
			ls /usr/share/zoneinfo/
			read -p "Region?: " region

			ls /usr/share/zoneinfo/$region/
			read -p "City?: " city
	
			read -p "Locale code? [en_SG.UTF-8, en_US.UTF-8] (Type 'h' to view locales): " locale_code
			if [ "$locale_code" == "h" ]; then
				cat /etc/locale.gen
				read -p "Locale code? [en_SG.UTF-8, en_US.UTF-8]: " locale_code
			fi
			
			# Get hostname
			read -p "Hostname: " hostname

			# Multilib
			# Get multilib enable/disable confirmation
			read -p "Enable multilib 64-bit control? [Y|N]: " enable_multilib

			# Bootloader
			read -p "Bootloader [Grub/Syslinux]: " bootloader
		else
			region="$3"
			if [ -z "$4" ]; then
				ls /usr/share/zoneinfo/$region/
				read -p "City?: " city
	
				read -p "Locale code? [en_SG.UTF-8, en_US.UTF-8] (Type 'h' to view locales): " locale_code
				if [ "$locale_code" == "h" ]; then
					cat /etc/locale.gen
					read -p "Locale code? [en_SG.UTF-8, en_US.UTF-8]: " locale_code
				fi

				# Get hostname
				read -p "Hostname: " hostname

				# Multilib
				# Get multilib enable/disable confirmation
				read -p "Enable multilib 64-bit control? [Y|N]: " enable_multilib

				# Bootloader
				read -p "Bootloader [Grub/Syslinux]: " bootloader

			else
				city="$4"
	
				if [ -z "$5" ]; then
					read -p "Locale code? [en_SG.UTF-8, en_US.UTF-8] (Type 'h' to view locales): " locale_code
					if [ "$locale_code" == "h" ]; then
						cat /etc/locale.gen
						read -p "Locale code? [en_SG.UTF-8, en_US.UTF-8]: " locale_code
					fi

					# Get hostname
					read -p "Hostname: " hostname

					# Multilib
					# Get multilib enable/disable confirmation
					read -p "Enable multilib 64-bit control? [Y|N]: " enable_multilib

					# Bootloader
					read -p "Bootloader [Grub/Syslinux]: " bootloader
				else
					locale_code="$5"
					if [ "$locale_code" == "h" ]; then
						cat /etc/locale.gen
						read -p "Locale code? [en_SG.UTF-8, en_US.UTF-8]: " locale_code
					fi

					if [ -z "$6" ]; then
						# Get hostname
						read -p "Hostname: " hostname

						# Get multilib enable/disable confirmation
						read -p "Enable multilib 64-bit control? [Y|N]: " enable_multilib			# To enable multilib/leave it
					
						# Bootloader
						read -p "Bootloader [Grub/Syslinux]: " bootloader
					else
						hostname="$6"

						if [ -z "$7" ]; then
							# Get multilib enable/disable confirmation
							read -p "Enable multilib 64-bit control? [Y|N]: " enable_multilib			# To enable multilib/leave it
						
							# Bootloader
							read -p "Bootloader [Grub/Syslinux]: " bootloader
						else
							enable_multilib="$7"
							if [ -z "$8" ]; then
								# Bootloader
								read -p "Bootloader [Grub/Syslinux]: " bootloader
							else
								bootloader="$8"
							fi
						fi
					fi
				fi
			fi
		fi
	fi
fi

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
echo "Partitioning..."
sudo fdisk -l 
lsblk
part_Options=("(1) View-All-Partitions" "(2) Reformat-New-Label" "(3) Create-Boot-Partition" "(4) Enable-Bootable" "(5) Create-New-Partition" "(Q)uit")
# Get Disk Drive
read -p "Disk Drive (/dev/sda, /dev/sdb, /dev/sdc etc - no numbers behind): " disk_part
bootpart_size=""
rootpart_size=""
homepart_size=""
arr_partition_Types=() # All Partition Types
while [ ! "$opt" == "Quit" ]; do
	for partopt in "${part_Options[@]}"; do
		echo "	$partopt"
	done
	read -p "Option: " opt

	case "$opt" in 
		"1" | "View-All-Partitions")
			sudo fdisk -l
			echo ""
			lsblk
			;;
		"2" | "Reformat-New-Label") 
			read -p "Disk Label [msdos (for MBR)|gpt (for UEFI)]: " disk_label
			parted $disk_part mklabel $disk_label
			;;
		"3" | "Create-Boot-Partition")
			# Create boot partition
			read -p "Partition Format [Primary|Logical|Extension]: " partition_format
			read -p "Partition Type [ext4|fat32|etc]: " partition_type
			read -p "Boot Partition Size (in MiB [example: 1024MiB]/GiB [example: 1GiB]): " bootpart_size
			read -p "Boot Partition Number (1 for Partition 1, 2 for Partition 2 etc): " bootpart_number
			parted $disk_part mkpart $partition_format $partition_type 1MiB $bootpart_size
			parted $disk_part set $bootpart_number boot on
			bootpart_size=$bootpart_size
			arr_partition_Types+=("$partition_type")
			;;
		"4" | "Enable-Bootable")
			read -p "Boot Partition number: " bootpart_number
			parted $disk_part set $bootpart_number boot on
			;;
		"5" | "Create-New-Partition") 
			read -p "Partition Format [Primary|Logical|Extension]: " partition_format
			read -p "Partition Type [ext4|fat32|etc]: " partition_type
			read -p "Partition Starting Size (in MiB [example: 1024MiB]/GiB [example: 1GiB]): " part_start_size
			read -p "Partition Ending   Size (in MiB [example: 1024MiB]/GiB [example: 1GiB]) (NOTE: put 100% to use the remainder of the space): " part_end_size
			parted $disk_part mkpart $partition_format $partition_type $part_start_size $part_end_size
			arr_partition_Types+=("$partition_type")
			;;
		"Q" | "Quit")
			echo "Quit"
			;;
		*) echo "Invalid option"
			;;
	esac
done

number_of_partitions="$(lsblk | grep $disk_part | sed -n '1!p' | wc -l)"

# parted $disk_part mklabel $disk_label									#msdos (MBR)/gpt (UEFI)
# parted $disk_part mkpart primary ext4 1MiB $bootpart_size				# Partition 1 : Boot
# parted $disk_part set 1 boot on											# Enable Bootable for Boot Partition
# parted $disk_part mkpart primary ext4 $bootpart_size $rootpart_size		# Partition 2 : Root
# parted $disk_part mkpart primary ext4 $rootpart_size 100%						# Partition 3 : Home; Use Remainder of the space

i=0
for type in ${arr_partition_Types[@]}; do
	# for ((i=1; i<=$number_of_partitions; i++)); do
	# 	read -p "Partition Type [ext4|fat32|etc]: " 
	# done
	# mkfs.ext4 $disk_part1													# ext4 
	# mkfs.ext4 $disk_part2
	# mkfs.ext4 $disk_part3
	i=$((i+1))
	echo "Type: $type"
	case "$type" in
		"fat32")mkfs.fat -F32 $disk_part$i
				;;
		"ext4")mkfs.ext4 $disk_part$i
				;;
		*) 	echo "Invalid format type"
	esac
done
echo "Partitioning completed."

# Mount
#mount $disk_part2 /mnt
#mkdir -p /mnt/boot
#mount $disk_part1 /mnt/boot
#mkdir -p /mnt/home
#mount $disk_part3 /mnt/home
read -p "Partition to mount /mnt [/dev/sdXY (/dev/sdX2)]: " mntpart # i.e. /dev/sdX2
mount $mntpart /mnt # Start with mount directory

# To be debugged [1]
# for ((count=0; count<=$number_of_partitions-1; count++)); do
# 	# 
# 	# Examples:
# 	# =========================
# 	# mntpart: /dev/sdX1
# 	# dir_to_make: /mnt/boot
# 	# mkdir -p /mnt/boot
# 	# mount /dev/sdX1 /mnt/boot
# 	# =========================
# 	# mntpart: /dev/sdX3
# 	# dir_to_make: /mnt/home
# 	# mkdir -p /mnt/home
# 	# mount /dev/sdX3 /mnt/home
# 	# =========================
# 	# 
# 	read -p "Target partition to mount [/dev/sdXY [(/dev/sdX1) | (/dev/sdX3)]]: " otherpart
# 	read -p "Make Directory: " dir_to_make
# 	mkir -p $dir_to_make
# 	mount $otherpart $dir_to_make
# done
# Temporary measure - manual
mkdir -p /mnt/boot
read -p "Partition to mount /mnt/boot [/dev/sdXY (dev/sdX1)]: " bootmntpart
mount $bootmntpart /mnt/boot
mkdir -p /mnt/home
read -p "Partition to mount /mnt/home [/dev/sdXY (dev/sdX3)]: " homemntpart
mount $homemntpart /mnt/home

# Pacstrap libraries
echo "Starting to strap packages [$pacstrap_pkgs] to /mnt..."
echo ""

pacstrap /mnt $pacstrap_pkgs  								# NOTES: These are the minimal for installations; Strap libraries to /mnt (ArchLinux Kernel etc.)

echo "Package strap completed."
echo ""

# Generate an fstab file
genfstab -U /mnt >> /mnt/etc/fstab 							

# arch-chroot /mnt doesnt work because
# doing so will just go to the new root and ignore all other comments
# arch-chroot /mnt 									# Change root to Arch Mount/Root

# After mounting
arch-chroot /mnt ln -sf /usr/share/zoneinfo/$region/$city /etc/localtime 				# Set timezone
arch-chroot /mnt hwclock --systohc 									# Sync and Generate /etc/adjtime using hwclock
arch-chroot /mnt sed -i '/$locale_code/s/^#//g' /etc/locale.gen 						# Uncomment locale
arch-chroot /mnt locale-gen 										# Generate locale
# Create Locale Cnfig
arch-chroot /mnt echo "LANG=$locale_code" >> /etc/locale.conf 						
arch-chroot /mnt echo "KEYMAP=$key_layout" >> /etc/vconsole.conf
if [ "$enable_multilib" == "Y" ]; then
	arch-chroot /mnt sed -i "/\[multilib\]/,/Include/"'s/^#//' /etc/pacman.conf
	arch-chroot /mnt pacman -Sy
fi
arch-chroot /mnt echo "$hostname" >> /etc/hostname 
# Create Hostname
arch-chroot /mnt echo "127.0.0.1	localhost" >> /etc/hosts 
arch-chroot /mnt echo "::1       localhost" >> /etc/hosts 
# 7 empty spaces to localhost
arch-chroot /mnt echo "127.0.1.1	$hostname.localdomain	$hostname" >> /etc/hosts
echo "[Make initialcp i/o kernels]"
arch-chroot /mnt mkinitcpio -P linux	# Initialize and create new ram file system
arch-chroot /mnt mkinitcpio -P linux-lts # Initialize and create new ram file system
echo "[Set root password]"
arch-chroot /mnt passwd 			# Set Root Password
arch-chroot /mnt sed -i '/%wheel ALL=(ALL) ALL/s/^#//g' /etc/sudoers 					# Allow new users to run sudo; PLEASE DO NOT USE SCRIPTS TO EDIT SUDOERS, use [EDITOR=<your editor> visudo]
arch-chroot /mnt bash -c 'echo "Y" | pacman -S os-prober'
# Install Bootloader
case "$bootloader" in 
	"Grub")
		arch-chroot /mnt bash -c 'echo "Y" | pacman -S grub'
		# arch-chroot /mnt grub-mkconfig -o /boot/grub/grub.cfg
		arch-chroot /mnt bash -c 'cd /boot; mkdir -p grub'
		arch-chroot /mnt bash -c 'cd /boot/grub; grub-mkconfig -o grub.cfg'
		arch-chroot /mnt grub-install --target=i386-pc --debug $disk_part
		;;
	*) arch-chroot /mnt echo "Invalid Bootloader, apologies - you will need to install the bootloader manually"
		;;
esac

echo "Installation process via script has been completed."

echo ""

# ------- Post Install
todoset=("Network Management" "User Control" "Additional Package Control" "Create Home Directory")
todoset_description=(
	"
	Network Management : 
		1. Install Network packages (i.e. netctl, networkmanager)
	User Control:
		1. Create user/admin accounts
	Additional Package Control:
		1. Install other packages
	Create Home Directory:
		1. Create dotfolders/dotfiles/folders required in desktop
	"
)
echo "Recommended things to do:"
for todo in "${todoset[@]}"; do
	echo "	$todo"
done

echo ""

echo "Description"
for tododesc in "${todoset_description[@]}"; do
	echo "	$tododesc"
done
# ----------------------

echo ""

read -p "Reboot? [Y|N]: " reboot_confirm
if [ "$reboot_confirm" == "Y" ]; then
# 	exit
#	umount -l /mnt
	echo "Rebooting in 3 seconds..."
	sleep 3
	reboot
fi