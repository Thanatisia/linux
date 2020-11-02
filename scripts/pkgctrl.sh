#
# Package Control Management
#

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

package_install