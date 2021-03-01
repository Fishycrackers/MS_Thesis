#!/bin/bash

# Given a directory, scans all file within the directory and pulls out 
# any references to .so files. Creates a relationship between
# the reference and the file that it was extracted from

# Set output file name
OUTPUT_FILE=dependency_list.csv

# Get directory of files needing to be parsed from cmd line
directory_path=$1

# Find all files in target directory
files=`ls $directory_path|egrep "*.so"`

echo "origin, dependency" > $OUTPUT_FILE

for file in $files
do
	dependencies=`strings $directory_path$file | egrep "*.so|*.cpp"`

	echo "$dependencies"

	for dep in $dependencies
	do
		echo "$file, $dep" >>  $OUTPUT_FILE

	done
done

