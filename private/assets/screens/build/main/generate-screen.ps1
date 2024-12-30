Set-Location $PSScriptRoot
. $PSScriptRoot\..\index.ps1

$screen= "$PSScriptRoot\splscr-main.ascii"
$screenRaw= "$PSScriptRoot\splscr-main.ascii_raw"
$screenColorMap= "$PSScriptRoot\splscr-main.ascii_map"

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