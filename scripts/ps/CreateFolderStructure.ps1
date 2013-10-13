#Creates 60 folders, making sure the folder name has 2 digits
 $path="c:\temp\xx\ME"
 0..60 | %{ $p="{0:d2}" -f $_ ; md $path$p }