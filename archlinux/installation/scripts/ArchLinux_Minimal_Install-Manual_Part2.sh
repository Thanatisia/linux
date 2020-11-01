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
	# Keyboard Layout
	read -p "Keyboard Layout: " key_layout

	# Region, City, Locales
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
	key_layout="$1"

	if [ -z "$2" ]; then
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
		region="$2"

		if [ -z "$3" ]; then
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
			city="$3"

			if [ -z "$4" ]; then
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
				locale_code="$4"
				if [ "$locale_code" == "h" ]; then
					cat /etc/locale.gen
					read -p "Locale code? [en_SG.UTF-8, en_US.UTF-8]: " locale_code
				fi

				if [ -z "$5" ]; then
					# Get hostname
					read -p "Hostname: " hostname

					# Get multilib enable/disable confirmation
					read -p "Enable multilib 64-bit control? [Y|N]: " enable_multilib			# To enable multilib/leave it

					# Bootloader
					read -p "Bootloader [Grub/Syslinux]: " bootloader
				else
					hostname="$5"

					if [ -z "$6" ]; then
						# Get multilib enable/disable confirmation
						read -p "Enable multilib 64-bit control? [Y|N]: " enable_multilib			# To enable multilib/leave it

						# Bootloader
						read -p "Bootloader [Grub/Syslinux]: " bootloader
					else
						multilib="$6"

						if [ -z "$7" ]; then
							# Bootloader
							read -p "Bootloader [Grub/Syslinux]: " bootloader
						else
							bootloader="$7"
						fi
					fi
				fi
			fi
		fi
	fi
fi

# ------------------- End of User Info ------------------- #

# After mounting
ln -sf /usr/share/zoneinfo/$region/$city /etc/localtime 				# Set timezone
hwclock --systohc 									# Sync and Generate /etc/adjtime using hwclock
sed -i '/$locale_code/s/^#//g' /etc/locale.gen 						# Uncomment locale
locale-gen 										# Generate locale
echo "LANG=$locale_code" >> /etc/locale.conf 						# Create Locale Cnfig
echo "KEYMAP=$key_layout" >> /etc/vconsole.conf
if [ "$enable_multilib" == "Y" ]; then
	sed -i "/\[multilib\]/,/Include/"'s/^#//' /etc/pacman.conf
fi
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