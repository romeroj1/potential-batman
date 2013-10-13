$ffmpeg="F:\Software\windows\VideoTools\ffmpeg-20130607-git-f97e28e-win64-static\bin\ffmpeg.exe"
$filelist=ls "F:\Public\videos\computer\VTC Red Hat Certified System Administrator RHCSE\*" -Include *.mov -Recurse
$destpath="F:\Public\videos\computer\VTC Red Hat Certified System Administrator RHCSE\Output\"
$oldpath="F:\Public\videos\computer\VTC Red Hat Certified System Administrator RHCSE\"
$newext=".mp4"
$arg1='-i'
$arg2='-ar 22050'

foreach ($file in $filelist)
{
	#Convert each file to .mp4
	$oldname=$file.Name
	$newname=$destpath+$file.BaseName+$newext
	$arguments = '-i ' + '"'+$file.FullName +'"' +' -ar 22050 ' + '"' + $newname+ '"'
	Write-Host "Start Convertion for " $oldname
	#Write-Host $ffmpeg $arg1 $oldpath$oldname $arg2 $destpath$newname
	#& $ffmpeg  $arg1 $oldpath$oldname $arg2 $destpath$newname
	Invoke-Expression "$ffmpeg $arguments" 
	#Write-Host $file.name
}
