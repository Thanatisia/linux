##########################
# Blur an image using    #
# Convert by ImageMagick #
##########################

############
# Examples #
############
## Remove existing screenshot
#rm /tmp/screenshot.png

## Take a new screenshot
#scrot /tmp/screenshot.png

## To blur using Convert
## 0x8 defines radiusxsigma from the imagemagick documentation
## Set blur factor
#blur_filter=0x20
#convert "$original_file" -blur $blur_filter /tmp/screenshotblur.png

## Combine blur filter with a transparent banner (put transparent banner on top)
#convert /tmp/screenshotblur.png ~/globals/i3lock/wallpaper/png/1920x1080.png -gravity center -composite -matte /tmp/screenlock.png

## Lock with i3lock
#i3lock -i /tmp/screenlock.png

# blurred_image=/tmp/screenshotblur.png

#############
# Functions #
#############
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

#############
# Variables #
#############

# Add script to path
scriptpath=~/Desktop/portable/scripts/bash
PATH=$scriptpath:$PATH:

original_screenshot=~/screenshot.png
blur_filter="0x20"
blurred_image=~/screenshotblur.png

# Get next image (upper layer)
monitor_scale=$(get_scale)
next_image=~/globals/i3lock/wallpaper/png/$monitor_scale.png

# Check if next image file (transparent) (a logo - in this case, the nier automata transparent "system locked" image) exist
if [ ! -f $next_image ]; then
	# Not Found - convert
	next_image_target_Path=~/Desktop/portable/media/images/TARGET/
	next_image_target_Name=nier-automata-system-locked.png
	next_image_output_Path=~/globals/i3lock/wallpaper/png
	next_image_output_Name="$(get_scale).png"
	echo "Image [$next_image] not found - converting image: [$next_image_target_Path/$next_image_target_Name] to scale [$monitor_scale]"
	convert-fit_screen-resolution.sh $next_image_target_Path $next_image_target_Name $next_image_output_Path $next_image_output_Name | tee -a ~/.logs/lock-blur.log && echo "Converted successfully to scale $monitor_scale" | tee -a ~/.logs/lock-blur.log || echo "Error converting to scale $monitor_scale..." | tee -a ~/.logs/lock-blur.log
fi

LOCK_IMAGE=/tmp/lock.png
ImageMagick_options="-composite -matte"

# Check if files exists
# Move to archive screenshot dotfolder if exists
if [ -f $original_screenshot ]; then
	# Remove old screenshot
	# rm $original_screenshot
	if [ ! -d ~/.archive/screenshot ]; then
		# if screenshot folder does not exist
		# make directory
		mkdir -p ~/.archive/screenshot
	fi
	mv $original_screenshot ~/.archive/screenshot/screenshot_$(get_datetime).png
fi

if [ -f $blurred_image ]; then
	# Remove old blurred image
	# mv $blurred_image ~/screenshotblur.png
	# rm $blurred_image
	if [ ! -d ~/.archive/screenshot ]; then
		# if screenshot folder does not exist
		# make directory
		mkdir -p ~/.archive/screenshot
	fi
	mv $blurred_image ~/.archive/screenshot/screenshotblur_$(get_datetime).png
fi

if [ -f $LOCK_IMAGE ]; then
	# Remove old lock image
	# mv $LOCK_IMAGE ~/lock.png
	rm $LOCK_IMAGE
fi

# Display warning dialog popup message
echo "Blurring and converting..."

# Get Background and blur
blur_background.sh $blur_filter $blurred_image

# Combine Background and the Nier Automata image
combine_images.sh $blurred_image $next_image $LOCK_IMAGE $ImageMagick_options

# Set i3lock wallpaper and lock
# Log success and errors
# LOCKER_OPTIONS="-i $IMAGE_FILE --tiling --show-failed-attempts -c 000000"
now="$(get_datetime)"
echo "Locked at $now" | tee -a ~/.logs/i3lock-logs.log
i3lock -i $LOCK_IMAGE --tiling --show-failed-attempts  | tee -a ~/.logs/i3lock-logs.log && now="$(get_datetime)"; echo "Unlocked at $now" | tee -a ~/.logs/i3lock-logs.log || now="$(get_datetime)"; echo "Error with locking at $now"

# Write seperator
echo " --- " | tee -a ~/.logs/i3lock-logs.log