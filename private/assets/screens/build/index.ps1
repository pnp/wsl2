using module ..\..\..\PSColors.psm1
function CaptureColorsMap($screen) {

    [PsColors]::CaptureColorsMap($screen, $true)
}

function RemoveColors($screenFilePath) {
    $screen = Get-Content -Path $screenFilePath -Raw
    [PsColors]::RemoveColors($screen, $true, $screenFilePath)
}

function ApplyColorsMap( $screen, $screenColorMap) {
    [PsColors]::ApplyColorsMap($screen, $screenColorMap,$true)
}

function ShowScreen($screen) {
    [PsColors]::ApplyColors($screen)
}