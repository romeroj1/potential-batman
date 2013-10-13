#!/bin/bash
IFS=$'\t\n'

if [ -z "$1" ]
then
	echo
	echo  ERROR!
	echo  No input file specified.
	echo  You can an input by draggin a video file to this script or by calling 
	echo  the script on the command prompt and setting the full file path as 
	echo  the first param.
	echo
	sleep 5 
else
	THIS_PATH=${0%/*}
	
	$THIS_PATH/360p.sh $1
	$THIS_PATH/720p.sh $1
	$THIS_PATH/iphone.sh $1
	
fi
