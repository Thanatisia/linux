#-----------------------
# Bash Shell Library 
#-----------------------

##################
# DMenu controls #
##################
function dinput()
{
    msg="$1"
    dmenu -p "$msg" <&-
}

#########################
# Terminal I/O Controls #
#########################
function display_in_terminal()
{
	echo_msg="$1"
	echo "$echo_msg" > /dev/stderr
}

#######################
# Distribution and OS #
#######################

# Get current distro
function getdistro()
{
	distroname=""
	# grep will check for keyword - being "arch", "debian" - the distro name
	# any returns means it exists
	isarch="$(ls -l /etc | grep arch)"
	isdebian="$(ls -l /etc | grep debian)"
	if [ "$isarch" ]; then
		distroname="ArchLinux"
	elif [ "$isdebian" ]; then
		distroname="Debian"
	else
		distroname="Unknown"
	fi
	echo $distroname
}

###########
# Display #
###########

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

#################################
# System Information/Monitoring #
#################################

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


#########
# Files #
#########
function file_get_path()
{
	if [ ! -z "$1" ]; then
		fullfile="$1"
		pathdir="$(dirname $fullfile)"
	else
		filename="Empty"
		pathdir="Empty"
	fi
	echo "$pathdir"
}

function file_get_filename()
{
	if [ ! -z "$1" ]; then
		fullfile="$1"
		filename="$(basename $fullfile)"
	else
		fullfile="Empty"
		filename="Empty"
	fi
	echo "$filename"
}

function filename_get_name()
{
	if [ ! -z "$1" ]; then
		fullfile="$1"
		dir_only="$(dirname $fullfile)"
		file_only="$(basename $fullfile)"
		filename="$(echo $file_only | cut -d '.' -f1)"
		# file_ext="${fullfile##*.}"
		file_ext="$(echo $file_only | cut -d '.' -f2)"
	else
		fullfile="Empty"
		filename="Empty"
	fi
	echo "$filename"
}


function filename_get_ext()
{
	if [ ! -z "$1" ]; then
		fullfile="$1"
		dir_only="$(dirname $fullfile)"
		file_only="$(basename $fullfile)"
		filename="$(echo $file_only | cut -d '.' -f1)"
		# # file_ext="${fullfile##*.}"
		file_ext="$(echo $file_only | cut -d '.' -f2)"
	else
		fullfile="Empty"
		filename="Empty"
		file_ext="Empty"
	fi
	echo "$file_ext"
}

######################
# Regular Expression #
######################
function remove_first_line()
{
	# 
	# Use 'sed' to remove first line 
	# From a multiline string
	#
	if [ ! -z "$1" ]; then
		target_String="$1"
	else
		read -p "Target String: " target_String
	fi

	# Remove first line
	res="$($target_String | sed -n '1!p')"
	echo "$res"
}

function remove_lines_from_Head()
{
	# 
	# Use 'sed' to remove first line 
	# From a multiline string
	#
	if [ ! -z "$1" ]; then
		target_String="$1"

		# Get number of lines
		if [ ! -z "$2" ]; then
			n=$2
		else
			n=1
		fi
	else
		read -p "Target String: " target_String
		n=1
	fi

	# Remove first line
	res="$($target_String | sed -n '$n!p')"
	echo "$res"
}

function remove_trailing_slashr()
{
	#
	# Remove trailing '\r' character
	#
	if [ ! -z "$1" ]; then
		filename=$1
	else
		read -p "Filename: " filename
	fi
	sed -i 's/\r$//' $filename
}

function remove_trailing_char()
{
	#
	# Remove trailing character
	#
	if [ ! -z "$1" ]; then
		filename=$1

		if [ ! -z "$2" ]; then
			pattern="$2"
		else
			read -p "Target trailing character: " pattern
		fi
	else
		read -p "Filename: " filename
		read -p "Target trailing character: " pattern
	fi
	sed -i 's/$pattern$//' $filename
}

######################
# Package Management #
######################
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

function package_install()
{
	options=("(A)dd Package" "(R)emove Package" "(S)earch Package" "(L)ist All Packages" "(Q)uit")
	packages=()

	# List all options
	echo "Options: "
	for option in "${options[@]}"; do
		echo "	$option"
	done

	# Get user input
	read -p "Option: " opt
	while [ ! "$opt" == "Quit" ] && [ ! "$opt" == "Q" ]; do
		case "$opt" in 
			"A" | "Add Package")
				read -p "Target package(s): " pkg
				packages+=("$pkg")
				echo "Current packages: ${packages[@]}"
				;;
			"R" | "Remove Package")
				read -p "Target package: " pkg
				packages=("${packages[@]/$pkg}")
				echo "Current packages: ${packages[@]}"
				;;
			"S" | "Search Package")
				# Check if a package is added
				read -p "Target package: " pkg
				res="$(echo "${packages[@]}" | grep "$pkg")"
				if [ ! -z "$res" ]; then
					# Package is added
					echo "Package is added."
				else
					# Package is not added
					echo "Package is not added."
				fi
				;;
			"L" | "List All Packages")
				echo "All packages: "
				for pkg in ${packages[@]}; do
					echo "	$pkg"
				done
				;;
			"Q" | "Quit") echo "Quit"
				;;
			*) echo "Invalid option"
				;;
		esac

		# List all options
		echo ""
		echo "Options: "
		for option in "${options[@]}"; do
			echo "	$option"
		done

		# Get option
		read -p "Option: " opt
	done
	pkgstring=""
	for pkg in ${packages[@]}; do
		pkgstring+="$pkg "
	done

	# For now - install
	sudo pacman -S $pkgstring | tee -a ~/.logs/package_install.log
}

################
# Partitioning #
################
function get_number_of_partitions()
{
	# 
	# sudo fdisk -l : List all drives
	# grep the device of choice
	# remove the first line
	# Count number of lines
	#
	if [ ! -z "$1" ]; then
		# Get device of choice
		target_Device=$1
	else
		read -p "Target Device: " target_Device
	fi

	# number_of_partitions="$(sudo fdisk -l | grep /dev/sdb | sed -n '1!p' | wc -l)"
	number_of_partitions="$(lsblk | grep $target_Device | sed -n '1!p' | wc -l)"
	echo "$number_of_partitions"
}

#############
# Variables #
#############
function join_array()
{
	options_array=($1)
	options=""
	# for opt in "${options_array[@]}"; do
	for opt in "${options_array[@]}"; do
		options+="$opt\n"
	done
	echo "$options"
}