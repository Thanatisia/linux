# 
# Language: C++
# Output:
#import <iostream>
#import <cstdio>
#import <cstdlib>
#import <string>
#import <string.h>
# using std::cout;
# using std::cin;
# using std::endl;
# using std::string;

# int autocmd(string cmdstr)
# {
# 	int res = 0;
# 	const char *cmd = "";
# 	cmd = cmdstr.c_str(); /* Convert string to const char */
# 	res = system(cmd);
# 	return res;
# }

# int main(int argc, const char *argv[])
# {
# 	cout << "Hello World" << endl;

# 	//autocmd
# 	string cmdstr = "echo Current Directory: && dir && cd .. && echo New Directory: && dir";
# 	cout << "Autocmd:" << endl << " ";
# 	int res = autocmd(cmdstr);
# 	if(res == 0)
# 	{
# 		cout << "Command: [ " << cmdstr << " ] is successful." << endl;
# 	}
# 	else
# 	{
# 		cout << "Error running command [ " << cmdstr << " ] " << endl;
# 	}
# 	return 1;
# }

############################
# Design the file template #
############################
CWD="$(pwd)"
FILEPATH=$CWD/src
FILENAME="main"
FILEXT="cpp"
FILEDETAILS="$FILEPATH/$FILENAME.$FILEXT"

# Create the folder if does not exist
if [ ! -d $FILEPATH ]; then
	# If folder does not exist
	mkdir $FILEPATH
fi

# Check if file already exists
if [ ! -f $FILEDETAILS ]; then
	# If file does not exist
	# Create the file
	touch "$FILEDETAILS"

	# Insert the rows
	echo "#import <iostream>" | tee -a $FILEDETAILS
	echo "#import <cstdio>" | tee -a $FILEDETAILS
	echo "#import <cstdlib>" | tee -a $FILEDETAILS
	echo "#import <string>" | tee -a $FILEDETAILS
	echo "#import <string.h>" | tee -a $FILEDETAILS
	echo "using std::cout;" | tee -a $FILEDETAILS
	echo "using std::cin;" | tee -a $FILEDETAILS
	echo "using std::endl;" | tee -a $FILEDETAILS
	echo "using std::string;" | tee -a $FILEDETAILS
	echo "" | tee -a $FILEDETAILS
	echo "int autocmd(string cmdstr)" | tee -a $FILEDETAILS
	echo "{" | tee -a $FILEDETAILS
	echo "	int res = 0;" | tee -a $FILEDETAILS
	echo "	const char *cmd = \"\";" | tee -a $FILEDETAILS
	echo "	cmd = cmdstr.c_str(); /* Convert string to const char */" | tee -a $FILEDETAILS
	echo "	res = system(cmd);" | tee -a $FILEDETAILS
	echo "	return res;" | tee -a $FILEDETAILS
	echo "}" | tee -a $FILEDETAILS
	echo "" | tee -a $FILEDETAILS
	echo "int main(int argc, const char *argv[])" | tee -a $FILEDETAILS
	echo "{" | tee -a $FILEDETAILS
	echo "	cout << \"Hello World\" << endl;" | tee -a $FILEDETAILS
	echo "	return 1;" | tee -a $FILEDETAILS
	echo "}" | tee -a $FILEDETAILS

	# Check if file exists
	if [ -f $FILEDETAILS ]; then
		# Found
		# Test if valid
		cpp_compile.sh "$FILEPATH/main.cpp" "$FILEPATH/main.exe" " "
		if [ "$?" == "0" ]; then
			# Success
			echo "Success, file [$FILEDETAILS] has been generated."
		else
			echo "Error generating file [$FILEDETAILS]"
		fi
	fi

	# Delete the file
	rm "$FILEPATH/main.exe"
else
	echo "File [$FILEDETAILS] already exists"
fi