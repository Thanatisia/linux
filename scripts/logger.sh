##########
# Logger #
##########

# -- Functions
function get_datetime()
{
    DEFAULT_DT_FORMAT='%Y-%m-%d_%H-%M-%S'
    dt=""
    # if format is not provided - take "now"
    if [ -z "$1" ]; then
        dt="$(date +$DEFAULT_DT_FORMAT)H"
    else
        USER_DT_FORMAT="$1"
        dt="$(date +$USER_DT_FORMAT)"
    fi
    echo "$dt"
}

function append_to_file()
{
    # 
    # echo the message in terminal 
    # and
    # write/append to 
    # file
	echo "$1" | tee -a "$2"
}

function log_to_file()
{
    # 
    # $1 : Your command
    # $2 : Your log file
    #
    "$1" | tee -a "$2"
}

# -- Defaults
DEFAULT_LOG_FILENAME="tmp.log"

# -- Variables
LOG_CONTENT="$(get_datetime) : "
LOG_PATH=~/.logs/
LOG_FILENAME=$DEFAULT_LOG_FILENAME
LOG_FILE=$LOG_PATH/$LOG_FILENAME

# -- Process Example
# LOG_CONTENT+="Next Content"
# echo "$LOG_CONTENT" | tee -a $LOG_FILE
# output_to_file "$LOG_CONTENT" $LOG_FILE

# -- Process

# Get Logging content
if [ ! -z "$1" ]; then
	LOG_CONTENT+="$1"

    # Get Log filepath & filename
	if [ ! -z "$2" ]; then
		LOG_FILE=$2
	fi

	# Log
    append_to_file "$LOG_CONTENT" $LOG_FILE
fi

#
# -- Use case Example
#
# ## Logging static string
# append_to_file "Hello World" $0
# ## Logging variable string
# res="$(ip a s)"
# append_to_file $res $0

