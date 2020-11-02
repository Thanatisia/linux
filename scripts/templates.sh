###########
# General #
###########
function menu()
{
	#
	# Menu template as reference
	#

	# This is by choice
	# However, I like to follow this option syntax
	# ("(<Alphabet of text><other characters in text>)")
	# example:
	#	("(H)elp" "(Q)uit")
	menu_options=("(O)ption" "(Q)uit")
	# List all options
	echo "Options: "
	for option in "${menu_options[@]}"; do
		echo "	$option"
	done

	# Get user input
	read -p "Option: " opt
	while [ ! "$opt" == "Quit" ] && [ ! "$opt" == "Q" ]; do
		case "$opt" in 
			# "<First character of string>" | "<string>")
			# i..e
			# "H" | "Help")
			# "Q" | "Quit")
			"H" | "Help") echo "Help"
				;;
			"Q" | "Quit") echo "Quit"
				;;
			*) echo "Invalid option"
				;;
		esac

		# List all options
		echo ""
		echo "Options: "
		for option in "${menu_options[@]}"; do
			echo "	$option"
		done

		# Get option
		read -p "Option: " opt
	done
}