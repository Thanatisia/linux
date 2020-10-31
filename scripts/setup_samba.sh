###############
# Bash Script #
###############

####################
# Global Variables #
####################
ALL_OPTIONS=("--help" "--run")

##########################
# Command Line Variables #
##########################

#
# Get command line variables
#
# If option is not empty
if [ ! -z "$1" ]; then
	option="$1"

	if [ "$#" -gt "1" ]; then
        argv=(${@:2})
	fi
fi

#############
# Functions #
#############

# To print out all options
function display_all_options()
{
	for opt in ${ALL_OPTIONS[@]}; do
		echo "	$opt"
	done
}

function function_name()
{
	# Insert your code here
	echo "Hello World"
}

##############
# Processing #
##############

case "$option" in
	"--help") echo "Help"
	 	display_all_options 
		;;
    "--run") echo "Creating samba..."
        samba_config_folder=/etc/samba
        samba_config_file="$samba_config_folder/smb.conf"

        # Getting Variables
        workgroup="${argv[0]}"
        server_string="${argv[1]}"
        sharename="${argv[2]}"
        comment="${argv[3]}"
        samba_folder="${argv[4]}"
        writable="${argv[5]}"
        browsable="${argv[6]}"
        permission_for_all_files="${argv[7]}"
        permission_for_all_folders="${argv[8]}"
        read_only="${argv[9]}"
        guest_ok="${argv[10]}"
        sambagroup="${argv[11]}"
        target_user="${argv[12]}"

        # Validation - Variables
        if [ -z "$workgroup" ]; then
            echo "workgroup has been defaulted to WORKGROUP"
            workgroup="WORKGROUP"
        fi

        if [ -z "$server_string" ]; then
            echo "Server string has been defaulted to 'Server String'"
            server_string="Server String"
        fi 

        if [ -z "$sharename" ]; then
            echo "Sharename has been defaulted to 'sambashare'"
            sharename="sambashare"
        fi

        if [ -z "$comment" ]; then
            echo "comment has been defaulted to 'Samba share'"
            comment="Samba share"
        fi 

        if [ -z "$samba_folder" ]; then
            read -p "Samba folder path: " samba_folder
        fi

        if [ -z "$writable" ]; then
            echo "Defaulted to writable"
            writable="yes"
        fi

        if [ -z "$browsable" ]; then
            echo "Defaulted to browsable"
            browsable="yes"
        fi 

        if [ -z "$permission_for_all_files" ]; then
            permission_for_all_files=0700
        fi

        if [ -z "$permission_for_all_folders" ]; then
            echo "Defaulted to read and write"
            permission_for_all_folders=0700
        fi

        if [ -z "$read_only" ]; then
            echo "defaulted to not read_only"
            read_only="no"
        fi 

        if [ -z "$guest_ok" ]; then
            echo "defauted to yes - dont need to be registered"
            # no - must be registered.
            guest_ok="yes"
        fi

        if [ -z "$sambagroup" ]; then
            read -p "Samba group: " sambagroup
        fi 

        if [ -z "$target_user" ]; then
            read -p "Target username: " target_user
        fi

        # Validation - Folder/Files
        echo "Validating $samba_config_folder exists..."
        if [ ! -d $samba_config_folder ]; then
            sudo mkdir -p $samba_config_folder
        fi

        echo "Validating $samba_config_file exists..."
        if [ ! -f $samba_config_file ]; then
            # if samba config file not found
            echo "Samba config not found, creating..."
            sudo touch $samba_config_file
            echo "[global]" | tee -a $samba_config_file
            echo "  workgroup = $workgroup" | tee -a $samba_config_file
            echo "  server string = "$server_string"" | tee -a $samba_config_file
            echo "[$sharename]" | tee -a $samba_config_file
            echo "comment = $comment" | tee -a $samba_config_file
            echo "path = $samba_folder" | tee -a $samba_config_file
            echo "writable = $writable" | tee -a $samba_config_file
            echo "browsable = $browsable" | tee -a $samba_config_file
            echo "create mask = $permission_for_all_files" | tee -a $samba_config_file # Permission for all files in this folders
            echo "directory mask = $permission_for_all_folders" | tee -a $samba_config_file # Permission for all folders in this folder
            echo "read only = $read_only" | tee -a $samba_config_file
            echo "guest ok = $guest_ok" | tee -a $samba_config_file # This is not a guest - must be registered

            # Other options
            for others in ${argv:13}; do 
                echo "$others" | tee -a $samba_config_file
            done
        fi

        echo ""

        # Executing
        if [ ! -z "$sambagroup" ] && [ ! -z "$target_user" ]; then
            echo "Creating new group - sambausers"
            sudo groupadd -r $sambagroup
            echo "Adding user to new group"
            sudo usermod -aG $sambagroup $target_user # -a : Additional, G : Supplementary group

            echo ""

            echo "Setting new samba password..."
            sudo smbpasswd -a $target_user

            echo ""
        fi

        echo "Creating samba folder..." 
        sudo mkdir $samba_folder
        sudo chown -R :$sambagroup $samba_folder # Change ownership to sambausers group
        sudo chmod 1770 $samba_folder

        echo ""

        echo "Starting samba server..."
        sudo systemctl start smb # Start samba server

        echo ""
        ;;
    *) echo "Default"
		display_all_options
		;;
esac
