$path='F:\Public\videos\computer\VTC Red Hat Certified System Administrator RHCSE\*'

Function renameFiles 
{ 
  # Search for the files set in the filter (*.mov in this case)
  $files = ls $path -include *.mov -Recurse
  # Set default value for addition to file name 
  $i = 1
  Foreach ($file In $files) 
  { 
      # Check if a file exists 
      If ($file) 
      { 
        # Split the name and rename it to the parent folder 
        $split = $file.name.split("_")
		$newfn = $split[1]
        $replace = $split[0] -Replace $split[0],("{0:D2}" -f $i + "_" + $newfn) 
 
        # Trim spaces and rename the file 
        $image_string = $file.fullname.ToString().Trim() 
        "$file.name renamed to $replace" 
        Rename-Item "$image_string" "$replace" 
        $i++
      } 
    }
}
renamefiles