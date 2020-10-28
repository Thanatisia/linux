#############################
# Combine 2 images using    #
# Convert by ImageMagick    #
#############################

DEFAULT_OUT_PATH=~/combined.png

if [ ! -z "$1" ]; then
	# Have original file
	original_file="$1"

	if [ ! -z "$2" ]; then
		next_image="$2"

		if [ ! -z "$3" ]; then
			output_file="$3"

			if [ ! -z "$4" ]; then
				# Properties
				properties="$4"
			else
				read -p "Properties: " properties
			fi
		else
			output_file=$DEFAULT_OUT_PATH
			read -p "Properties: " properties
		fi
	else
		read -p "Next Image File Path & Name: " next_image
		output_file=$DEFAULT_OUT_PATH
		read -p "Properties: " properties
	fi
else
	read -p "Original File Path & Name: " original_file
	read -p "Next Image File Path & Name: " next_image
	output_file=$DEFAULT_OUT_PATH
	read -p "Properties: " properties
fi

# To Combine blur filter with a transparent banner (put transparent banner on top)
# Examples:
#	convert $original_file $next_image -gravity center -composite -matte /tmp/screenlock.png
convert $original_file $next_image $properties $output_file | tee -a ~/.logs/combine_images.log && echo "Successfully combined $original_file with $next_image and output to $output_file" || echo "Error combining $original_file with $next_image"
