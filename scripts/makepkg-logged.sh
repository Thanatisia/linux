# Command Line Variable
# argc="$#"
# argv="$@"

if [ ! -z "$1" ]; then
	repo_name="$1"

	if [ ! -z "$2" ]; then
		repo_url="$2"
	else
		read -p "Repository URL: " repo_url
	fi
else
	read -p "Repository Name: " repo_name
	read -p "Repository URL : " repo_url
fi

# Global Variables
datetime="$(date +'%m/%d/%Y %H:%M:%S')"
logpath=~/.logs/				# .logs hidden directory - create if does not exist

# check if log path exists
if [ ! -d $logpath ]; then
	# Does not exist, create
	mkdir $logpath
fi
logname_makepkg="makepkgs.log"		# Filename containing made files and date & time
logname_process="makeproc.log"		# Makelog Process Masterlog; To append all logs while make here
log_pkgs=$logpath/$logname_makepkg
log_proc=$logpath/$logname_proc

# Commands

# Output to Make logs
echo "#######################" | tee -a $log_proc
echo "# $datetime #" | tee -a $log_proc
echo "#######################" | tee -a $log_proc

echo "Command: " | tee -a $log_proc
echo "	makepkg -s | tee -a $log_proc" | tee -a $log_proc
echo "	makepkg -i | tee -a $log_proc" | tee -a $log_proc

echo "===============" | tee -a $log_proc
echo "Makeplg process:" | tee -a $log_proc
echo "===============" | tee -a $log_proc
makepkg -s | tee -a $log_proc
makepkg -i | tee -a $log_proc

# command_success_check="$?"
command_success_check="$(which $repo_name)"

# Check if package update was successful
if [ ! -z "$command_success_check" ]; then
	# Output to updated packages log
	echo "Repository Package has been made."
	echo "#######################" | tee -a $log_pkgs
	echo "# $datetime #" | tee -a $log_pkgs
	echo "#######################" | tee -a $log_pkgs
	echo "$repo_name" | tee -a $log_pkgs
	echo "$repo_url" | tee -a $log_pkgs
fi
