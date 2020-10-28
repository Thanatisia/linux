# Command Line Variable
# argc="$#"
# argv="$@"

if [ ! -z "$1" ]; then
	repo_url="$1"

	if [ ! -z "$2" ]; then
		repo_name="$2"
	else
		read -p "Repository Name: " repo_name
	fi
else
	read -p "Repository URL : " repo_url
	read -p "Repository Name: " repo_name
fi

# Global Variables
datetime="$(date +'%m/%d/%Y %H:%M:%S')"
logpath=~/.logs/				# .logs hidden directory - create if does not exist

# check if log path exists
if [ ! -d $logpath ]; then
	# Does not exist, create
	mkdir $logpath
fi
logname_clone="gitpkgs.log"		# Filename containing made files and date & time
logname_proc="gitclone-proc.log"		# Makelog Process Masterlog; To append all logs while make here
log_pkgs=$logpath/$logname_clone
log_proc=$logpath/$logname_proc

# Commands

# Output to Make logs
echo "#######################" | tee -a $log_proc
echo "# $datetime #" | tee -a $log_proc
echo "#######################" | tee -a $log_proc

echo "Command: " | tee -a $log_proc
# echo "	make | tee -a $log_proc" | tee -a $log_proc
echo "	git clone $repo_url | tee -a $log_proc" | tee -a $log_proc
# echo "	make clean | tee -a $log_proc" | tee -a $log_proc

echo "==============" | tee -a $log_proc
echo "Clone process:" | tee -a $log_proc
echo "==============" | tee -a $log_proc
# make | tee -a $log_proc
# git clone --progress $repo_url | tee -a $log_proc
git clone --progress $repo_url |& tee -a $log_proc
# make clean | tee -a $log_proc

# command_success_check="$?"
# Check folder
command_success_check="$?"

# Check if package update was successful
if [ "$command_success_check" == "0" ]; then
	# Output to updated packages log
	echo "Repository Package has been cloned."
	echo "#######################" | tee -a $log_pkgs
	echo "# $datetime #" | tee -a $log_pkgs
	echo "#######################" | tee -a $log_pkgs
	echo "$repo_name" | tee -a $log_pkgs
	echo "$repo_url" | tee -a $log_pkgs
fi
