function rofi_dmenu()
{
	res="$(echo -e "$str" | rofi -dmenu)"
	echo "$res"
}

echo "$(rofi_dmenu)"