###############
# Bash Script #
###############

####################
# Global Variables #
####################
ALL_OPTIONS=("--help")

##########################
# Command Line Variables #
##########################

#
# Get command line variables
#
# If option is not empty
if [ ! -z "$1" ]; then
	option="$1"

	# if [ ! -z "$2" ]; then
	#	argv="$2"
	# fi
    if [ "$#" -gt "1" ]; then
        #
        # If there are more than 1 Variables
        # Take all variables as array
        #
        argv=(${@:2})
    fi
fi

#############
# Functions #
#############

# To print out all options
function display_all_options()
{
	for opt in ${ALL_OPTIONS[@]}; do
		echo "	$opt"
	done
}

function display_all_arguments()
{
    for arg in ${argv[@]}; do
        echo "  $arg"
    done
}

function function_name()
{
	# Insert your code here
	echo "Hello World"
}

##############
# Processing #
##############

case "$option" in
	"--help") echo "Help"
	 	display_all_options 
		;;
	*) echo "Default"
		display_all_options
		;;
esac

