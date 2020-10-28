# Command Line Variable
# $1 : Files to add
# $2 : Commit message
# $3 : Origin to push to
cd $PWD

if [ ! -z $1 ]; then
	files=$1

	if [ ! -z "$2" ]; then
		msg="$2"

		if [ ! -z $3 ]; then 
			origin=$3
		else
			read -p "Target origin: " origin
		fi
	else
		read -p "Commit message: " msg
		read -p "Target origin: " origin
	fi
else
	read -p "File to upload: " files
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
logname_push="gitpushed.log"		# Filename containing made files and date & time
logname_proc="gitpush-proc.log"		# Makelog Process Masterlog; To append all logs while make here
log_pushed=$logpath/$logname_push
log_proc=$logpath/$logname_proc

# Commands

# Output to Make logs
echo "#######################" | tee -a $log_proc
echo "# $datetime #" | tee -a $log_proc
echo "#######################" | tee -a $log_proc

echo "Command: " | tee -a $log_proc
echo "	git add $files |& tee -a $log_proc" | tee -a $log_proc
echo "	git commit -m "$msg" |& tee -a $log_proc" | tee -a $log_proc
echo "	git push origin $origin |& tee -a $log_proc" | tee -a $log_proc

echo "==============" | tee -a $log_proc
echo "Push process:" | tee -a $log_proc
echo "==============" | tee -a $log_proc
git add $files |& tee -a $log_proc # Add files to prepare for commit
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
	echo "$datetime : $files" | tee -a $log_pushed
fi
