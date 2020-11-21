# 
# dmenu_run wrapper that logs all recently opened programs
#

logfile=~/.logs/last-opened.log

# Check if file exists
if [ ! -f $logfile ]; then
    # If doesnt not exist
    # Create
    touch $logfile
fi

# dmenu_run : A dmenu program that has all programs
# dmenu_run


