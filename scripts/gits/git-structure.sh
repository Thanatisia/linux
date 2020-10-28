############################
# Push to online repository
# all at once here
# via git in a basic structur
############################

#
# basic git structure
# -------------------
# git add * # Add all files
# git commit -m "Added files"
# git push origin master
#

if [ ! -z "$1" ]; then
    # files to add
    files=$1

    if [ ! -z "$2" ]; then
        # Message
        msg="$2"
    
        if [ ! -z "$3" ]; then
            # Origin
            origin=$3
        else
            origin="master"
        fi
    else
        msg="Added files/folders"
        origin="master"
    fi
else
    read -p "Files to add: " files
    msg="Added files/folders"
    origin="master"
fi

git add $files
git commit -m $msg
git push origin $origin
