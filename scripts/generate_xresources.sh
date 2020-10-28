##############################
# Generating xResources file #
##############################

if [ ! -f ~/.Xresources ]; then
	# Not Found
	echo ".Xresources files does not exist"
	xrdb -query | tee -a ~/.Xresources
else
	echo ".Xresources file exists"
fi