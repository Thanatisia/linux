if [ -z "$1" ]; then
	read -p "Enter your scale (width*height - i.e. 1920x1080): " SCALE
	read -p "Input file name (add extension): " INPUT
	read -p "Output file name (add extension): " OUTPUT
else
	SCALE="$1"

	if [ -z "$2" ]; then
		read -p "Input file name (add extension): " INPUT
	else
		INPUT="$2"
		if [ -z "$3" ]; then
			read -p "Output file name (add extension): " OUTPUT
		else
			OUTPUT="$3"
		fi
	fi
fi

pkgexists="$(pacman -Qq | grep imagemagick)"
if [ "$pkgexists"=="" ]; then
	echo "imagemagick is installed."
	echo "Command: convert -scale $SCALE $INPUT $OUTPUT"
	convert -scale $SCALE $INPUT $OUTPUT
else
	echo "imagemagick is not installed."
fi

echo "$OUTPUT"