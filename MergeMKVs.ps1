# ----------------------------------------------------------------------------
# Merges/appends MKV files seamlessly.
# ----------------------------------------------------------------------------

# list entries (without extensions):

$entries = (
	,("Clip1","Clip2")
)



# validate input
$confirm = Read-Host ("Starting '" + $entries[0][0] + ".mkv', is this correct? ('y' to confirm)")
if (!($confirm -eq 'y')) {
	Write-Host "Remember: single entries as '(,<entry>)'"
	Return
}

Foreach ($item in $entries) {
	Write-Host ("Processing '" + $item[0] + ".mkv' ...")
	
	# write merge-conf (must be UTF-8)
	$str = ""
	Foreach ($file in $item) {
		$str += "file './$file.mkv'`n"
	}
	[System.IO.File]::WriteAllLines(($PSScriptRoot + "/merge.txt"), $str.Trim(), (New-Object System.Text.UTF8Encoding $False))
	
	# merge files
	Powershell ("ffmpeg -loglevel warning -hide_banner -stats -f concat -safe 0 -i merge.txt -c copy '" + $item[0] + "_merged.mkv'")
	
	# remove source files
	rm merge.txt
	#rm ($item[0] + ".mkv")
	#rm ($item[1] + ".mkv")
}

Write-Host "Complete!"
