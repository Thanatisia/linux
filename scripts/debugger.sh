#############################################
#				The Debugger				#
# Test your functions from the library here #
#############################################

####################
# Import libraries #
####################
. ~/Desktop/portable/scripts/bash/shlib.sh # Bash shell library
. ~/Desktop/portable/scripts/bash/dutils.sh # Dmenu shell library

FILE_PATH="/path/to/file.ext"
function get_fname()
{
	filename="$(filename_get_name $FILE_PATH)"
	echo "$filename"
}

function getext()
{
	# --- File functions
	fileext="$(filename_get_ext $FILE_PATH)"
	echo "$fileext"
}

function debug()
{
	fname=$(get_fname)
	ext=$(getext)
	echo "	File Name: $fname"
	echo "	File extension: $ext"
}

function main()
{
	echo "Debugging shlib: "
	echo "$(debug)"

    echo "Debugging Dmenu: "
    options=(help 'Option 1')
    res="$(doptions ${options[@]})"
    display_in_terminal "Result: $res" 
}


# echo "$(main)"
options=(help "Option1")
echo $(doptions ${options[@]})
