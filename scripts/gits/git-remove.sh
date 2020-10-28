# Command Line Variable
# $1 : Remove object type (files/folder)
# $2 : Commit message
# $3 : Origin to push to
cd $PWD # change to terminal path

if [ ! -z $1 ]; then
	type_to_remove=$1

	if [ ! -z $2 ]; then
		content=$2

		if [ ! -z "$3" ]; then
			msg="$3"

			if [ ! -z $4 ]; then
				origin=$4
			else
				read -p "Target origin: " origin
			fi
		else
			read -p "Commit message: " msg
			read -p "Target origin: " origin
		fi
	else
		read -p "Content to remove: " content
		read -p "Commit message: " msg
		read -p "Target origin: " origin
	fi
else
	read -p "Object Type to remove [File | Folder]: " type_to_remove
	read -p "Content to remove: " content
	read -p "Commit message: " msg
	read -p "Target origin: " origin
fi

# Global Variables
datetime="$(date +'%m/%d/%Y %H:%M:%S')"
logpath=~/.logs/				# .logs hidden directory - create if does not exist
# check if log path exists
if [ ! -d $logpath ]; then
	# Does not exist, create
	mkdir $logpath
fi
logname_remove="gitpushed.log"		# Filename containing made files and date & time
logname_proc="gitrm-proc.log"		# Makelog Process Masterlog; To append all logs while make here
log_remove=$logpath/$logname_remove
log_proc=$logpath/$logname_proc

# Commands

# Output to Make logs
echo "#######################" | tee -a $log_proc
echo "# $datetime #" | tee -a $log_proc
echo "#######################" | tee -a $log_proc

echo "Command: " | tee -a $log_proc
echo "	git rm -r $content |& tee -a $log_proc" | tee -a $log_proc
echo "	git commit -m "$msg" |& tee -a $log_proc" | tee -a $log_proc
echo "	git push origin $origin |& tee -a $log_proc" | tee -a $log_proc

echo "==============" | tee -a $log_proc
echo "Remove process:" | tee -a $log_proc
echo "==============" | tee -a $log_proc
if [ "$type_to_remove" == "Folder" ]; then
	git rm -r $content |& tee -a $log_proc # Remove folder from the git
else
	git rm $content |& tee -a $log_proc # Remove files from the git
fi
git commit -m "$msg" |& tee -a $log_proc
git push origin $origin |& tee -a $log_proc

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
	echo "$datetime : $content" | tee -a $log_remove
fi
