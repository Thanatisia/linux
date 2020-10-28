###########################################################
# Lockscreen designer                                     #
#	- Auto-adjust (Autoscale) chosen lockscreen wallpaper #
#		to the monitor's screensize                       #
#	- if multimonitor: take the smaller monitor's size    #
# - Deployed in Production                                    #
#	Based on locker-DEBUG-20201001_1337H.sh               #
###########################################################

# Functions
function get_scale()
{
	# Retrieve Monitor resolution/scale
	# i.e. 1920x1080, 1366x768
	# tmp_SCALE="1920x1080"
	# tmp_SCALE="1366x768"

	# xrandr --current: Get resolution for each monitor
	# grep "*"        : From the resolution retrieved - get the primary monitor with "*"
	# uniq            : Get the unique value
	# awk '{print $1}': Get the first parameter in that array
	# cut -d 'x' -fX  : Cut the string to an array with 'x' being the seperator (i.e. 1920x1080; cut -d 'x' = (1920 1080); -f1 = 1920; -f2 = 1080) ;Where x = Parameter position in the array {1,2,3....} (example: cut-d 'x' = (1920 1080); f1 = 1920; f2 = 1080)
	#	example:
	#	Given resolution = 1920x1080
	#	cut -d 'x' -f1 : 1920
	#	cut -d 'x' -f2 : 1080
	MODE="Biggest"
	Resolution=$(xrandr --current | grep '*' | uniq | awk '{print $1}')
	number_of_displays=$(xrandr --current | grep '*' | uniq | awk '{print $1}' | wc -l)
	smallest_monitor="$(xrandr --current | grep '*' | uniq | awk '{print $1}' | tail -n 1)"
	# if [ "$number_of_displays" == "1" ]; then
	# 	# If equals to 1
	# 	Xaxis="$(xrandr --current | grep '*' | uniq | awk '{print $1}' | cut -d 'x' -f1)"
	# 	Yaxis="$(xrandr --current | grep '*' | uniq | awk '{print $1}' | cut -d 'x' -f2)"
	# else
	# 	if [ "$MODE" == "Biggest" ]; then
	# 		# If more than 1 displays
	# 		# Get the biggest display size
	# 		Xaxis="$(xrandr --current | grep '*' | uniq | awk '{print $1}' | head -n 1 | cut -d 'x' -f1)"
	# 		Yaxis="$(xrandr --current | grep '*' | uniq | awk '{print $1}' | head -n 1 | cut -d 'x' -f2)"
	# 	elif [ "$MODE" == "Lowest" ]; then
	# 		# If more than 1 displays
	# 		# Get the smallest display size
	# 		Xaxis="$(xrandr --current | grep '*' | uniq | awk '{print $1}' | tail -n 1 | cut -d 'x' -f1)"
	# 		Yaxis="$(xrandr --current | grep '*' | uniq | awk '{print $1}' | tail -n 1 | cut -d 'x' -f2)"
	# fi

	case "$number_of_displays" in 
		1) 
			Xaxis="$(xrandr --current | grep '*' | uniq | awk '{print $1}' | cut -d 'x' -f1)"
			Yaxis="$(xrandr --current | grep '*' | uniq | awk '{print $1}' | cut -d 'x' -f2)"
			;;
		*) case "$MODE" in
			"Biggest")
				Xaxis="$(xrandr --current | grep '*' | uniq | awk '{print $1}' | head -n 1 | cut -d 'x' -f1)"
				Yaxis="$(xrandr --current | grep '*' | uniq | awk '{print $1}' | head -n 1 | cut -d 'x' -f2)"
				;;
			"Lowest")
				Xaxis="$(xrandr --current | grep '*' | uniq | awk '{print $1}' | tail -n 1 | cut -d 'x' -f1)"
				Yaxis="$(xrandr --current | grep '*' | uniq | awk '{print $1}' | tail -n 1 | cut -d 'x' -f2)"
				;;
			*) 	
				Xaxis="$(xrandr --current | grep '*' | uniq | awk '{print $1}' | cut -d 'x' -f1)"
				Yaxis="$(xrandr --current | grep '*' | uniq | awk '{print $1}' | cut -d 'x' -f2)"
				;;
			esac
	esac

	tmp_SCALE=""$Xaxis""x"$Yaxis"
	echo "$tmp_SCALE"
}

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

# Global Variables
SCALE=""
SCREENLOCKER=i3lock
MEDIA_PATH=~/Desktop/portable/media/images/
TARGET_IMAGE_PATH="$MEDIA_PATH/TARGET"
TARGET_IMAGE_NAME="nier-automata-system-locked.png"
TARGET_IMAGE="$TARGET_IMAGE_PATH/$TARGET_IMAGE_NAME"

#####################
# Getting wallpaper #
#####################

function generate_lockscreen_image()
{
	#
	# Generating and converting wallpaper according to the 
	# Display's screen/monitor size 
	#  Multimonitor: Take the smaller size
	#
	SCALE=$(get_scale) # <retrieve from monitor>

	# Output
	OUTPUT_PATH=~/globals/$SCREENLOCKER/wallpaper/png/
	OUTPUT_FILENAME="$SCALE.png" # i.e. 1920x1080.png, 1366x768.png
	OUTPUT_FILE=$OUTPUT_PATH/$OUTPUT_FILENAME

	# Input
	if [ ! -z "$1" ]; then
		# INPUT_FILE="/path/to/target/lockscreen/image"
		INPUT_FILE="$1"
	else
		read -p "Input File (/path/to/input/file.extension): " INPUT_FILE
	fi

	# Check input file
	# if no input file - dont convert, 
	# just use "lockscreen.png" in the screenlocker config folder
	if [ ! -z "$INPUT_FILE" ]; then
		# Input file not empty
		# convert_scale.sh "$SCALE" "INPUT_FILE" "OUTPUT_FILE"
		# convert_scale.sh "$SCALE" "$INPUT_FILE" "$OUTPUT_FILE"
		convert -scale $SCALE $INPUT_FILE $OUTPUT_FILE
	else
		# Input file empty
		OUTPUT_FILENAME="lockscreen.png"
		OUTPUT_FILE=$OUTPUT_PATH/$OUTPUT_FILENAME
	fi
	echo $OUTPUT_FILE
}

function check_lockscreen_exists()
{
	local IMAGE_PATH=~/globals/$SCREENLOCKER/wallpaper/png/
	local IMAGE_FILENAME="$(get_scale).png" # i.e. 1920x1080.png, 1366x768.png
	local IMAGE_FILE="$IMAGE_PATH/$IMAGE_FILENAME"
	ALTERNATE_IMAGE_FILENAME="lockscreen.png"
	EXISTS=0
	RESULT="EMPTY"
	if [ -f "$IMAGE_FILE" ]; then
		# File exists
		RESULT="$IMAGE_FILE"
		EXISTS=1
	else
		# File does not exist
		IMAGE_FILE=$IMAGE_PATH/$ALTERNATE_IMAGE_FILENAME
		if [ -f "$IMAGE_FILE" ]; then
			RESULT="$IMAGE_FILE"
			EXISTS=1
		fi
	fi
	echo "$RESULT"
}


################################
# Lockscreen Management        #
# This controls the Lockscreen #
################################

# IMAGE_PATH=~/globals/i3lock/wallpaper/png/lockscreen.png
IMAGE_PATH=~/globals/i3lock/wallpaper/png/
IMAGE_FILE=""

# Get lockscreen image
lockscreen_image=$(check_lockscreen_exists)
# echo "Result: $lockscreen_image"
if [ "$lockscreen_image" == "EMPTY" ]; then
	# Not found; generate
	echo "Target lockscreen image [$TARGET_IMAGE] Not Found"
	IMAGE_FILE="$(generate_lockscreen_image $TARGET_IMAGE)"
else
	# echo "Found"
	IMAGE_FILE="$lockscreen_image"
fi

# Global Variables
# now="$(date +'%Y-%m-%d_%H-%M-%S')H"
now="$(get_datetime)"

# Program Variables
LOCKER_PROG=i3lock
LOCKER_OPTIONS="-i $IMAGE_FILE --tiling --show-failed-attempts -c 000000"
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
echo "Scale: $(get_scale)"
echo "Locked at $now" | tee -a $LOG
$LOCKER | tee -a $LOG && now="$(get_datetime)" && echo "Unlocked at $now" | tee -a $LOG