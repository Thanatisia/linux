###############
# Bash Script #
###############

####################
# Global Variables #
####################
ALL_OPTIONS=("--help" "--compile")

##########################
# Command Line Variables #
##########################

#
# Get command line variables
#
# If option is not empty
if [ ! -z "$1" ]; then
	option="$1"

	if [ ! -z "$2" ]; then
		argv="$2"
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

function function_name()
{
	# Insert your code here
	echo "Hello World"
}

function check_if_package_is_installed()
{
    package_manager_list=("pacman" "yay" "apt")
    if [ ! -z "$1" ]; then
        package_manager="$1"

        if [ ! -z "$2" ]; then
            pkg_name="$2"

            case "$package_manager" in 
                "pacman") installed="$(pacman -Qq | grep "$pkg_name")"
                    ;;
                *) echo "Invalid package manager"
                    ;;
            esac
        else
            installed="None"
        fi
    else
        installed="None"
    fi
    echo "$installed"
}

function compile()
{
    echo "Compiling via mcs..."
    pkg_name="extra/mono"
    installed="$(check_if_package_is_installed "pacman" "$pkg_name")"
    line_ret="$(echo $installed | wc -l)"
    if [ !  $installed == "" ] && [ $line_ret -ge 0 ]; then
        echo "$pkg_name is installed."
        echo "Package: $installed"
        echo "Number of lines: $line_ret"
    else
        echo "$pkg_name is not installed."
    fi
}

##############
# Processing #
##############

case "$option" in
	"--help") echo "Help"
	 	display_all_options
        ;; 
    "--compile") echo "Compiling..."
        compile
        ;;
	*) echo "Default"
		display_all_options
		;;
esac

