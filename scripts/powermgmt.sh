####################
# Power Management #
####################

function dinput()
{
    msg="$1"
    dmenu -p "$msg" <&-
}

selected_option="$(echo -e "Shutdown\nLogout\nReboot\Restart\nSuspend" | dmenu)"
# selected_option="$(dinput "Shutdown\nLogout\nReboot\Restart\nSuspend")"
echo "Selected option: $selected_option"

# confirmation="$(read -p "Are you sure? [Y|N]: " confirmation | dmenu)"
# confirmation="$(echo "Are you sure? [Y|N]: " | dmenu)"
if [ -z "$selected_option" ]; then
	echo "Cancelled." | tee -a ~/.logs/powermgmt.log
else
	confirmation="$(dinput "Are you sure? [Y|N]: ")"
	echo "Confirmation: $confirmation"
	if [ "$confirmation" == "Y" ]; then
		# Log option
		echo "$selected_option" >> ~/.logs/powermgmt.log
		
		# Run selection
		if [ "$selected_option" == "Shutdown" ]; then   
	        # sudo -S shutdown now | tee -a ~/.logs/powermgmt.log | dinput "Password: " 
			echo "$(dinput 'Password: ')" | sudo -S shutdown now |& tee -a ~/.logs/powermgmt.log
		elif [ "$selected_option" == "Reboot\Restart" ]; then
            echo "$(dinput 'Password: ')" | sudo -S reboot now |& tee -a ~/.logs/powermgmt.log
            #if [ "$confirmation" == "Y" ]; then
		        # sudo reboot now | dmenu | tee -a ~/.logs/powermgmt.log
            #fi
		elif [ "$selected_option" == "Logout" ]; then
		    #if [ "$confirmation" == "Y" ]; then
		        # i3-msg exit | tee -a ~/.logs/powermgmt.log
		    i3-msg exit
		    #fi
		elif [ "$selected_option" == "Suspend" ]; then
		    #if [ "$confirmation" == "Y" ]; then
		    	# Requires dmenu for password input
		    sudo systemctl suspend | dmenu | tee -a ~/.logs/powermgmt.log
		    #fi
		else
	    	echo "Invalid option" | tee -a ~/.logs/powermgmt.log
		fi
	else
		echo "Cancelled." | tee -a ~/.logs/powermgmt.log
	fi
fi
