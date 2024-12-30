Set-Location $PSScriptRoot
. $PSScriptRoot\..\index.ps1

$screen= "$PSScriptRoot\splscr-example.ascii"
$screenRaw= "$PSScriptRoot\splscr-example.ascii_raw"
$screenColorMap= "$PSScriptRoot\splscr-example.ascii_map"

Clear-Host
"#######################################################################################"
"[CaptureColorsMap]#####################################################################`n"
CaptureColorsMap -screen $screen
"`n[Clean Screen]#########################################################################"
RemoveColors -screenFilePath $screen
"`n[Final Raw Screen]#####################################################################"
$scr= ApplyColorsMap -screen $screenRaw -screenColorMap $screenColorMap

"`n[Final Color Screen]###############################################################"
ShowScreen -screen $scr