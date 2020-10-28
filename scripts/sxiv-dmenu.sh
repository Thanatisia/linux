##################################
# Use SXIV as Dmenu for pictures #
##################################

#####################
# Default Variables #
#####################
DEFAULT_FLDR_PATH=~/Desktop/portable/media/images/jpeg/
DEFAULT_FILE_EXT="*"

# Global variables
# common folder path
home_directory=~/Desktop

##########################
# Command Line Variables #
##########################
if [ -z "$1" ]; then
	# Folder path is Empty - set to default
	fldr_path=$home_directory/portable/media/images/jpeg/
	echo "Folder path not provided - setting to default path: $fldr_path"
	
	# File Extension	
	file_ext="$DEFAULT_FILE_EXT"
	echo "Target file extension not provided - setting to default extension: $file_ext"
else
	fldr_path="$1"

	# Get file extension
	if [ -z "$2" ]; then
		# File extension is empty - set to default
		file_ext="$DEFAULT_FILE_EXT"
		echo "Target file extension not provided - setting to default extension: $file_ext"
	else
		file_ext="$2"
	fi
fi

###############
# Binary prog #
# Properties  #
###############
# Path of sxiv
bin_path=$home_directory/portable/repos/sxiv/
bin_name=sxiv
# sxiv open thumbnail mode, activate and run read input file and write output
bin_opts=-tio
bin_prog="$bin_path/$bin_name $bin_opts"

################
# Input/Output #
#  Properties  #
################
# Path of image folders
input_file="$fldr_path/*.$file_ext"


# Output file
out_path=$home_directory
out_filename=test.log
out_file="$out_path/$out_filename"

# Functions
function log_selected_images()
{
	# For now - get file name of selected pictures
	# ls $input_file | $bin_prog | tee -a $out_file
	filenames="$(ls $input_file | $bin_prog)"
	filecount="$(echo "$filenames" | wc -l)" 
	echo "Number of files: $filecount" | tee -a $out_file
	echo "$filenames" | tee -a $out_file
}

function prepare_to_select()
{
	echo "Please press"
	echo "	m : To select your images"
	echo "	q : To quit after selecting your files."
}

function select_images()
{
	# For now - get file name of selected pictures
	# ls $input_file | $bin_prog | tee -a $out_file
	# Return selected image filenames
	
	# filecount="$(echo "$filenames" | wc -l)" 
	# echo "Number of files: $filecount" | tee -a $out_file
	# echo "$filenames" | tee -a $out_file

	# Get files
	# Get selected file names and number of selected files
	selected_file_names="$(ls $input_file | $bin_prog)"
	# Count number of files
	# number_of_selected_files="$(echo "$selected_file_names" | wc -l)"
	echo "$selected_file_names"
}

function get_extension()
{
	ret="No Files"
	if [ ! -z "$1" ]; then
		# Not empty
		filename=$(basename -- "$1")
		extension="${filename##*.}"
		ret="$extension"
	fi
	echo "$ret"
}

function get_filename_only()
{
	ret="No Files"
	if [ ! -z "$1" ]; then
		# Not empty
		filename=$(basename -- "$1")
		fname_only="${filename%%.*}"
		ret="$fname_only"
	fi
	echo "$ret"
}

function get_path_only()
{
	ret="No Files"
	if [ ! -z "$1" ]; then
		# Not empty
		dirname=$(dirname -- "$1")
		ret="$dirname"
	fi
	echo "$ret"
}

function copy_selected_files()
{
	if [ -z "$1" ]; then
		# if no files are selected
		echo "No files entered."
		number_of_selected_files_local="0"
	else
		# if selected files is entered
		selected_files="$1"
		number_of_selected_files_local="$(echo "$selected_files" | wc -l)"
		if [ -z "$2" ]; then
			# if destination directory is empty
			read -p "Destination Directory: " dest
		else
			# if destination directory is entered
			dest="$2"
		fi
		
		# Files are entered
		echo "==============="
		echo "Number of Selected Files: $number_of_selected_files_local"
		echo "Files selected:"
		echo "$selected_files"
		echo "==============="

		read -p "Start copy? [Y|N]: " confirm_start_copy
		if [ "$confirm_start_copy" == "Y" ]; then
			# Copy selected files to directory
			# cp $selected_files
			
			# For loop iterate over all the files and transfer
			for files in $selected_files; do
				# Get only the file name from the full file
				filename_only="$(basename "$files")"
				# Get only the file path from the full file
				filepath_only="$(dirname "$files")"
				# echo "Current File: $files"
				# echo "Copying $filename_only from $filepath_only to $dest..."
				# echo "$files $dest/$filename_only"
				echo "Current File: $files"
				echo "filename only: \"$filename_only\""
				echo "filepath only: \"$filepath_only\""
				echo "Target: $files $dest/$filename_only"
				cp "$files" "$dest/$filename_only"
			done
		else
			# No
			echo "End copy"
		fi
	fi
}

function set_as_wallpaper()
{
	# Set selected wallpaper as wallpaper using
	# feh (for now)
	if [ -z "$1" ]; then
		# if no files are selected
		echo "No files entered."
		number_of_selected_files_local="0"
	else
		# if selected files is entered
		selected_files="$1"
		number_of_selected_files_local="$(echo "$selected_files" | wc -l)"
		
		# Files are entered
		echo "==============="
		echo "Number of Selected Files: $number_of_selected_files_local"
		echo "Files selected:"
		echo "$selected_files"
		echo "==============="

		read -p "Start set? [Y|N]: " confirm_start_set
		if [ "$confirm_start_set" == "Y" ]; then
			# Check number of files
			# if number of files has more than 1, take only the first one
			# Get only the file name from the full file
			if [ $number_of_selected_files_local -gt 1 ]; then
				# if number of files greater than 1
				selected_files="$(head -n 1 $selected_files)"
			fi

			filename_only="$(basename "$selected_files")"
			# Get only the file path from the full file
			filepath_only="$(dirname "$selected_files")"	
				
			# Set wallpaper
			# feh --bg-center "$files"
			# feh --bg-center $selected_files
			# feh --bg-fill $selected_files
			feh --bg-max $selected_files
			# if automatic change colour via pywal
			# wal -i $selected_files
		else
			# No
			echo "End set"
		fi
	fi
}

function wal_change_color()
{
	# Manually Use pywal change colour to set the 
	if [ -z "$1" ]; then
		# if no files are selected
		echo "No files entered."
		number_of_selected_files_local="0"
	else
		# if selected files is entered
		selected_files="$1"
		number_of_selected_files_local="$(echo "$selected_files" | wc -l)"
		
		# Files are entered
		echo "==============="
		echo "Number of Selected Files: $number_of_selected_files_local"
		echo "Files selected:"
		echo "$selected_files"
		echo "==============="

		read -p "Start set? [Y|N]: " confirm_start_set
		if [ "$confirm_start_set" == "Y" ]; then
			# Check number of files
			# if number of files has more than 1, take only the first one
			# Get only the file name from the full file
			if [ $number_of_selected_files_local -gt 1 ]; then
				# if number of files greater than 1
				selected_files="$(head -n 1 $selected_files)"
			fi

			filename_only="$(basename "$selected_files")"
			# Get only the file path from the full file
			filepath_only="$(dirname "$selected_files")"	
				
			# Set wallpaper
			# feh --bg-center "$files"
			# feh --bg-center $selected_files
			# if automatic change colour via pywal
			wal -i $selected_files
		else
			# No
			echo "End set"
		fi
	fi
}

# Template for menu
# options=("Option 1" "Option 2" "Option 3" "Quit")
# select opt in "${options[@]}"
# do
#     case $opt in
#         "Option 1")
#             echo "you chose choice 1"
#             ;;
#         "Option 2")
#             echo "you chose choice 2"
#             ;;
#         "Option 3")
#             echo "you chose choice $REPLY which is $opt"
#             ;;
#         "Quit")
#             break
#             ;;
#         *) echo "invalid option $REPLY";;
#     esac
# done

prepare_to_select
selected_files="$(select_images)"
number_of_selected_files="$(echo "$selected_files" | wc -l)"
echo "==============="
echo "Number of Selected Files: $number_of_selected_files"
echo "Files selected:"
echo "$selected_files"
echo "==============="
PS3="Enter an option: "
options=("Copy images" "Set as wallpaper" "Rechoose images" "Print current images" "Change Terminal Colorscheme through pywal" "Get Path Only" "Get Filename Only" "Get Extension" "Quit")
# select : A looping menu syntax
##########################################
# references                             #
# https://linuxize.com/post/bash-select/ #
##########################################
select opt in "${options[@]}"; do
    case $opt in
        "Copy images")
            echo "you chose choice 1"
            copy_selected_files "$selected_file_names" ~/Desktop/TestDir
            echo ""
            ;;
        "Set as wallpaper")
            echo "you chose choice 2"
            set_as_wallpaper "$selected_files" && echo "Wallpaper has been successfully set" || echo "Wallpaper has failed to set."
            echo ""
            ;;
        "Rechoose images")
			prepare_to_select
			selected_files="$(select_images)"
			number_of_selected_files="$(echo "$selected_files" | wc -l)"
			echo "==============="
			echo "Number of Selected Files: $number_of_selected_files"
			echo "Files selected:"
			echo "$selected_files"
			echo "==============="
			echo ""
			;;
		"Print current images")
			echo "==============="
			echo "Number of Selected Files: $number_of_selected_files"
			echo "Files selected:"
			echo "$selected_files"
			echo "==============="
			;;
		"Change Terminal Colorscheme through pywal")
			wal_change_color "$selected_files" && echo "Pywal has successfully changed the colorscheme. Please refer to ~/.cache/wal/ for the current colorscheme or ~/.cache/wal/schemes for all archived/past colorschemes." || echo "Error setting pywal."
			;;
		"Get Path Only")
			dirname="$(get_path_only $selected_files)"
			echo "Path: $dirname"
			;;
		"Get Filename Only")
			fname="$(get_filename_only $selected_files)"
			echo "Filename: $fname"
			;;
		"Get Extension")
			ext="$(get_extension $selected_files)"
			echo "Extension: $ext"
			;;
        "Quit")
            break
            ;;
        *) echo "invalid option $REPLY";;
    esac
done
