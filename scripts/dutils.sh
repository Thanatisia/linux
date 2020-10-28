#############################
# Contains Dmenu or related #
# scripts                   #
#############################

function dinput()
{
    msg="$1"
    dmenu -p "$msg" <&-
}

function doptions()
{
    #
    #Echo individual options
    # 
    options=$1
    delimiter="\n"
    join_str=""
    
    # For loop to join string by delimiter
    for opts in ${options[@]}; do
        join_str+="$opts""$delimiter"
    done
    res="$(echo -e "$join_str" | dmenu)"
    echo "$res"
}
