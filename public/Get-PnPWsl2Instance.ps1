Set-StrictMode -Version 3
$ErrorActionPreference = "Stop"
<#
.SYNOPSIS
    Retrieves the instances of WSL2 distributions.

.DESCRIPTION
    This function retrieves the instances of WSL2 distributions.


.EXAMPLE
    Get-PnPWsl2Instance
    Retrieves the local WSL2 instances distributions.

#>
function Get-PnPWsl2Instance {
    Begin {
        #telemetry tracking #cmdletName
        Send-PnPWsl2TrackEventTelemetry -EventName $MyInvocation.MyCommand.Name
        $env:LogScope = ""
        $output = $null
    }
    Process {

        # Call the Get-WSl2Distributions cmdlet with the specified online parameter
        if (Test-Wsl2Enabled) {
            $output= (Get-WSl2Distributions -online $false)
        }
        else {
            Write-Log "`bWSL2 is not enabled"
        }
        $env:LogScope = ""
        $output
    }
}
