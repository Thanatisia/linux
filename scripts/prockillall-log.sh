#----------------------------------
# Kill Process using killall and  
# Log file
#----------------------------------

now="$(date +'%Y-%m-%d_%H-%M-%S')H"
LOG=~/.logs/killall.log

# killall the proc
# 
# $1 : Process to kill
#
proc=$1
killall $proc | tee -a $LOG && echo "$now : Successfully closed [$proc]" | tee -a $LOG || echo "$now : Error closing [$proc]" | tee -a $LOG

# Add seperator
echo "---"
