##################################################
# Create a menu (either through select or dmenu)
# for git
#################################################
cd $PWD

if [ ! -z "$1" ]; then
	msg="$1"

	if [ ! -z $2 ]; then 
		origin=$2
	else
		read -p "Target origin: " origin
	fi
else
	read -p "Commit message: " msg
	read -p "Target origin: " origin
fi

# Defaults
if [ "$origin" == " " ]; then
	origin="master"
fi

# Global Variables
datetime="$(date +'%m/%d/%Y %H:%M:%S')"
logpath=~/.logs/				# .logs hidden directory - create if does not exist
# check if log path exists
if [ ! -d $logpath ]; then
	# Does not exist, create
	mkdir $logpath
fi
logname_menu="gitmenu.log"		# Filename containing made files and date & time
logname_proc="gitmenu-proc.log"		# Makelog Process Masterlog; To append all logs while make here
log_menu=$logpath/$logname_menu
log_proc=$logpath/$logname_proc

# Arrays
GIT_OPTIONS=("Remove" "Push" "Clone")

# Commands

# Output to Make logs
echo "#######################" | tee -a $log_proc
echo "# $datetime #" | tee -a $log_proc
echo "#######################" | tee -a $log_proc

echo "Git Options:"
for opt in ${GIT_OPTIONS[@]}; do
	echo "	$opt"
done
read -p "Select your action: " action
read -p "Content name: " files

case "$action" in
	"Remove") 
			read -p "Object type to remove [Files|Folders]: " obj_type
			echo "Command: " | tee -a $log_proc
			if [ "$obj_type" == "Folders" ]; then
				echo "	git rm -r $files |& tee -a $log_proc" | tee -a $log_proc
			else
				echo "	git rm $files |& tee -a $log_proc" | tee -a $log_proc
			fi
			echo "	git commit -m "$msg" |& tee -a $log_proc" | tee -a $log_proc
			echo "	git push origin $origin |& tee -a $log_proc" | tee -a $log_proc

			echo "==============" | tee -a $log_proc
			echo "Remove process:" | tee -a $log_proc
			echo "==============" | tee -a $log_proc
			if [ "$obj_type" == "Folders" ]; then
				git rm -r $files |& tee -a $log_proc
			else
				git rm $files |& tee -a $log_proc
			fi
			# After performing actions
			git commit -m "$msg" |& tee -a $log_proc
			git push origin $origin |& tee -a $log_proc
			;;
	"Push")
			echo "Command: " | tee -a $log_proc
			echo "	git add $files |& tee -a $log_proc" | tee -a $log_proc
			echo "	git commit -m "$msg" |& tee -a $log_proc" | tee -a $log_proc
			echo "	git push origin $origin |& tee -a $log_proc" | tee -a $log_proc
			
			echo "==============" | tee -a $log_proc
			echo "Push process:" | tee -a $log_proc
			echo "==============" | tee -a $log_proc
			git add $files |& tee -a $log_proc # Add files to prepare for commit
			# After performing actions
			git commit -m "$msg" |& tee -a $log_proc
			git push origin $origin |& tee -a $log_proc
			;;
	"Clone") read -p "Repository URL: " repo_url
			read -p "Repository Name: " repo_name 
			git clone $repo_url |& tee -a $log_proc
			;;
	*)echo "Invalid option"
			;;
esac


# command_success_check="$?"
# Check folder
command_success_check="$?"

# Check if package update was successful
if [ "$command_success_check" == "0" ]; then
	# Output to updated packages log
	#echo "Repository Package has been cloned."
	#echo "#######################" | tee -a $log_pushed
	#echo "# $datetime #" | tee -a $log_pushed
	#echo "#######################" | tee -a $log_pushed
	#echo "$repo_name" | tee -a $log_pushed
	#echo "$repo_url" | tee -a $log_pushed
	echo "$datetime : $files" | tee -a $log_menu
fi
