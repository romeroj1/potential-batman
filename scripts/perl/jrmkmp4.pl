#!/usr/bin/perl

@file_list = <*.flv *.mpg *.avi *.vob *.AVI *.mov *MOV>;
$extension = ".mp4";

foreach $file (@file_list)
{
	@filename = split(/\./, $file);
	$baseName = @filename[0];
	print @filename[0] . "\n";
	print "Converting ";
	$source = "$file";
	$destination = $baseName . $extension;
	print "Ready?\n";
	#$asdf = <>; This line is an enter key stroke to execute the next line
	print `HandBrakeCLI -i $source -o $destination --preset="Universal"`;
}
