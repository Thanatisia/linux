# using Bash to make a GUI/Terminal menu
# A full select interface in Bash like the
# NetworkingUtil project

# -- Command Macros
newline=$(echo "")

# -- External Functions
function append_array()
{
	# Get array
	arr=$1
	your_string="$2"

	# Append array to last element
	arr[${#arr[@]}]+="$your_string"
	echo "${arr[*]}"
}

function nline()
{
	# Write a newline
	echo $newline > /dev/stderr # Goes to the screen
}

echo "Menu starting..."

nline

#################
# Program       #
# Menu - Design #
#################

PS3="Please select a program: "
options=("Quit")

# "Add new element to the end of the array"
opt_1=""
options=($(append_array $options "$opt_1"))

# Main menu
select opt in "${options[@]}"; do
	case $opt in
		$opt_1) 
			# sh Function-here
			;;
		"Quit")
			break
			;;
		*) echo "Invalid Option $REPLY"
			;;
	esac
done

##################
# Program        #
# Menu - Closing #
##################

nline

echo "Menu closed."