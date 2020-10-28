######################################################
#        Use Pywal to colour the terminal            #
######################################################

# Constant Variables
SCRIPT="$0"
SCRIPTNAME="$(basename $SCRIPT)"
SCRIPTPATH="$(dirname $SCRIPT)"

# Default Variables
DEFAULT_CATEGORY="General"
DEFAULT_TITLE="Placeholder"
DEFAULT_DESCRIPTION="NIL"
HELP="
Parameters:
	1: Command Line Arguments here
Usage:
	1: $SCRIPTNAME --help
	2: $SCRIPTNAME
"

# Command Line Variables
if [ ! -z "$1" ]; then
	if [ "$1" == "--help" ]; then
		# Get help
		echo "Help:"
		echo "$HELP"
	else
		# Start your command line variables from here
		# If not empty
		# Your first parameter
		PARAM_1="$1"
	fi
else
	# Else condition
	# you can use "read"
	# read -p "Placeholder Text (1st Parameter): " PARAM_1
	read -p "Wallpaper (/path/to/wallpaper.extension): " PARAM_1
	if [ "$PARAM_1" == "" ]; then
		PARAM_1=~/globals/background/jpg/wallpaper.jpg
	fi
fi

# Global Variables
# (OPTIONAL) - Your log file
LOG_FILE_PATH=~/.logs
LOG_FILE_NAME="wal.log"
LOG_FILE="$LOG_FILE_PATH/$LOG_FILE_NAME"

# Constants
date_format='%Y-%m-%d' # Year-Month-Date
time_format='%H-%M-%S' # Hour-Minutes-Seconds
seperator=" "
now="$(date +"$date_format$seperator$time_format")"

if [ ! -z "$PARAM_1" ]; then
	# Your codes if first parameter is not "help"
	# run and update wallpaper
	echo "---" | tee -a $LOG_FILE
	wal -i $PARAM_1 | tee -a $LOG_FILE
fi