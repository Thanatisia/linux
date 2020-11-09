###############
# Bash Script #
###############

####################
# Global Variables #
####################
ALL_OPTIONS=("--help" "--run" "--compile")

##########################
# Command Line Variables #
##########################

#
# Get command line variables
#
# If option is not empty
if [ ! -z "$1" ]; then
	option="$1"

	if [ "$#" -gt "1" ]; then
        # Take only the second command onwards; Put () to turn it into an array
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
    # echo "Compiling via mcs..."
    # # Package for mono and mcs to compile C#
    # pkg_name="extra/mono"
    # installed="$(check_if_package_is_installed "pacman" "$pkg_name")"
    # line_ret="$(echo $installed | wc -l)"
    # if [ !  $installed == "" ] && [ $line_ret -ge 0 ]; then
    #     echo "$pkg_name is installed."
    #     echo "Package: $installed"
    #     echo "Number of lines: $line_ret"
    # else
    #     echo "$pkg_name is not installed."
    # fi


    compiler_cmd="g++ $gpp_params"
}

##############
# Processing #
##############

case "$option" in
	"--help") echo "Help"
	 	display_all_options
        ;; 
    "--run") echo "Running"
        exe_file="${argv[0]}" # 1st index
        if [ -z "$exe_file" ]; then
            read -p "Executable file: " exe_file
        fi
        ./$exe_file
        ;;
    "--compile") echo "Compiling..."
        OTHER_PARAMS=""

        # Default program parameters
        src_name="main"
        src_ext="cpp"
        dst_name="main"
        dst_ext="exe"
        prog_params=(${argv[@]}) # Put () to retrieve as an array - default is string

        # Retrieve parameters and variables
        tmp_src="${prog_params[0]}"
        tmp_dst="${prog_params[1]}"
        tmp_opt="${prog_params[2]}"

        # Validation
        if [ -z "$tmp_src" ]; then
            # temporary source is not empty
            read -p "Input source file: " tmp_src
        fi
        param_1_condition_1="$(echo $tmp_src | cut -d '.' -f1)"
        param_1_condition_2="$(echo $tmp_src | cut -d '.' -f2)"

        if [ -z "$tmp_dst" ]; then
            # temporary destination is not empty
            read -p "Destination file: " tmp_dst
        fi
        param_2_condition_1="$(echo $tmp_dst | cut -d '.' -f1)"
        param_2_condition_2="$(echo $tmp_dst | cut -d '.' -f2)"

        if [ -z "$tmp_opt" ]; then
            # Additional options
            read -p "Additional Options: " OTHER_PARAMS
        else
            OTHER_PARAMS="$tmp_opt"
        fi

        # Prepare parameters
        if [ "$param_1_condition_1" == "$param_1_condition_2" ]; then
            # Check if both the filename and extensions are the same
            src_name="$tmp_src"
        else
            src_name="$param_1_condition_1"
            src_ext="$param_1_condition_2"
        fi

        if [ "$param_2_condition_1" == "$param_2_condition_2" ]; then
            dst_name="$tmp_dst"
        else
            dst_name="$param_2_condition_1"
            dst_ext="$param_2_condition_2"
        fi
        src_file="$src_name.$src_ext"
        dst_file="$dst_name.$dst_ext"
        gpp_params="$src_file -o $dst_file "

        if [ ! -z "$OTHER_PARAMS" ]; then
            gpp_params+="$OTHER_PARAMS"
        fi
        compiler_cmd="g++ $gpp_params"

        # Run script
        if [ "$src_ext" == "cpp" ]; then
            echo "Executing command: $compiler_cmd"
            echo "Compiling $src_file to $dst_file..."
            sleep 3
            $compiler_cmd
        else
            echo "File is not (.$src_ext) format"
        fi

        # Script end
        ;;
	*) echo "Default"
		display_all_options
		;;
esac

