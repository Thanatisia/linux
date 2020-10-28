# Command Line Variable
# argc="$#"
# argv="$@"

# Global Variables
datetime="$(date +'%m/%d/%Y %H:%M:%S')"
logpath=~/.logs/				# .logs hidden directory - create if does not exist

# check if log path exists
if [ ! -d $logpath ]; then
	# Does not exist, create
	mkdir $logpath
fi
logname_updates="changelog.log"		# Filename containing changes from update/upgrade and date & time
logname_process="updateproc.log"	# Update Process Masterlog
log_proc=$logpath/$logname_process
log_upd=$logpath/$logname_updates

# Commands
# get previous versions
prev_vers="$(pacman -Q)"

# Output to Updater logs
echo "#######################" | tee -a $log_proc
echo "# $datetime #" | tee -a $log_proc
echo "#######################" | tee -a $log_proc

echo "Command: sudo pacman -Syyu | tee -a $log_proc" | tee -a $log_proc
echo "Updates:" | tee -a $log_proc
sudo pacman -Syyu | tee -a $log_proc

new_vers="$(pacman -Q)"

command_success_check="$?"

# Check if package update was successful
if [ "$command_success_check"==0 ]; then
	# Output to updated packages log
	echo "Package has been updated."
	echo "#######################" | tee -a $log_upd
	echo "# $datetime #" | tee -a $log_upd
	echo "#######################" | tee -a $log_upd
	echo "$new_vers" | tee -a $log_upd
fi
