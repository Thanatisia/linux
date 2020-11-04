################################
# Lockscreen Management        #
# This controls the Lockscreen #
################################

# Functions
function get_datetime()
{
	DEFAULT_DT_FORMAT='%Y-%m-%d_%H-%M-%S'
	dt=""
	# if format is not provided - take "now"
	if [ -z "$1" ]; then
		dt="$(date +$DEFAULT_DT_FORMAT)H"
	else
		USER_DT_FORMAT="$1"
		dt="$(date +$USER_DT_FORMAT)"
	fi
	echo "$dt"
}

# Constants
IMAGE_PATH=~/globals/i3lock/wallpaper/png/lockscreen.png

# Global Variables
# now="$(date +'%Y-%m-%d_%H-%M-%S')H"
now="$(get_datetime)"

# Program Variables
LOCKER_PROG=i3lock
LOCKER_OPTIONS="-i $IMAGE_PATH --tiling --show-failed-attempts"
LOCKER="$LOCKER_PROG $LOCKER_OPTIONS"
INACTIVITY_TIMEOUT=1	

# For Debugging and Logging Purposes
LOG_FLDR=~/.logs
if [ ! -d "$LOG_FLDR" ]; then
	# Log folder does not exist
	mkdir "$LOG_FLDR"
fi
# LOG_FILE="i3lock-logs"
LOG_FILE="$LOCKER_PROG-logs"
LOG="$LOG_FLDR/$LOG_FILE"

# Lock the screen
# Log the date after unlocking
echo "Locked at $now" | tee -a $LOG
$LOCKER | tee -a $LOG && now="$(get_datetime)" && echo "Unlocked at $now" | tee -a $LOG
