#############################
# Screenshot                #
# for window manager config #
# Powered by scrot          #
#############################

function dinput()
{
    msg="$1"
    dmenu -p "$msg" <&-
}

DEFAULT_OUT_PATH=~/
DEFAULT_OUT_NAME=ss.png

# Get file path / name via Dmenu
# out_path="$(read -p "Output file path/name: " out_path | dmenu)"
# out_path=$(echo Output file path/name: | dmenu)
# NOTE:
# 	Please use absolute path
out_path="$(dinput "Output file path/name [Note: please use abolute path]: ")"

if [ -z "$out_path" ]; then
	out_path=$DEFAULT_OUT_PATH/$DEFAULT_OUT_NAME
fi

echo "Out Path: $out_path"

# Screenshot using scrot
scrot $out_path && echo "Successfully screenshot'd to $out_path" || echo "Error screenshotting to $out_path" | tee -a ~/.logs/screenshot.logs
