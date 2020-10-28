#-----------------
# strutil
# String Utilities
#-----------------

# # : Delete from the front
# % : Delete from the end

# function delete_substr_from_str_from_beginning()
function str_remove_substr_from_front()
{
	# 
	# Take a string
	# - Remove a specified substring starting from the front
	#
	if [ ! -z "$1" ]; then
		strvar="$1"
		if [ ! -z "$2" ]; then
			substr="$2"
		fi
	fi

	# Delete substring from the beginning of the given string
	echo "${strvar#$substr}"
}

function str_remove_substr_from_back()
{
	# 
	# Take a string
	# - Remove a specified substring starting from the back
	#
	if [ ! -z "$1" ]; then
		strvar="$1"
		if [ ! -z "$2" ]; then
			substr="$2"
		fi
	fi

	# Delete substring from the beginning of the given string
	echo "${strvar%$substr}"
}