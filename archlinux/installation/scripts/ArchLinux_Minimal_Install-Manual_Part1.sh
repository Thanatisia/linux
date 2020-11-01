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

	# Get Packages (Package control)
	echo "Default Pacstrap: $default_pacstrap"
	# read -p "Add anymore packages? [Y|N]: " add_additional
	# if [ "$add_additional" == "Y" ]; then
	# 	read -p "Other packages: " other_pkgs
	# 	default_pacstrap+=" $other_pkgs"
	# fi
	read -p "Option [ a : Add more packages | r : Remove package from default | q : Quit ]: " pkg_opt
	while [ ! "$pkg_opt" == "q" ]; do
		case "$pkg_opt" in 
			"a") read -p "Other packages: " other_pkgs
				default_pacstrap+=" $other_pkgs"
				;;
			"r") read -p "Target package: " target_pkg
				# Remove substring
				default_pacstrap="${default_pacstrap//$target_pkg /}" 
				;;
			*) echo "Invalid option"
				;;
		esac
		read -p "Option [ a : Add more packages | r : Remove package from default | q : Quit ]: " pkg_opt
	done
	pacstrap_pkgs=$default_pacstrap
else
	key_layout_change="$1"
	if [ "$key_layout_change" == "Y" ]; then
		ls /usr/share/kbd/keymaps/**/*.map.gz
		read -p "Keyboard Layout?: " key_layout
	fi

	if [ -z "$2" ]; then
		# Get Packages (Package control)
		echo "Default Pacstrap: $default_pacstrap"
		# read -p "Add anymore packages? [Y|N]: " add_additional
		# if [ "$add_additional" == "Y" ]; then
		# 	read -p "Other packages: " other_pkgs
		# 	default_pacstrap+=" $other_pkgs"
		# fi
		read -p "Option [ a : Add more packages | r : Remove package from default | q : Quit ]: " pkg_opt
		while [ ! "$pkg_opt" == "q" ]; do
			case "$pkg_opt" in 
				"a") read -p "Other packages: " other_pkgs
					default_pacstrap+=" $other_pkgs"
					;;
				"r") read -p "Target package: " target_pkg
					# Remove substring
					default_pacstrap="${default_pacstrap//$target_pkg /}" 
					;;
				*) echo "Invalid option"
					;;
			esac
			read -p "Option [ a : Add more packages | r : Remove package from default | q : Quit ]: " pkg_opt
		done
		pacstrap_pkgs=$default_pacstrap
	else
		pacstrap_pkgs="$2"
	fi
fi

# ------------------- End of User Info ------------------- #

# -- Process
if [ ! -z "$key_layout" ]; then
	# Not empty
	echo "Loading key layout [$key_layout]..."
	loadkeys $key_layout
fi

echo ""

echo "Checking UEFI..."
if [ "$(ls /sys/firmware/efi/efivars)" ]; then
	is_uefi=True
fi
echo ""

echo "Setting Network Transport Protocol (ntp)..."
timedatectl set-ntp true
echo ""

echo "Partitioning..."
sudo fdisk -l 
lsblk
part_Options=("View-All-Partitions" "Reformat-New-Label" "Create-Boot-Partition" "Enable-Bootable" "Create-New-Partition" "Quit")
# Get Disk Drive
read -p "Disk Drive (/dev/sda, /dev/sdb, /dev/sdc etc - no numbers behind): " disk_part
bootpart_size=""
rootpart_size=""
homepart_size=""
arr_partition_Types=() # All Partition Types
opt=""
while [ ! "$opt" == "Quit" ]; do
	for partopt in ${part_Options[@]}; do
		echo "	$partopt"
	done
	read -p "Option: " opt

	case "$opt" in 
		"View-All-Partitions")
			sudo fdisk -l
			echo ""
			lsblk
			;;
		"Reformat-New-Label") 
			read -p "Disk Label [msdos (for MBR)|gpt (for UEFI)]: " disk_label
			parted $disk_part mklabel $disk_label
			;;
		"Create-Boot-Partition")
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
		"Enable-Bootable")
			read -p "Boot Partition number: " bootpart_number
			parted $disk_part set $bootpart_number boot on
			;;
		"Create-New-Partition") 
			read -p "Partition Format [Primary|Logical|Extension]: " partition_format
			read -p "Partition Type [ext4|fat32|etc]: " partition_type
			read -p "Partition Starting Size (in MiB [example: 1024MiB]/GiB [example: 1GiB]): " part_start_size
			read -p "Partition Ending   Size (in MiB [example: 1024MiB]/GiB [example: 1GiB]) (NOTE: put 100% to use the remainder of the space): " part_end_size
			parted $disk_part mkpart $partition_format $partition_type $part_start_size $part_end_size
			arr_partition_Types+=("$partition_type")
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
echo ""

# Mount
#mount $disk_part2 /mnt
#mkdir -p /mnt/boot
#mount $disk_part1 /mnt/boot
#mkdir -p /mnt/home
#mount $disk_part3 /mnt/home

echo "Mounting..."
# read -p "Mount partition [/dev/sdXY - i.e. /dev/sda2]: " mntpart # i.e. /dev/sdX2
read -p "Partition to mount /mnt [/dev/sdXY (i.e. /dev/sdX2)]: " mntpart
mount $mntpart /mnt # Start with mount directory
echo ""

echo "Creating other directories and mounting..."
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
# 	read -p "Other partition to mount [/dev/sdXY - i.e. /dev/sda2]: " otherpart
# 	read -p "Make Directory: " dir_to_make
# 	mkir -p $dir_to_make
# 	mount $otherpart $dir_to_make
# done

# For Debugging
echo "Number of Partitions: $number_of_partitions"
read -p "Pause" pause

echo "Directories mounted."
echo ""

echo "Strapping packages to mount partition..."
# Pacstrap libraries
pacstrap /mnt $pacstrap_pkgs  								# NOTES: These are the minimal for installations; Strap libraries to /mnt (ArchLinux Kernel etc.)
echo "Package strapping completed."
echo ""

# Generate an fstab file
echo "Generating File Systems Tab..."
genfstab -U /mnt >> /mnt/etc/fstab 		
echo "File Systems tab generated"
echo ""

# Changing root to mounted /mnt
echo "Changing root to mounted /mnt..."
echo "Please run the following command to retrieve part 2 of the install script and"
echo "Save it in the new root"
echo "I recommend saving it in [/usr/bin/ArchLinux_Minimal_Install-Manual_Part2.sh] to be able to install without being in directory."
echo "Command: "
echo "curl -o \"ArchLinux_Minimal_Install-Manual_Part2\" \"[/usr/bin/ArchLinux_Minimal_Install-Manual_Part2.sh]\""
arch-chroot /mnt 									# Change root to Arch Mount/Root
