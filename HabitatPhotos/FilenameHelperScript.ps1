# With a directory of photos named as follows...
# YEAR_Region_SiteId_Stn_photoNum.jpg (2014_FK_00408_S1_1.jpg)
# ...this script will create dir for each siteid_stn and move all photos to correct dir.  
# Then re-number all the photos in each dir starting with 1

#  Set the directory to phots
$dir = 'path\to\photos\'

#  create epmpty array
$a = @()

#  loop through directory and add the site name to the array and create directory of site
#  if does not exists
gci $dir | % {
	$s = $_.Name.substring(8,8)
	if( -not ($a -contains $s)) {
		$a += $s
	}

	$path = $dir + $s
	if( -not (Test-Path $path)) {
		new-item $path -itemtype directory
	}
	
}


#  loop through site array and mvoe all pictures to correct directory
foreach ($site in $a) {
	
	
	Get-ChildItem $dir |
	Where-Object {$_.Name -match $site} |
	Move-item -Force -Destination {
		"$dir\$site"
	}
}


#  Set directories to loop through
$dirs = dir $dir -Recurse | Where { $_.psIsContainer -eq $true }

  Foreach ($dir In $dirs) 
  { 
    # Set default value for addition to file name 
    $i = 1 

    # Search for the files set in the filter (*.jpg in this case)
    $files = Get-ChildItem -Path $dir.fullname -Recurse
 
    Foreach ($file In $files) 
    { 
      # Check if a file exists 
      If ($file) 
      { 
	$fname = $file.Name.substring(0,16)
	$split = $file.name.split()
        $replace  = $split[0] -Replace $split[0],($fname + "_" + $i + ".jpg") 
 
        # Trim spaces and rename the file 
        $image_string = $file.fullname.ToString() 
        
        Rename-Item "$image_String" "$replace" 
        $i++ 
      } 
    } 
  } 
