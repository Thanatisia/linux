################################################
# Autolocker Management                        #
# This controls the autolocking mechanissm     #
# After a set amount of inactivity (Condition) #
#	- Screen is to lock                        #
################################################
now="$(date +'%Y-%m-%d_%H-%M-%S')H"

# Change your locker here
# Normal locker - no blur
# -- LOCKER="~/globals/i3lock/locker.sh"
# Blur locker

# LOCKER=~/globals/i3lock/lock-blur.sh
LOCKER=$1 # Get from user

# Inactivity Timeout - This is in minutes; 
# Example:
#	INACTIVITY_TIMEOUT=1 : 1 minute after inactivity
#	INACTIVITY_TIMEOUT=3 : 3 minutes after inactivity
INACTIVITY_TIMEOUT=3
AUTOLOCKER_PROG=xautolock
AUTOLOCKER_OPTIONS="-time $INACTIVITY_TIMEOUT -locker $LOCKER -detectsleep"
AUTOLOCKER="$AUTOLOCKER_PROG $AUTOLOCKER_OPTIONS"

# For Debugging and Logging Purposes
LOG_FLDR=~/.logs
if [ ! -d "$LOG_FLDR" ]; then
	# Log folder does not exist
	mkdir "$LOG_FLDR"
fi
# LOG_FILE="i3lock-logs.log"
LOG_FILE="xautolock.log"
LOG="$LOG_FLDR/$LOG_FILE"

# echo "Date-Time: $now" | tee -a $LOG
# echo "Launching $AUTOLOCKER_PROG" | tee -a $LOG
# echo "with conditions: " | tee -a $LOG
# echo "$AUTOLOCKER_OPTIONS" | tee -a $LOG
echo "$now : Launching [$AUTOLOCKER_PROG] with conditions [$AUTOLOCKER_OPTIONS]" | tee -a $LOG
echo "---" | tee -a $LOG

# Enable and Start Autolocker
#xautolock -time "$INACTIVITY_TIMEOUT" -locker "$LOCKER" | tee -a $LOG
$AUTOLOCKER | tee -a $LOG || echo "error starting [$AUTOLOCKER]..." | tee -a $LOG

