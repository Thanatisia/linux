#----------------------------
# Customized menu using Rofi
#----------------------------

# Import rofiutil.sh library
. rofiutils.sh

# -- Global variables
options_array=("Hello World" "HelloWorld" "Hello")
options_str="HelloWorld\nHello World\nHello"

# -- Functions
function join_str()
{
	for opt in "${options_array[@]}"; do
		options+="$opt\n"
	done
	echo "$options"
}

options="$(join_str)"
selected_option="$(rofi_dmenu "$options")"
echo "Selected: $selected_option"