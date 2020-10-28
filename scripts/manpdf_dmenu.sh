#############################
# Pipe all manuals into pdf #
# Can select one of those   #
# manuals in a pdf format   #
#############################

###########
# Options #
###########
# OPTION_HELP="Help"
# OPTION_DISPLAY="Display (--display)" # --display
# OPTION_OUTPUT="Output (--out)" # --out
OPTION_HELP="--help"
OPTION_DISPLAY="--display"
OPTION_OUTPUT="--out"
OPTIONS=($OPTION_HELP $OPTION_DISPLAY $OPTION_OUTPUT)

##########################
# Command Line Variables #
##########################
if [ ! -z "$1" ]; then
	# Option provided
	man_opt="$1"
else
	# man_opt=""
    man_opt="$(echo -e "$OPTION_HELP\n$OPTION_DISPLAY\n$OPTION_OUTPUT" | dmenu)"    
fi


#############
# Functions #
#############
function display_options()
{
    for opts in ${OPTIONS[@]}; do
        echo "  $opts"
    done
}

function dinput()
{
    msg="$1"
    dmenu -p "$msg" <&-
}

# man -k <keyword> : To search for a manual
# use '.' as keyword to print all
# How to view as pdf? : 
#  man -Tpdf <keyword> : Output manual as type "pdf" 
# awk: Only print the first one
function manpdf_display()
{
	# Examples:
	# man -Tpdf ls | zathura -
	# man -k . | dmenu -l 30

	# Explanation:
	# Print out all the manuals, 
	# give me a dmenu of all that manuals, 
	# let me select one of them, 
	# take out 1 of them then print the first word of it, 
	# then give that to xargs and create a command "man -Tpdf" and 
	# pipe that into zathura
	man -k . | dmenu -l 30 | awk '{print $1}' | xargs -r man -Tpdf | zathura -
}

function manpdf_output()
{
	# DEFAULT_OUT_DIRECTORY=~/Desktop
	# DEFAULT_OUT_FILE="selected.pdf"
	# if [ -z "$1" ]; then
	# 	# No directory - default
	# 	output_dir="$DEFAULT_OUT_DIRECTORY"
	# 	output_filename="$DEFAULT_OUT_FILE"
	# else
	# 	output_dir="$1"
	# 	if [ -z "$2" ]; then
	# 		# No output file - default
	# 		output_filename="$DEFAULT_OUT_FILE"
	# 	else
	# 		output_filename="$2"
	# 	fi
	# fi
	# output_file="$output_dir/$output_filename"
	DEFAULT_OUT_FILE=~/Desktop/selected.pdf
	if [ -z "$1" ]; then
		# No file directory provided - default
		output_file="$DEFAULT_OUT_FILE"
	else
		output_file="$1"
	fi
	
	# To Output
	# man -k . | dmenu -l 30 | awk '{print $1}' | xargs -r man -Tpdf >> ~/Desktop/test.pdf
	man -k . | dmenu -l 30 | awk '{print $1}' | xargs -r man -Tpdf >> "$output_file"
}

DEFAULT_CMD=manpdf_display

# ---------------------
# Echo the options into dmenu for selection
# ---------------------


if [ ! "$man_opt" == "" ]; then
	# if not empty
	# if [ "$man_opt" == "--display" ]; then
    if [ "$man_opt" == "$OPTION_DISPLAY" ]; then
        # Display using zathura
		manpdf_display
	# elif [ "$man_opt" == "--out" ]; then
    elif [ "$man_opt" == "$OPTION_OUTPUT" ]; then
        if [ ! -z "$2" ]; then
			# If directory provided
			# Output as pdf in directory
			# manpdf_output "$2"
            OUTPATH="$(dinput "Output Directory (Absolute Path): ")"
            man_output $OUTPATH
		else
			# Default path
			manpdf_output
		fi
    elif [ "$man_opt" == "$OPTION_HELP" ]; then
        # Print Help
        echo "Options:"
        # for opts in ${OPTIONS[@]}; do
        #    echo "  $opts"
        #done
        display_options
	else
		# Incorrect option provided, default - display
		echo "Incorrect option provided - defaulting"
		display_options
        # $DEFAULT_CMD
	fi
else
	# No options provided, default - display
	echo "Displaying pdf..."
	$DEFAULT_CMD
fi


# case $Options in 
#     "$
# esac
