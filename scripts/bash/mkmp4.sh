#! /bin/bash

# This bash script has been created by Diego Massanti
# www.massanti.com
# 
# set -x # uncomment this for debugging
shopt -s nullglob # so the glob expands to nothing when there are no .mov files.


# User settings:

fileext=".mov" # Set this variable to the video file extension that you want to search for when encoding whole directories.

# End user settings
# You should not change anything below this line unless you know what you are doing.

usage()
{
cat << EOF
usage: $0 -f <file to encode> [-w <integer>] -b <integer> [-q][-k][-t][-o <filesystem directory>]

* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
* h264 video with he-aac audio encoding script by Diego Massanti. *
*                September 2008, Made in Argentina.               *
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

OPTIONS:
   	-h	Show this message
	-f	Path to the file to encode < REQUIRED
   	-w	Resize video to fit inside this width while keeping the aspect ratio < OPTIONAL
   	-b	Desired video bitrate < REQUIRED
	-o	Output directory for compressed media < OPTIONAL (will use same as source if ommited)
   	-q 	Better quality encoding using 2 passes (slower) < OPTIONAL
	-k	Do not delete (keep) temporary files < OPTIONAL
EOF
}
audiobitrate=48000
platform=""
uname=`uname`
if [ $uname == "Darwin" ]; then
	## 99% of chances that this is a Mac
	platform="Mac"
else
	platform="Linux"
fi

width=""
bitrate=
deltemp=TRUE
quality=FALSE
poster=FALSE
filename=""
rsize=""
outdir=`pwd`
outFileName=""
itemVideoBitrate=""


while getopts ":f:w:o:b:qktv" OPTION; do
	case $OPTION in
		w ) width=$OPTARG;;
		f ) filename=$OPTARG;;
		b ) bitrate=$OPTARG;;
		k ) deltemp=FALSE;;
		q ) quality=TRUE;;
		t ) poster=TRUE;;
		o ) outdir=`cd "$OPTARG"; pwd`;;
		h ) usage;;
		\? ) usage
		exit 1;;
		* ) echo $usage
		exit 1;;
	esac
done


if [ "$1" == "" ]; then
	usage
	exit 0
fi

if [ "$filename" == "" ]; then
	echo
	echo you MUST supply a file to encode!, use the -f parameter. i.e: -f mymovie.avi
	echo
	usage
	exit 1
fi
if [ "$bitrate" == "" ]; then
	echo
	echo you MUST specify a target bitrate!, use the -b parameter. i.e: -b 512
	echo
	usage
	exit 1
fi

if [ "$width" != "" ]; then
	rsize="-vf scale=$width:-3"
	rsizemsg="fit into $width pixels wide"
else
	rsize=""
	rsizemsg="Movie is not being resized."
fi

# Check if output directory exists
if [ -d "$outdir" ]; then
	echo "Target directory set to: $outdir"
	
else
	echo "Error: '$outdir' does not exist!!"
	echo "Can not continue, please make sure that the specified output directory exists. Exiting..."
	exit 1
fi

# Start the magic...

showMessage() {
	echo "MKMP4 : "$1""
}

initialize() {
	if [ -d "$filename" ]; then
		$filename = `cd $filename; pwd`
		showMessage "Output directory set to: $outdir."
		showMessage "Triggering the encoder with all media files in directory: $filename."
		for file in "$filename"*$fileext; do
			if [ -f "$file" ]; then
				showMessage "Will encode file: $file"
				startEncoders "$file"

			fi
		done
	elif [ -f "$filename" ]; then
		showMessage "Triggering the encoder with source media: $filename."
		startEncoders "$filename"
		
	else
		# input is no file and no directory ? WTF ? 
		echo "Something really weird has happened here: $filename is not valid, exiting..."
		exit 1
	fi
}

startEncoders() {
	firstPass "$1"
	if [ "$quality" == "TRUE" ]; then
		secondPass "$1"
	fi
	extractAudio "$1"
	encodeAAC "$1"
	mux "$1"
	if [ $poster == "TRUE" ]; then
		createThumbnail "$1"
	fi
	if [ $deltemp == "TRUE" ]; then
		cleanTemporaryFiles "$1"
	fi
}
firstPass() {
	local iFile="${1##*/}"	# remove directory and keep only file name.
	# First, lets get some basical information about this file, as FPS.
	MOVIE_FPS=`midentify "$1" | grep FPS | cut -d = -f 2`
	# Lets print some info to stdout.
	showMessage "Encoding: $1"
	showMessage "Resizing to: $rsizemsg."
	showMessage "Total Bitrate: $bitrate kbps."
	let "caudiobitrate = $audiobitrate / 1000"
	let "itemVideoBitrate = $bitrate - $caudiobitrate"
	showMessage "Video Bitrate: $itemVideoBitrate kbps."
	showMessage "Audio Bitrate: $caudiobitrate kbps."
	showMessage "Platform: $platform."
	# Lets start the encoding for the first pass.
	showMessage "Starting video encoding pass 1..."
	mencoder "$1" -o "$outdir/${iFile%%.*}_temp.264" -passlogfile "$outdir/${iFile%%.*}"_temp.log $rsize -ovc x264 -x264encopts bitrate=$itemVideoBitrate:frameref=8:bframes=3:b_adapt:b_pyramid:weight_b:partitions=all:8x8dct:me=umh:subq=6:trellis=2:brdo:threads=auto:pass=1:analyse=all -of rawvideo -nosound

}

secondPass() {
	local iFile="${1##*/}"	# remove directory and keep only file name.
	showMessage "Starting video encoding pass 2..."
	mencoder "$1" -o "$outdir/${iFile%%.*}_temp.264" -passlogfile "$outdir/${iFile%%.*}"_temp.log $rsize -ovc x264 -x264encopts bitrate=$itemVideoBitrate:frameref=8:bframes=3:b_adapt:b_pyramid:weight_b:partitions=all:8x8dct:me=umh:subq=6:trellis=2:brdo:threads=auto:pass=2:analyse=all -of rawvideo -nosound
}

extractAudio() {
	local iFile="${1##*/}"	# remove directory and keep only file name.
	showMessage "Extracting Audio..."
	mplayer "$1" -af resample=48000:0:2,volume=-5,channels=2,volnorm=1:0.25,format=s16le -ao pcm:file="$outdir/${iFile%.*}_temp.wav" -vc dummy -vo null
}

encodeAAC() {
	local iFile="${1##*/}"	# remove directory and keep only file name.
	if [ "$platform" == "Mac" ]; then
		enhAacPlusEnc "$outdir/${iFile%.*}_temp.wav" "$outdir/${iFile%.*}_temp.aac" $audiobitrate s
	else
		neroAacEnc -br 48000 -he -if $outdir/${iFile%.*}_temp.wav -of $outdir/${iFile%.*}_temp.mp4
	fi
}

mux() {
	local iFile="${1##*/}"	# remove directory and keep only file name.
	MP4Box -add "$outdir/${iFile%.*}_temp.264#video:fps=$MOVIE_FPS" "$outdir/${iFile%.*}.m4v"
	if [ "$platform" == "Mac" ]; then
		MP4Box -add "$outdir/${iFile%.*}_temp.aac" -sbr "$outdir/${iFile%.*}.m4v"
	else
		MP4Box -add "$outdir/${iFile%.*}_temp.mp4#audio" "$outdir/${iFile%.*}.m4v"
	fi
	name=$outdir/${iFile%.*}
	album="The Mac Video Archive"
	author="Apple Computer // massanti.com"
	comment="Professionally encoded by Diego Massanti"
	created="2007"
	MP4Box -inter 500 -itags album="$album":artist="$author":comment="$comment":created="$created":name="$name" -lang English "$outdir/${iFile%.*}".m4v
}

createThumbnail() {
	local iFile="${1##*/}"	# remove directory and keep only file name.
	mplayer "$1" -ss 10 -nosound $rsize -ssf lgb=1.0 -sws 7 -vo jpeg:outdir=$outdir -frames 1
	mv "$outdir/00000001.jpg" "$outdir/${iFile%.*}.jpg"
	mplayer "$1" -ss 10 -nosound -vf scale=150:-3 -ssf lgb=1.0 -sws 7 -vo jpeg:outdir=$outdir -frames 1
	mv "$outdir/00000001.jpg" "$outdir/${iFile%.*}_small.jpg"
}

cleanTemporaryFiles() {
	local iFile="${1##*/}"	# remove directory and keep only file name.
	showMessage "Removing temporary files..."
	rm "$outdir/${iFile%.*}"_temp*
}

initialize








