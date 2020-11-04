#
# Package Control Management
#

pkgmgr="pacman"
packages=()

function package_install()
{
	options=("(A)dd Package" "(R)emove Package" "(S)earch Package" "(L)ist All Packages" "(Q)uit")
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
	if [ ! -z "$pkgstring" ]; then
		sudo pacman -S $pkgstring | tee -a ~/.logs/package_install.log
	else
		echo "No packages to install."
	fi
}

function package_update()
{
    update-logged.sh
}

function package_menu()
{
    pkgmenu_options=("(I)nstall" "(U)pdate" "(H)elp" "(Q)uit")
    pkgmenu_Help=("(I)nstall : Use this to install via your package manager - currently $pkgmgr" "(U)pdate : Do a update using the relevant package managers (i.e. pacman [pacman -Syu], apt(-get) [sudo apt update && sudo apt upgrade]" "(H)elp : This message" "(Q)uit : To quit this program")
	# List all options
	echo "Options: "
	for option in "${pkgmenu_options[@]}"; do
		echo "	$option"
	done

	# Get user input
	read -p "Option: " opt
	while [ ! "$opt" == "Quit" ] && [ ! "$opt" == "Q" ]; do
		case "$opt" in 
			"I" | "Install") 
				echo "Install Packages"
				echo ""
				package_install
				opt=""
				;;
            "U" | "Update")
                echo "Updating packages..."
                echo ""
                package_update
                ;;
			"H" | "Help") 
				echo "Help"
				for man in "${pkgmenu_Help[@]}"; do
					echo "	$man"
				done
				;;
			"Q" | "Quit") 
				echo "Quit"
				;;
			*) echo "Invalid option"
				;;
		esac

		# List all options
		echo ""
		echo "Options: "
		for option in "${pkgmenu_options[@]}"; do
			echo "	$option"
		done

		# Get option
		read -p "Option: " opt
	done
	pkgstring=""
	for pkg in ${packages[@]}; do
		pkgstring+="$pkg "
	done
}

package_menu
