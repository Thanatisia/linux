# ---
# Open python file and run it on close
# ---

# -- Python parameters
DEFAULT_PYTHON_VERSION="$(python -V | cut -d ' ' -f2)"
DEFAULT_PYTHON_VERSION_MAJOR="$(echo $DEFAULT_PYTHON_VERSION | cut -d '.' -f1)"
DEFAULT_PYTHON_VERSION_MINOR="$(echo $DEFAULT_PYTHON_VERSION | cut -d '.' -f2)"
DEFAULT_PYTHON_VERSION_2Digits="$DEFAULT_PYTHON_VERSION_MAJOR.$DEFAULT_PYTHON_VERSION_MINOR"
echo "Running Python: $DEFAULT_PYTHON_VERSION_2Digits"

pyscript="main"
pyscript_ext="py"
if [ ! -z "$1" ]; then
	# if file is provided
	pyscript="$1"
else
	read -p "Enter python script filename: " pyscript_tmp
	if [ ! -z "$pyscript_tmp" ]; then
		pyscript="$pyscript_tmp"	
	fi
fi

if [ ! -z "$pyscript" ]; then
	pyscript_ext="$(echo $pyscript | cut -d '.' -f2)"
fi

####################################
# Execute vim and open python file #
####################################
vim "$pyscript"

#####################
# Run Python script #
#####################
if [ "$pyscript_ext" == "py" ]; then
	python$DEFAULT_PYTHON_VERSION_2Digits "$pyscript"
else
	echo "File is not python (.py) format"
fi
