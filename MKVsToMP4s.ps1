# ----------------------------------------------------------------------------
# Converts (switches containers from) MKVs to MP4s.
# ----------------------------------------------------------------------------

# list entries (without extensions):

$entries = (,"Film1")



# validate input
$confirm = Read-Host ("Starting '" + $entries[0] + ".mkv', is this correct? ('y' to confirm)")
if (!($confirm -eq 'y')) {
	Write-Host "Remember: single entries as ',<entry>'"
	Return
}

Foreach ($item in $entries) {
	Write-Host ("Processing '" + $item + ".mkv' ...")
	Powershell ("ffmpeg -loglevel warning -hide_banner -stats -i '" + $item + ".mkv' -codec copy '" + $item + ".mp4'")
	
	# delete mkv
	Powershell  ("rm '" + $item + ".mkv'")
}

Write-Host "Complete!"
