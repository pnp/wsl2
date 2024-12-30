Set-Location $PSScriptRoot
. $PSScriptRoot\..\index.ps1

$screen= "$PSScriptRoot\splscr-small.ascii"
$screenRaw= "$PSScriptRoot\splscr-small.ascii_raw"
$screenColorMap= "$PSScriptRoot\splscr-small.ascii_map"

Clear-Host
"#######################################################################################"
"[CaptureColorsMap]#####################################################################`n"
CaptureColorsMap -screen $screen
"`n[Clean Screen]#########################################################################"
RemoveColors -screenFilePath $screen
"`n[Final Raw Screen]#####################################################################"
$scr= ApplyColorsMap -screen $screenRaw -screenColorMap $screenColorMap
$scr
"`n[Final Color Screen]###############################################################"
ShowScreen -screen $scr