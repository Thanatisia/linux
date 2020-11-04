#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

############
# Defaults #
############
alias ls='ls --color=auto'
PS1='[\u@\h \W]\$ '

#############
# Functions #
#############

# Generates all folders, directories and path required
# usage: generate_config_folders
function generate_config_folders()
{
	# Personal folder
	if [ ! -d ~/configs ]; then
		mkdir ~/configs
	fi

	if [ ! -d ~/configs/shells ]; then
		mkdir ~/configs/shells
	fi

	if [ ! -d ~/configs/shells/bash ]; then
		mkdir ~/configs/shells/bash
	fi
}

# Generates all config files on start
# usage: generate_config_files
function generate_config_files()
{
	# Generate Bashrc Personal file
	if [ ! -f ~/.bashrc-personal ]; then
		# Not Found
		touch ~/.bashrc-personal
		echo "###################" >> ~/.bashrc-personal
		echo "# Bashrc Personal #" >> ~/.bashrc-personal
		echo "###################" >> ~/.bashrc-personal
	fi

	# Generate other config files
}

function prepare_configs()
{
	generate_config_folders
	generate_config_files
}

#########
# Start #
#########

# Prepare config requirements
prepare_configs

# Source and run bashrc-personal
. ~/.bashrc-personal
