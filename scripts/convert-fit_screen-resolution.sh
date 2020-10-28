##########################################
# Convert image to fit screen resolution #
# Command Line Parameters:               #
#   $1 : (Input) Target Image Path       #
#   $2 : (Input) Target Image Name       #
#   $3 : (Output) Target Output Path     #
#   $4 : (Output) Target Output Name     #
##########################################

# Command Line Variables
# Get target image path
if [ ! -z "$1" ] ;then
    # Have path
    TARGET_IMAGE_PATH="$1"

    # Get target image name
    if [ ! -z "$2" ]; then
        TARGET_IMAGE_NAME="$2"

        # Target output image path
        if [ ! -z "$3" ]; then
            OUT_PATH="$3"

            # Target output image name
            if [ ! -z "$4" ]; then
                OUT_FILENAME="$4"
            else
                read -p "Enter Output filename: " OUT_FILENAME
            fi
        else
            read -p "Enter Output filepath: " OUT_PATH
            read -p "Enter Output filename: " OUT_FILENAME
        fi
    else
        read -p "Enter Target image name: " TARGET_IMAGE_NAME
        read -p "Enter Output filepath: " OUT_PATH
        read -p "Enter Output filename: " OUT_FILENAME
    fi
else
    read -p "Enter Target image path: " TARGET_IMAGE_PATH
    read -p "Enter Target image name: " TARGET_IMAGE_NAME
    read -p "Enter Output filepath: " OUT_PATH
    read -p "Enter Output filename: " OUT_FILENAME
fi

# Global Variables
SCALE=""
SCREENLOCKER=i3lock
TARGET_IMAGE="$TARGET_IMAGE_PATH/$TARGET_IMAGE_NAME"

# Functions
## -- General
function display_in_terminal()
{
    echo_msg="$1"
    echo "$echo_msg" > /dev/stderr
}

function get_scale()
{
    # Retrieve Monitor resolution/scale
    # i.e. 1920x1080, 1366x768
    # tmp_SCALE="1920x1080"
    # tmp_SCALE="1366x768"
    MODE="Biggest"
    Resolution=$(xrandr --current | grep '*' | uniq | awk '{print $1}')
    # number_of_displays=$(echo $Resolution | wc -l)
    # smallest_monitor="$(echo $Resolution | tail -n 1)"
    number_of_displays=$(echo "$Resolution" | wc -l)
    biggest_monitor="$(echo "$Resolution" | head -n 1)"
    smallest_monitor="$(echo "$Resolution" | tail -n 1)"

    case "$number_of_displays" in 
        1) 
            Xaxis="$(echo "$Resolution" | cut -d 'x' -f1)"
            Yaxis="$(echo "$Resolution" | cut -d 'x' -f2)"
            ;;
        *) case "$MODE" in
            "Biggest")
                Xaxis="$(echo "$biggest_monitor" | cut -d 'x' -f1)"
                Yaxis="$(echo "$biggest_monitor" | cut -d 'x' -f2)"
                ;;
            "Lowest")
                Xaxis="$(echo "$smallest_monitor" | cut -d 'x' -f1)"
                Yaxis="$(echo "$smallest_monitor" | cut -d 'x' -f2)"
                ;;
            *)  
                Xaxis="$(echo "$Resolution" | cut -d 'x' -f1)"
                Yaxis="$(echo "$Resolution" | cut -d 'x' -f2)"
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

## -- Lockscreen & Getting wallpaper
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
    #
    # -- Check if lockscreen exists
    #

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
# Proces Management            #
# This controls the process    #
################################

function convert_image_to_screen_resolution()
{
    #
    # Generating and converting wallpaper according to the 
    # Display's screen/monitor size 
    #  Multimonitor: Take the smaller size
    #
    SCALE=$(get_scale) # <retrieve from monitor>

    # DEFAULT_OUTPUT_PATH=~/globals/$SCREENLOCKER/wallpaper/png/
    # OUTPUT_FILENAME="$SCALE.png" # i.e. 1920x1080.png, 1366x768.png
    DEFAULT_OUTPUT_PATH=~/
    DEFAULT_OUTPUT_FILENAME="$SCALE.png"

    # Output Path
    if [ ! -z "$1" ]; then
        # INPUT_FILE="/path/to/target/lockscreen/image"
        INPUT_FILE="$1"

       if [ ! -z "$2" ]; then
            # If output path is introduced
            OUTPUT_PATH="$2"

            # Output filename
            if [ ! -z "$3" ]; then
                OUTPUT_FILENAME="$3"
            else
                # OUTPUT_FILENAME=$DEFAULT_OUTPUT_FILENAME
                read -p "Output name: " OUTPUT_FILENAME
            fi
        else
            read -p "Output path: " OUTPUT_PATH
            read -p "Output name: " OUTPUT_FILENAME
        fi
    else
        # OUTPUT_PATH=$DEFAULT_OUTPUT_PATH
        # OUTPUT_FILENAME=$DEFAULT_OUTPUT_FILENAME
        read -p "Input File (/path/to/input/file.extension): " INPUT_FILE
        read -p "Output path: " OUTPUT_PATH
        read -p "Output name: " OUTPUT_FILENAME

        # Defaults if empty
        if [ "$OUTPUT_PATH" == " " ]; then
            OUTPUT_PATH=DEFAULT_OUTPUT_PATH
        fi

        if [ "$OUTPUT_FILENAME" == " " ]; then
            OUTPUT_FILENAME=DEFAULT_OUTPUT_FILENAME
        fi
    fi

    OUTPUT_FILE=$OUTPUT_PATH/$OUTPUT_FILENAME

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

IMAGE_FILE="$(convert_image_to_screen_resolution $TARGET_IMAGE $OUT_PATH $OUT_FILENAME )" | tee -a ~/.logs/convert-fit_screen-resolution.log && echo "Successfully converted $TARGET_IMAGE" | tee -a ~/.logs/convert-fit_screen-resolution.log || echo "Error converting $TARGET_IMAGE" | tee -a ~/.logs/convert-fit_screen-resolution.log
