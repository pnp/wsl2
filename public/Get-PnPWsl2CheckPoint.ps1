using module ..\private\PnPWsl2Helpers.psm1
using module ..\private\ValidateWslLocalInstance.psm1
using module ..\private\PSColors.psm1

Set-StrictMode -Version 3
$ErrorActionPreference = "Stop"
<#
.SYNOPSIS
Retrieves a list of checkpoints of a WSL2 instance.

.DESCRIPTION
The Get-PnPWsl2CheckPoint function retrieves the checkpoints of a specified WSL2 instance.

.PARAMETER Instance
Specifies the WSL2 instance to get the checkpoints from.
This parameter is mandatory.

.EXAMPLE
Get-PnPWsl2CheckPoint -Instance "Ubuntu-20.04"

This command retrieves a list of checkpoints of the "Ubuntu-20.04" WSL2 instance.
#>

function Get-PnPWsl2CheckPoint {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $true, Position = 0, ValueFromPipeline = $true)]
        [ValidateSet( [ValidateWslLocalInstance] )]
        [ArgumentCompleter({
        param($wordToComplete)
                [string[]] $validValues = [ValidateWslLocalInstance]::new().GetValidValues()
                $validValues -like "$wordToComplete*"
            })]
        $Instance
    )
    Begin{
        #telemetry tracking #cmdletName
        Send-PnPWsl2TrackEventTelemetry -EventName $MyInvocation.MyCommand.Name
        $env:LogScope = ""
        if (-Not(Test-Wsl2Enabled)) {
            Write-Log "`bWSL2 is not enabled"
            return
        }
    }
    Process {
        $checkPointsObj=[ValidateWslLocalCheckPoint]::new($Instance)
        $checkPointsObj.GetAllValues()
        $env:LogScope = ""
    }
}
