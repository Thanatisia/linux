#----------------------------
# Rofi menu utilities
#----------------------------

function rofi_dmenu()
{
	str="$1"
	if [ ! -z "$str" ]; then
		res="$(echo -e "$str" | rofi -dmenu)"
	fi
	echo "$res"
}

