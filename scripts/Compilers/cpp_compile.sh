# ---
# Open C++ file and run it on close
# g++ main.cpp -o main.exe <other params>
# ---

# -- g++ parameters
OTHER_PARAMS=""
src_name="main"
src_ext="cpp"
dst_name="main"
dst_ext="exe"

if [ ! -z "$1" ]; then
	# Input (src) file
	tmp_src="$1"
	if [ ! -z "$tmp_src" ]; then
		# If user input destination is not empty
		param_1_condition_1="$(echo $tmp_src | cut -d '.' -f1)"
		param_1_condition_2="$(echo $tmp_src | cut -d '.' -f2)"
	fi

	if [ ! -z "$2" ]; then
		# Output (dst) file
		tmp_dst="$2"
		if [ ! -z "$tmp_dst" ]; then
			# If user input destination is not empty
			param_2_condition_1="$(echo $tmp_dst | cut -d '.' -f1)"
			param_2_condition_2="$(echo $tmp_dst | cut -d '.' -f2)"
		fi

		if [ ! -z "$3" ]; then
			# Additional Options
			tmp_opt="$3"
			if [ ! -z "$tmp_opt" ]; then
				OTHER_PARAMS="$3"
			fi
		else
			read -p "Additional Options: " OTHER_PARAMS
		fi
	else
		read -p "Destination  file: " tmp_dst
	fi
else
	read -p "Input source file : " tmp_src
	read -p "Destination  file : " tmp_dst
	read -p "Additional Options: " OTHER_PARAMS

	# -- Check Source filename
	if [ ! -z "$tmp_src" ]; then
		# If user input destination is not empty
		param_1_condition_1="$(echo $tmp_src | cut -d '.' -f1)"
		param_1_condition_2="$(echo $tmp_src | cut -d '.' -f2)"
	fi

	# -- Check Destination filename
	if [ ! -z "$tmp_dst" ]; then
		# If user input destination is not empty
		param_2_condition_1="$(echo $tmp_dst | cut -d '.' -f1)"
		param_2_condition_2="$(echo $tmp_dst | cut -d '.' -f2)"
	fi
	
	# -- Check Other additional options
	if [ ! -z "$tmp_opt" ]; then
		OTHER_PARAMS="$3"
	fi
fi

######################
# Prepare Parameters #
######################
if [ "$param_1_condition_1" == "$param_1_condition_2" ]; then
	src_name="$tmp_src"
else
	src_name="$param_1_condition_1"
	src_ext="$param_1_condition_2"
fi

if [ "$param_2_condition_1" == "$param_2_condition_2" ]; then
	dst_name="$tmp_dst"
else
	dst_name="$param_2_condition_1"
	dst_ext="$param_2_condition_2"
fi
src_file="$src_name.$src_ext"
dst_file="$dst_name.$dst_ext"
gpp_params="$src_file -o $dst_file "
if [ ! -z "$OTHER_PARAMS" ]; then
	gpp_params+="$OTHER_PARAMS"
fi
compiler_cmd="g++ $gpp_params"

#####################
# Run script #
#####################
if [ "$src_ext" == "cpp" ]; then
	echo "Executing command: g++ $gpp_params"
	echo "Compiling $src_file to $dst_file..."
	sleep 3
	# $compiler_cmd && echo "Output for [$dst_file]: " && ./$dst_file
	$compiler_cmd
else
	echo "File is not (.$src_ext) format"
fi
