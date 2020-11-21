#
# Conversion program
# Compiler: .py to exe
#

# usage example:
# python3.8 -m PyInstaller main.py --dist out --workpath tmp --onefile --name main.exe

python_vers="python3.8"
cmd="$python_vers -m PyInstaller "
srcfile=$1
outpath=$2
outname=$3
tmppath=$4
others=$5

# Validation
if [ -z "$srcfile" ]; then
    srcfile="main.py"
fi

if [ -z "$outpath" ]; then
    outpath="out"
fi

if [ -z "$outname" ]; then
    outname="main.exe"
fi

if [ -z "$tmppath" ]; then
    tmppath="tmp"
fi

# Other Options (--dist, --workpath etc. for cmd)
other_opts="--dist $outpath --name $outname --workpath $tmppath --onefile" 
cmd+="$srcfile $other_opts $others"

echo "Executing command:"
echo "$cmd" | tee -a ~/.logs/pyinstaller.log
$cmd |& tee -a ~/.logs/pyinstaller.log

success_check="$?"
if [ "$success_check" == "0" ]; then
    # success 
    echo "Compilation successful." | tee -a ~/.logs/pyinstaller.log 
else
    # Error
    echo "Error compiling [$cmd]" | tee -a ~/.logs/pyinstaller.log
fi

echo " --- " | tee -a ~/.logs/pyinstaller.log
