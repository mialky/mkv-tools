# ----------------------------------------------------------------------------
# Separates audio & video files from MKV & compresses video files.
# (Use Audacity to compress audio & MKVToolNix to recombine)
# ----------------------------------------------------------------------------

# list entries (without extensions) as ("mkv_filename", "video_filetype", "audio_filetype");
# add single entries as '(,<entry>)':

$entries = (
	,
)



# validate input
$confirm = Read-Host ("Starting '" + $entries[0][0] + ".mkv', is this correct? ('y' to confirm)")
if (!($confirm -eq 'y')) {
	Write-Host "Remember: single entries as '(,<entry>)'"
	Return
}

# video compress quality settings; 18 (best) - 22 (worst):
$crf = "22"

Foreach ($item in $entries) {
	Write-Host ("Processing '" + $item[0] + ".mkv' ...")
	
	# extract tracks
	Powershell ("mkvextract tracks '" + $item[0] + ".mkv' 0:'" + $item[0] + $item[1] + "' 1:'" + $item[0] + $item[2] + "'")
	
	# delete old mkv
	Powershell ("rm '" + $item[0] + ".mkv'")
	
	# compress video & port into new mkv
	Powershell ("ffmpeg -loglevel warning -hide_banner -stats -i '" + $item[0] + $item[1] + "' -vcodec libx265 -crf " + $crf + " '" + $item[0] + ".mkv'")
	
	# delete raw video track
	Powershell  ("rm '" + $item[0] + $item[1] + "'")
}

Write-Host "Complete!"
