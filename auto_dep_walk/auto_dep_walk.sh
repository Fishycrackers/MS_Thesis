#!/bin/bash

# Given a directory, scans all file within the directory and pulls out 
# any references to .so files. Creates a relationship between
# the reference and the file that it was extracted from

# Set output file nameb
OUTPUT_FILE=dependency_list.csv
ID=1

# Get directory of files needing to be parsed from cmd line
directory_path=$1

# Find all Object files in target directory
files=`ls $directory_path|egrep "*.so"`

# Prepare output file to be imported into draw.io
cat drawio_preamble.txt > $OUTPUT_FILE
echo "" >> $OUTPUT_FILE

# Create csv headers
echo "id,origin,dependency" >> $OUTPUT_FILE

# Process all target files in directory
for file in $files
do
	# Search for all .so and .cpp references in file
	dependencies=`strings $directory_path$file | egrep "*.so|*.cpp"`
	
	
	echo "$dependencies"
	
	# Process all dependencies found per library file
	for dep in $dependencies
	do
		# Clean up numbers inserted by Autopsy into filenames
		filename=`echo $file | awk '{print substr($0,index($0,"-")+1)}'`
		
		# Print dependency relationship into output file
		echo "$ID,$filename,$dep" >>  $OUTPUT_FILE
		((ID++))
	done
done

