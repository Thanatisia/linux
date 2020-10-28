############################
# Blur screenshot using    #
# Convert by ImageMagick   #
############################

DEFAULT_OUT_PATH=~/screenshotblur.png
DEFAULT_BLUR_FILTER=0x20

if [ ! -z "$1" ]; then
	blur_filter="$1"

	if [ ! -z "$2" ]; then
		output_file="$2"
	else
		output_file=$DEFAULT_OUT_PATH
	fi
else
	blur_filter=$DEFAULT_BLUR_FILTER
	output_file=$DEFAULT_OUT_PATH
fi

# Take screenshot of background using scrot
original_file=~/screenshot.png
scrot $original_file

# To blur using Convert
# 0x8 defines radiusxsigma from the imagemagick documentation
# Set blur factor
# Example:
# 	blur_filter=0x20
# 	convert "$original_file" -blur $blur_filter /tmp/screenshotblur.png
convert "$original_file" -blur $blur_filter $output_file | tee -a ~/.logs/blur_images.log && echo "Successfully converted $original_file to $output_file" || echo "Error converting $original_file to $output_file"
