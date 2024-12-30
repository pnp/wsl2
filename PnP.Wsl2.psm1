# Importing required modules
using module ./private/PnPWsl2Helpers.psm1
using module ./private/PSScreens.psm1

Set-StrictMode -Version Latest
## Telemetry send module loaded + version

# get current module version loading pnp.wsl.psd1
# Import the .psd1 file
$moduleData = Import-PowerShellDataFile -Path $PSScriptRoot/PnP.Wsl2.psd1
# Get the module version
$env:PRODUCT_NAME = "PnP.Wsl2"
$env:PNPWSL2_VERSION = $moduleData.ModuleVersion
$env:PNPWSL2_APPI_ENDPOINT= $moduleData.PrivateData.Constants.AppInsightsIngestionEndpoint
$env:PNPWSL2_APPI_INSTRKEY =  $moduleData.PrivateData.Constants.AppInsightsInstrumentationKey
$env:PNPWSL2_TELEMETRY_INSTANCE = ([guid]::NewGuid().ToString("N"))
$env:PNPWSL2_TELEMETRY_ISON = $true

Send-PnPWsl2TrackEventTelemetry -EventName "Import-Module" 

# Get and private function definition files
$public = @(Get-ChildItem -Path "$PSScriptRoot\Public\*.ps1" -Exclude "*.Tests.*" -ErrorAction SilentlyContinue)
# Importing all functions
foreach ($import in $public) {
    try {
        Write-Verbose "Importing $($import.FullName)..."
        . $import.FullName
    }
    catch {
        Write-Error "Failed to import function $($import.FullName): $_"
    }
}
Initialize-ModuleConfiguration 
Export-ModuleMember -Function $public.BaseName
