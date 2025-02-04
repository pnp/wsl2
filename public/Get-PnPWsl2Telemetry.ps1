Set-StrictMode -Version 3
$ErrorActionPreference = "Stop"

<#
.SYNOPSIS
    This function retrieves the status of the PnP.WSL2 telemetry.

.DESCRIPTION
    The Get-PnPWsl2Telemetry function checks the environment and retrieves the status of the PnP.WSL2 telemetry.

.PARAMETER None
    This function does not take any parameters.

.EXAMPLE
    Get-PnPWsl2Telemetry

    This command will retrieve the status of the PnP.WSL2 telemetry

#>
function Get-PnPWsl2Telemetry {
   begin{
        #telemetry tracking #cmdletName
        Send-PnPWsl2TrackEventTelemetry -EventName $MyInvocation.MyCommand.Name
        $env:LogScope = ""
        $Setting = $env:PNPWSL2_DISABLETELEMETRY -eq $true ? "OFF" : "ON"
        $env:LogScope = ""
   }
   Process {

       Write-Log "`bPnP.WSL2 Telemetry is $($Setting)"
   }
}