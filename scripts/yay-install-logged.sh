# Command Line Variables
if [ -z "$1" ]; then
	read -p "Packages to install: " packages
else
	 # packages="$1"
	packages="$*"
fi

argc="$#"

# Global Variables
datetime="$(date +'%m/%d/%Y %H:%M:%S')"
logpath=~/.logs/				# .logs hidden directory - create if does not exist

# check if log path exists
if [ ! -d $logpath ]; then
	# Does not exist, create
	mkdir $logpath
fi
logname_pkgs="aur_packages.log"		# Filename containing installed packages and date & time
logname_process="aur_installproc.log"	# Install Process
log_proc=$logpath/$logname_process
log_pkgs=$logpath/$logname_pkgs

# Commands

# Output to Installer logs
echo "#######################" | tee -a $log_proc
echo "# $datetime #" | tee -a $log_proc
echo "#######################" | tee -a $log_proc

echo "Command: sudo yay -S $packages | tee -a $log_proc" | tee -a $log_proc
echo "Packages: $packages" | tee -a $log_proc

yay -S $packages | tee -a $log_proc

# Check if package installation was successful
if [ ! -z "$(pacman -Qq | grep $packages)" ]; then
	# Output to installed packages log
	echo "Package has been installed."
	echo "#######################" | tee -a $log_pkgs
	echo "# $datetime #" | tee -a $log_pkgs
	echo "#######################" | tee -a $log_pkgs
	echo "$packages" | tee -a $log_pkgs
fi
