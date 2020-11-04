#####################
# i3 Startup Script #
#####################

##########################
# Command Line Variables #
##########################
if [ ! -z "$1" ]; then
	TERM=$1

	if [ "$#" -gt "1" ]; then
        PROGRAMS=(${@:2})
	fi
fi


##############
# Containers #
##############
# neix_prog_details=(~/Desktop/portable/repos/neix/bin/ neix ~/Desktop/portable/repos/neix/bin/neix)
# calcurse_prog_details=(/usr/bin calcurse /usr/bin/calcurse)

#############
# Variables #
#############
START_PROG_PATH=""
START_PROG_NAME=""
START_PROG_EXE=""
target_prog="" # selected & target program

###########
# Process #
###########
if [ ! -z "$PROGRAMS" ]; then
	case "${PROGRAMS[0]}" in
		"neix")
			# target_prog=("${neix_prog_details[@]}")
			target_prog="neix"
			;;
		"calcurse")
			# target_prog=("${calcurse_prog_details[@]}")
			target_prog="calcurse"
			;;
		*) echo "Unrecognized program."
			;;
	esac

	START_PROG_PATH="${PROGRAMS[1]}"
	echo "Program Path: $START_PROG_PATH"
	START_PROG_NAME=$target_prog
	START_PROG_EXE=$START_PROG_PATH/$START_PROG_NAME

	# ##################
	# # Run on Startup #
	# ##################
	$TERM --title $START_PROG_NAME --command $START_PROG_EXE |& tee -a ~/.logs/i3startup.log
	echo "programs started." | tee -a ~/.logs/i3startup.log
else
	echo "No program were mentioned." | tee -a ~/.logs/i3startup.log
fi