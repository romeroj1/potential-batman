#!/bin/bash
IFS=$'\t\n'
#
# Encoding settings for 480p
# You can change any VALUE below this line:
#


# Video Size - Dimensions divisible by 16
# Use 848x480 for widescreen video and 640x480 for standard 4:3 video
SIZE=848x480

# Image Aspect Ratio
# use 16:9 for widescreen video and 4:3 for standar video
ASPECT=16:9

# Frame Rate - for 29.97 use 30000/1001 and for 23.976 use 24000/1001
FRAME_RATE=30000/1001

# Keyframe every # frames, recomended use the same frame rate value but as an integer
KEYFRAME=30

# Bitrate in kilobites per second, NOT kilobytes, 1 kilobyte = 8 kilobits
BITRATE=1072

# Max bit rate
MAXRATE=1616

# Audio channels, use 1 for mono and 2 for stereo
AUDIO_CHANNELS=2

# Audio rate, Flash can handle up to 44100
AUDIO_RATE=44100

# Audio bitrate in kilobites
AUDIO_BITRATE=128










# ----------------------------------------------------------------------------
# WARNING!
# DONT TOUCH OR CHANGE NOTHING BELOW THIS LINE!
# ----------------------------------------------------------------------------

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
	OUTPUT_FILE_NAME_NOT_INJECTED=$I_PATH/$BASE.480pni.flv
	OUTPUT_FILE_NAME_INJECTED=$I_PATH/$BASE.480p.flv

	# Buffer size
	let BUFSIZE=$MAXRATE*2

	# Batch path
	THIS_PATH=${0%/*}/..

	# Bin path
	BIN_PATH=$THIS_PATH/bin

	# FFmpeg command
	echo First Pass Encoding.
	$BIN_PATH/ffmpeg -y -i $INPUT -threads 0 -s $SIZE -aspect $ASPECT -r $FRAME_RATE -b "$BITRATE"k -maxrate "$MAXRATE"k -bufsize "$BUFSIZE"k -vcodec libx264 -g $KEYFRAME -pass 1 -vpre $BIN_PATH/fastfirstpass.ffpreset -an -f rawvideo /dev/null
	echo Second Pass Encoding.
	$BIN_PATH/ffmpeg -y -i $INPUT -threads 0 -s $SIZE -aspect $ASPECT -r $FRAME_RATE -b "$BITRATE"k -maxrate "$MAXRATE"k -bufsize "$BUFSIZE"k -vcodec libx264 -g $KEYFRAME -pass 2 -vpre $BIN_PATH/hq.ffpreset -acodec libfaac -ac $AUDIO_CHANNELS -ar $AUDIO_RATE -ab "$AUDIO_BITRATE"k $OUTPUT_FILE_NAME_NOT_INJECTED

	# Remove the logs
	echo Removing pass logs.
	rm ffmpeg2pass-0.log
	rm x264_2pass.log

	# inject the FLV video with metadata
	echo Injecting metadata
	$BIN_PATH/flvmeta $OUTPUT_FILE_NAME_NOT_INJECTED $OUTPUT_FILE_NAME_INJECTED && rm $OUTPUT_FILE_NAME_NOT_INJECTED
	echo Creation of $OUTPUT_FILE_NAME_INJECTED Done!

fi
