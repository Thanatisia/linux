#########################################
# Update Changelog (Master)  			#
# Contains:                  			#
#	Current Date/Time        			#
#		(Date of Update)	 			#
#	Changelog Topic Category 			#
#		- examples:			 			#
#			[git],			 			#
#			[Installs]		 			#
#	Changelog Title          			#
#		- examples:						#
#			Installed <package-name>	#
#	Changelog Description    			#
#########################################

# Default Variables
DEFAULT_CATEGORY="General"
DEFAULT_TITLE="Placeholder"
DEFAULT_DESCRIPTION="NIL"
HELP="
Parameters:
	1: [ Your Changelog entry Category, {'Update'|'Modify'|'Create'|'Removed'} ],
	2: [ Your Changelog entry title, {'Updated \"update-changelog.sh\" script'}],
	3: [ Your Changelog entry description ],
	4: --help for this help screen
Usage:
	1: update-changelog.sh --help
	2: update-changelog.sh \"Update\" \"Updated GRUB Config\" \"Testing Description\"
"

# Command Line Variables
if [ ! -z "$1" ]; then
	if [ "$1" == "--help" ]; then
		# Get help
		echo "Help:"
		echo "$HELP"
	else
		# If not empty
		CHANGELOG_TOPIC_CATEGORY="$1"

		if [ ! -z "$2" ]; then
			CHANGELOG_TITLE="$2"

			if [ ! -z "$3" ]; then
				CHANGELOG_DESCRIPTION="$3"
			else
				# If no changelog description
				read -p "Changelog Description: " CHANGELOG_DESCRIPTION
				if [ -z "$CHANGELOG_DESCRIPTION" ]; then
					CHANGELOG_DESCRIPTION=$DEFAULT_DESCRIPTION
				fi
			fi
		else
			# Title
			read -p "Changelog Title: " CHANGELOG_TITLE
			if [ -z "$CHANGELOG_TITLE" ]; then
				CHANGELOG_TITLE=$DEFAULT_TITLE
			fi

			# Description
			read -p "Changelog Description: " CHANGELOG_DESCRIPTION
			if [ -z "$CHANGELOG_DESCRIPTION" ]; then
				CHANGELOG_DESCRIPTION=$DEFAULT_DESCRIPTION
			fi
		fi
	fi
else
	# Category
	read -p "Changelog Category: " CHANGELOG_TOPIC_CATEGORY
	if [ -z "$CHANGELOG_TOPIC_CATEGORY" ]; then
		CHANGELOG_TOPIC_CATEGORY=$DEFAULT_CATEGORY
	fi
	
	# Title
	read -p "Changelog Title: " CHANGELOG_TITLE
	if [ -z "$CHANGELOG_TITLE" ]; then
		CHANGELOG_TITLE=$DEFAULT_TITLE
	fi

	# Description
	read -p "Changelog Description: " CHANGELOG_DESCRIPTION
	if [ -z "$CHANGELOG_DESCRIPTION" ]; then
		CHANGELOG_DESCRIPTION=$DEFAULT_DESCRIPTION
	fi
fi

# Global Variables
CHANGELOG_FILE_PATH=~/.logs
CHANGELOG_FILE_NAME="master-changelog.log"
CHANGELOG_FILE="$CHANGELOG_FILE_PATH/$CHANGELOG_FILE_NAME"

# Constants
date_format='%Y-%m-%d' # Year-Month-Date
time_format='%H-%M-%S' # Hour-Minutes-Seconds
seperator=" "
now="$(date +"$date_format$seperator$time_format")"

if [ ! -z "$CHANGELOG_TOPIC_CATEGORY" ]; then
	echo "$now" | tee -a $CHANGELOG_FILE
	echo "[$CHANGELOG_TOPIC_CATEGORY]" | tee -a $CHANGELOG_FILE
	echo "Title: $CHANGELOG_TITLE" | tee -a $CHANGELOG_FILE
	echo "Changelog: $CHANGELOG_DESCRIPTION" | tee -a $CHANGELOG_FILE
	echo "" >> $CHANGELOG_FILE

	echo "Master Changelog [$CHANGELOG_FILE] has been updated as of [$now]"
fi