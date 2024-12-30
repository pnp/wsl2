using module ..\private\PnPWsl2Helpers.psm1
using module ..\private\ValidateWslOnlineDistribution.psm1

Set-StrictMode -Version 3
$ErrorActionPreference = "Stop"

<#
.SYNOPSIS
Retrieves the WSL2 distributions.

.DESCRIPTION
This function retrieves the WSL2 distributions based on the specified parameters.

.PARAMETER online
Specifies whether to retrieve online distributions.

.PARAMETER instanceName
Specifies the name of the WSL2 instance.

.EXAMPLE
Get-PnPWsl2Distribution
Retrieves all online WSL2 distributions.

.EXAMPLE
Get-PnPWsl2Distribution -instanceName "Ubuntu-20.04"
Retrieves the WSL2 distribution with the specified instance name.
#>
function Get-PnPWsl2Distribution {

    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $false)]
        [string]$instanceName
    )
    Begin {
        #telemetry tracking #cmdletName
        Send-PnPWsl2TrackEventTelemetry -EventName $MyInvocation.MyCommand.Name
        $env:LogScope = ""
    }
    Process {
        if (Test-Wsl2Enabled) {
            $outDist = Get-WSl2Distributions -online $true -instanceName $instanceName
            $outDist
        }
        else {
            Write-Log "`bWSL2 is not enabled"
        }

        $env:LogScope = ""
    }
}
