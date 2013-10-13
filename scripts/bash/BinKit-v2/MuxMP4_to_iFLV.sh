#!/bin/bash
IFS=$'\t\n'
#
# Script to remux a MP4/M4V Video File to a Injected FLV Video File
#
# It's important to know taht your MP4/M4V video file HAS to be encoded
# using H.264 for video and AAC for audio.
#

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

	# Input File:
	INPUT=$1

	# File paths
	I_PATH=${1%/*}
	I_FILE=${1##*/}
	BASE=${I_FILE%%.*}
	EXT=${I_FILE#*.}

	# Output
	OUTPUT_FILE_NAME_NOT_INJECTED=$I_PATH/$BASE.240pni.flv
	OUTPUT_FILE_NAME_INJECTED=$I_PATH/$BASE.240p.flv


	# Batch path
	THIS_PATH=${0%/*}

	# Bin path
	BIN_PATH=$THIS_PATH/bin

	# FFmpeg command
	echo Remuxing MP4 to FLV

	$BIN_PATH/ffmpeg -y -i $INPUT  -vcodec copy -acodec copy $OUTPUT_FILE_NAME_NOT_INJECTED

	# inject the FLV video with metadata
	echo Injecting metadata
	$BIN_PATH/flvmeta $OUTPUT_FILE_NAME_NOT_INJECTED $OUTPUT_FILE_NAME_INJECTED && rm $OUTPUT_FILE_NAME_NOT_INJECTED
	echo Creation of $OUTPUT_FILE_NAME_INJECTED Done!

fi
