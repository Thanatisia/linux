# using Bash to make a GUI/Terminal menu
# A full select interface in Bash like the
# NetworkingUtil project

# -- Command Macros
newline=$(echo "")

function display_in_terminal()
{
	echo_msg="$1"
	echo "$echo_msg" > /dev/stderr
}
function nline()
{
	# Write a newline
	echo $newline > /dev/stderr # Goes to the screen
}

# -- External Functions
function append_array()
{
	################################
	# Temporarily does not work    #
	# - Issue: Array not appending #
	################################
	# Get array
	arr=($1)
	your_string="$2"

	# DEBUG
	display_in_terminal "Array : $arr"
	display_in_terminal "String: $your_string"
	nline


	# Append value to array
	arr+=("$your_string")

	echo "${arr[@]}"
}

echo "Menu starting..."

nline

#################
# Program       #
# Menu - Design #
#################

PS3="Please select a program: "
options=()
help_options=()

# Design options
quit="Quit"
opt_1="convert_scale.sh"
opt_2="filemanager"
opt_3="generate_xResources_file"
opt_4="pacman_install_program_and_log"
opt_5="make_program_locally_and_log"
opt_6="make_program_and_install_globally_and_log"
opt_7="makepkg_and_log"
opt_8="Write_To_Changelog"
opt_9="display_or_output_man_to_pdf"
opt_10="Image_Gallery_Menu_powered_by_sxiv_and_dmenu"
opt_11="Update_via_pacman_-Syyu_and_log"
opt_12="Update_terminal_color_automatically_via_pywal"
opt_13="AUR_install_packages_and_log"
help="Help"

# Design Option help summary
quit_help="Quit the program"
opt_1_help="To convert resolution and scaling of image using ImageMagick"
opt_2_help="A shell-based file manager script"
opt_3_help="Automatically Generate ~/.xResources file"
opt_4_help="Install a package from pacman via pacman -S and log inside ~/.log"
opt_5_help="run 'make' and make the package locally and log it inside ~/.log"
opt_6_help="run 'sudo make install' and make the package globally and log it inside ~/.log"
opt_7_help="run 'makepkg' and log it"
opt_8_help="Update and write to the master changelog"
opt_9_help="Select man of a selected topic and system will display the man as pdf or output it to pdf file"
opt_10_help="A image gallery based off sxiv which works as a dmenu for media - idea inspired by Luke Smith"
opt_11_help="Update and Upgrade pacman (via pacman -Syyu) and Log in ~/.logs"
opt_12_help="Update terminal colorschemes automatically through pywal and log it in ~/.logs"
opt_13_help="Install package from AUR and log in ~/.logs"
help_help="The thing you are reading"

# Add help summary to the array
help_options+=("$quit_help")
help_options+=("$opt_1_help")
help_options+=("$opt_2_help")
help_options+=("$opt_3_help")
help_options+=("$opt_4_help")
help_options+=("$opt_5_help")
help_options+=("$opt_6_help")
help_options+=("$opt_7_help")
help_options+=("$opt_8_help")
help_options+=("$opt_9_help")
help_options+=("$opt_10_help")
help_options+=("$opt_11_help")
help_options+=("$opt_12_help")
help_options+=("$opt_13_help")
help_options+=("$help_help")

# "Add new element to the end of the array"
options+=("$quit")
options+=("$opt_1")
options+=("$opt_2")
options+=("$opt_3")
options+=("$opt_4")
options+=("$opt_5")
options+=("$opt_6")
options+=("$opt_7")
options+=("$opt_8")
options+=("$opt_9")
options+=("$opt_10")
options+=("$opt_11")
options+=("$opt_12")
options+=("$opt_13")
options+=("$help")

# Main menu
select opt in "${options[@]}"; do
	case $opt in
		"$quit")
			# Quit selection menu
			break
			;;
		"$help")
			# Display Help summary for each option
			echo "Options: "
			line=-1 # Start from -1 so it includes 0
			for opt in ${options[@]}; do
				line=$((line + 1))
				# Need to +1 for Options because this is an option for human reading
				# Selection is zero-based
				echo "	$((line + 1)): $opt"
				echo "		${help_options[$line]}"
			done
			;;
		$opt_1) 
			sh convert_scale.sh
			;;
		$opt_2) 
			sh filemanager.sh
			;;
		$opt_3) 
			sh generate_xresources.sh
			;;
		$opt_4) 
			sh install-logged.sh
			;;
		$opt_5)
			sh make-local-logged.sh
			;;
		$opt_6)
			sh make-logged.sh
			;;
		$opt_7)
			sh makepkg-logged.sh
			;;
		$opt_8)
			sh manage-changelog.sh
			;;
		$opt_9)
			read -p "[O]utput | [P]rint: " out_print_choice
			if [ "$out_print_choice" == "O" ]; then
				tmp_opt="--out"

				read -p "Directory: " path_dir
			elif [ "$out_print_choice" == "P" ]; then
				tmp_opt="--display"

				path_dir=""
			fi
			sh manpdf.sh "$tmp_opt" "$path_dir"
			echo "Completed."
			;;
		$opt_10)
			sh sxiv-dmenu.sh
			;;
		$opt_11)
			sh update-logged.sh
			;;
		$opt_12)
			sh update-terminal-color.sh
			;;
		$opt_13)
			sh yay-install-logged.sh
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