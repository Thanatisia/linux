##########################
# Polybar Specifications #
##########################

# Polybar parameters
POLYBAR_OPTIONS=-c ~/.config/polybar/config

# Polybar bars
POLYBAR_1_NAME="default"
POLYBAR_1_LOGPATH=~/.logs
POLYBAR_1_LOGNAME="polybar1.log"
POLYBAR_1_LOGFILE="$POLYBAR_1_LOGPATH/$POLYBAR_1_LOGNAME"
POLYBAR_2_NAME="hdmi1"
POLYBAR_2_LOGPATH=~/.logs
POLYBAR_2_LOGNAME="polybar2.log"
POLYBAR_2_LOGFILE="$POLYBAR_2_LOGPATH/$POLYBAR_2_LOGNAME"

###########
# Startup #
###########
# Terminate already running bar instances
killall -q polybar 
# If all your bars have ipc enabled, you can also use 
# polybar-msg cmd quit

###############
# Application #
###############

# Launch bar1 and bar2
# echo "---" | tee -a /tmp/polybar1.log /tmp/polybar2.log
# polybar $POLYBAR_OPTIONS $POLYBAR_1_NAME >>/tmp/polybar1.log 2>&1 
# polybar $POLYBAR_OPTIONS $POLYBAR_2_NAME >>/tmp/polybar2.log 2>&1
echo "---" | tee -a $POLYBAR_1_LOGFILE $POLYBAR_2_LOGFILE
polybar $POLYBAR_OPTIONS $POLYBAR_1_NAME >>$POLYBAR_1_LOGFILE 2>&1 &
# polybar $POLYBAR_OPTIONS $POLYBAR_2_NAME >>$POLYBAR_2_LOGFILE 2>&1 &
polybar $POLYBAR_OPTIONS $POLYBAR_2_NAME >>$POLYBAR_2_LOGFILE 2>&1

echo "Bars launched..."
