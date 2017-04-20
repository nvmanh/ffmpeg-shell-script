#!/bin/sh
files=`ls *.jpg|awk -F"/" '{print $NF}'`
a=1
for file in $files ; do 
	mv "$file" "$a.jpg"; 
	# echo $a
	a=$((a+1))
	# a=$a+1
done