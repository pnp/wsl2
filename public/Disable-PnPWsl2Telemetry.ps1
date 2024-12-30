Set-StrictMode -Version 3
$ErrorActionPreference = "Stop"
<#
.SYNOPSIS
Disables the telemetry for the PnP.WSL2 module.

.DESCRIPTION
The Disable-PnPWsl2Telemetry function is used to disable telemetry for PnP.WSL2 .

.EXAMPLE
Disable-PnPWsl2Telemetry

#>
function Disable-PnPWsl2Telemetry {
    begin{
        Send-PnPWsl2TrackEventTelemetry -EventName $MyInvocation.MyCommand.Name
        $env:LogScope = ""
    }
    Process {
         $env:PNPWSL2_DISABLETELEMETRY = $true
         $setting="OFF"
         Write-Log "`bPnP.WSL2 Telemetry is $setting"
    }
}