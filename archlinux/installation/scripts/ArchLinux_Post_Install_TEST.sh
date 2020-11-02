#
# ArchLinux Post Install Script
# TODO WIP - DO NOT USE FOR NOW
#
# Last modified: 
#	2020-11-02 2224H
# Changes:
#  	2020-11-02 2224H, Created this script
#

function installer()
{
	#
	# Menu template as reference
	#

	install_ToDo=("User Control" "Home Directory" "Networking" "Package Management" "AUR" "Other Package Installations" "Frontend setup" "Display Manager")
	menu_options=("(S)tart" "(R)emove" "(H)elp" "(Q)uit")
	menu_Help=("(S)tart : Start the Post-Installation ToDo install process" "(R)emove : Remove a category from the Default Post-Installation ToDo install list" "(H)elp : This help menu" "(Q)uit : Quit the program")

	# List all ToDo
	echo "This is the Table of Contents"
	for todo in "${install_ToDo[@]}"; do
		echo "$todo"
	done

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
			"S" | "Start") 
				echo "Start"
				for todo in "${install_ToDo[@]}"; do
					case "$todo" in 
						"U") echo "User Control"
							# To refer to "ArchLinux Post Installation under [User Control]"
							;;
						"H") echo "Home Directory"
							# To refer to "ArchLinux Post Installation under [Home Directory]"
							;;
						"N") echo "Networking"
							# To refer to "ArchLinux Post Installation under [Networking]"
							;;
						"P") echo "Package Management"
							# To refer to "ArchLinux Post Installation under [Package Management]"
							;;
						"A") echo "AUR"
							# To refer to "ArchLinux Post Installation under [AUR]"
							;;
						"O") echo "Other Package Installations"
							# To refer to "ArchLinux Post Installation under [Additional Package Installations]"
							;;
						"F") # WM/DE 
							# To refer to "ArchLinux Post Installation under [WM/DE setup]"
							echo "Frontend setup"
							;; 
						"D") echo "Display Manager"
							# To refer to "ArchLinux Post Installation under [Display Manager]"
							;;
						*) echo "Probably a W.I.P feature? Moving to next todo"
					esac
				done
				;;
			"R" | "Remove")
				echo "Removing option..."
				read -p "Which menu option would you like to remove?: " remove_opt
				case "$remove_opt" in
					"U") remove_opt="User Control";;
					"H") remove_opt="Home Directory";;
					"N") remove_opt="Networking";;
					"P") remove_opt="Package Management";;
					"A") remove_opt="AUR";;
					"O") remove_opt="Other Package Installations";;
					"F") remove_opt="Frontend setup";; # WM/DE
					"D") remove_opt="Display Manager";;
					*) echo "Invalid option";;
				esac
				install_ToDo=("${install_ToDo[@]/$remove_opt}")
				;;
			"H" | "Help") echo "Help"
				for man in "${menu_Help[@]}"; do
					echo "	$man"
				done
				;;
			"Q" | "Quit") echo "Quit"
				;;
			*) echo "Invalid option"
				;;
		esac

		# List all ToDo
		echo ""
		echo "This is the Table of Contents"
		for todo in "${install_ToDo[@]}"; do
			echo "$todo"
		done

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