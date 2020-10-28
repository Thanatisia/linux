#
# Script-Title
# Requires package group:
#   <dependencies>
# 

######################
# General Properties #
######################
path_to_program=~/path/to/program/or/files
# Append program to path
PATH="$path_to_program":$PATH

#
# -- Variables & Functions --
#

############
# Defaults #
############
DEFAULT_INPUT_PATH=~/
DEFAULT_OUTPUT_PATH=~/

#############
# Functions #
#############
function display_in_terminal()
{
	echo_msg="$1"
	echo "$echo_msg" > /dev/stderr
}

function help()
{
	display_in_terminal " -- Help -- "
	display_in_terminal "	Param-1 : Your input file "
	display_in_terminal	"	Param-2 : Your Output file "
}

#
# -- Program Parameters --
#

################
# Input/Output #
################
# Defaults:
# INPUT_FILE=~/Desktop/portable/documents/Markdown/pandoc-beamer-test_1.md
# OUTPUT_FILE=~/pres.pdf
if [ ! -z "$1" ]; then
	# Input file - not empty
	INPUT_FILE=$1

	if [ ! -z "$2" ]; then
		# Output file - not empty
		OUTPUT_FILE="$2"
	fi
fi

#####################
# Program Properties #
#####################
PROGRAM_OPTIONS="<your_options>"
echo "Program Options: $PROGRAM_OPTIONS"

#############################
# Processing and Validation #
#############################

# If both Input and Output file are not empty
if [ ! "$INPUT_FILE" == "" ] && [ ! "$OUTPUT_FILE" == "" ]; then
	echo "Converting:"
	echo "	Source File: $INPUT_FILE"
	echo "	Source Ext : ${INPUT_FILE##*.}"
	echo "	Output File: $OUTPUT_FILE"
	pandoc $INPUT_FILE $PANDOC_OPTIONS $PANDOC_OUTPUT && echo "Successfully converted $INPUT_FILE to $OUTPUT_FILE" | tee -a ~/.logs/pandoc-convert.log || echo "Error converting $INPUT_FILE to $OUTPUT_FILE" | tee -a ~/.logs/pandoc-convert.log 
elif [ "$INPUT_FILE" == "" ] && [ "$OUTPUT_FILE" == "" ]; then
	echo "Both Input and Output files are empty."
	help
elif [ "$INPUT_FILE" == "" ]; then
	echo "Input file is empty"
	help
elif [ "$OUTPUT_FILE" == "" ]; then
	echo "Output file is empty"
	help
else
	echo "General error detected."
	help
fi
