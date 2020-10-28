################
# Generate ToC #
# This file    #
#  - scripts   #
################

cwd="$(pwd)"
TARGET_FILE="toc.md"

# Get contents and write to array
contents=("$(ls --all)")
number_of_contents="$(echo "$contents" | wc -l)"

# Check if toc.md exists
if [ ! -f "$TARGET_FILE" ]; then
	touch $TARGET_FILE
	echo "Table of Contents for Directory [$cwd]" | tee -a $TARGET_FILE
	echo "Number of Contents: $number_of_contents" | tee -a $TARGET_FILE
fi

# Add contents to toc.md
echo "# Contents" | tee -a $TARGET_FILE

# Loop through all contents
for f in $contents; do
	echo "$f" | tee -a $TARGET_FILE
	# echo "File/Folder: $f"
done