####################
# Connect to Wifi  #
# powered by nmcli #
####################

# mkdir -p info

# -- Functions
function log_to_file()
{
    # 
    # $1 : Your command
    # $2 : Your log file
    #
    $1 | tee -a "$2"
}

# -- Print out all available wifi
nmcli dev wifi | tee -a ~/.logs/available-wifi.log

# -- Receive info
# AP_name
if [ ! -z "$1" ]; then
	AP_name="$1"

	# AP_password
	if [ ! -z "$2" ]; then
		AP_password="$2"
	else
		read -p "Enter your AP pass: " AP_password
	fi
else
	read -p "Enter your AP name: " AP_name
	read -p "Enter your AP pass: " AP_password
fi

# -- Connect to wifi
connect_Status=0 # Check if connected - 1 for connected; 0 for not connected;
nmcli device wifi connect $AP_name password $AP_password | tee -a ~/.logs/wifi-connecting.log && connect_Status=1 || connect_Status=0

if [ "$connect_Status" == "1" ]; then
	echo "Wifi device [$AP_name] connected successfully." | tee -a ~/.logs/wifi-connected.log 

    # Check if wifi-list exists
    if [ -f ~/.logs/wifi-list.log ]; then
    	# Check if wifi is in list
    	ap_name_check=$(cat ~/.logs/wifi-list.log | grep "$AP_name")
    else
    	ap_name_check=""
    fi

    #
    # If not in list
    # Append to wifi list
    #
    if [ -z "$ap_name_check" ]; then
    	echo "$AP_name does not exist - logging..."
        echo "$AP_name" | tee -a ~/.logs/wifi-list.log
    fi
else
	echo "Error connecting to Wifi device [$AP_name]." | tee -a ~/.logs/wifi-connection-error.log
fi

# log_to_file "nmcli device wifi connect $AP_name password $AP_password" ~/.logs/wifi-connecting.log 
