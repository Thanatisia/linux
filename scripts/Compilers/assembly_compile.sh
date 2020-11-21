#------------------------
# Assembly compilation
# powered by nasm
#------------------------

if [ ! -z "$1" ]; then
	# Source file
	src_file=$1

	if [ ! -z "$2" ]; then
	    # Object file
	    obj_file=$2

	    if [ ! -z "$3" ]; then
	        # Output executable file
	        output_executable_file=$3
	    
	        if [ ! -z "$4" ]; then
	            # nasm format
	            # default: elf32
	            nasm_format=$4

	            if [ ! -z "$5" ]; then
	                # nasm executable format
	                # default: elf_i386
	                nasm_exe_format=$5
	            else
	                # nasm_exe_format="elf_i386"
	                nasm_exe_format=""
                fi
	        else
	            nasm_format="elf64"
	            # nasm_exe_format="elf_i386"
                nasm_exe_format=""
	        fi
	    else
	        read -p "Output executable file (i.e. helloworld.exe): " output_executable_file
	        nasm_format="elf64"
	        # nasm_exe_format="elf_i386"
            nasm_exe_format=""
	    fi
	else
	    read -p "Output object file (i.e helloworld.o): " obj_file
	    read -p "Output executable file (i.e. helloworld.exe): " output_executable_file
	    nasm_format="elf64"
	    # nasm_exe_format="elf_i386"
        nasm_exe_format=""
	fi
else
		read -p "Input source file (i.e. helloworld.asm): " src_file
	    read -p "Output object file (i.e helloworld.o): " obj_file
	    read -p "Output executable file (i.e. helloworld.exe): " output_executable_file
	    nasm_format="elf64"
	    # nasm_exe_format="elf_i386"
        nasm_exe_format=""
fi

# --- Example
# Create the object file
# 32-bit
#nasm -f elf32 -o $obj_file $src_file

# Make object file into an executable
# 32-bit
#ld -m elf_i386 -o $output_executable_file $obj_file

# --- Main
# Create the object file
nasm -f $nasm_format -o $obj_file $src_file | tee -a ~/.logs/asm-compilation-proc.log && echo "$obj_file has been generated." || echo "Error generating object file $obj_file"

# Make object file into an executable
if [ ! -z "$nasm_exe_format" ]; then
    ld -m $nasm_exe_format -o $output_executable_file $obj_file | tee -a ~/.logs/asm-compilation-proc.log && echo "$obj_file has been converted to executable file $output_executable_file" || echo "Error converting to $output_executable_file"
else
    ld -o $output_executable_file $obj_file | tee -a ~/.logs/asm-compilation-proc.log && echo "$obj_file has been converted to executable file $output_executable_file" || echo "Error converting to $output_executable_file"
fi
