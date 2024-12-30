Set-StrictMode -Version 3
$ErrorActionPreference = "Stop"
<#
.SYNOPSIS
Enables the telemetry for the PnP.WSL2 module.

.DESCRIPTION
The Enable-PnPWsl2Telemetry function is used to enable telemetry for PnP.WSL2 .

.EXAMPLE
Enable-PnPWsl2Telemetry

#>
function Enable-PnPWsl2Telemetry {
  begin{
        $env:PNPWSL2_DISABLETELEMETRY = $true
        #telemetry tracking #cmdletName
        Send-PnPWsl2TrackEventTelemetry -EventName $MyInvocation.MyCommand.Name
        $env:LogScope = ""
    }
    Process {
        $env:PNPWSL2_DISABLETELEMETRY = $false
        $setting="ON"
        Write-Log "`bPnP.WSL2 Telemetry is $setting"
    }
}