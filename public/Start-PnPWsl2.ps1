# Import required modules
using module ..\private\PnPWsl2Helpers.psm1
using module ..\private\ValidateWslLocalInstance.psm1
Set-StrictMode -Version 3
$ErrorActionPreference = "Stop"

<#
.SYNOPSIS
    Start a WSL instance

.DESCRIPTION
    The Start-PnPWsl2 function starts a WSL instance.

.PARAMETER Instance
    Specifies the WSL Instance to start.
    This parameter is mandatory.


.EXAMPLE
    Start-PnPWsl2 -Instance "Ubuntu-20.04"

    Starts the specified WSL Instance.


#>
function Start-PnPWsl2 {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $true)]
        [ValidateSet( [ValidateWslLocalInstance] )]
                [ArgumentCompleter({
                param($wordToComplete)
                [string[]] $validValues = [ValidateWslLocalInstance]::new().GetValidValues()
                $validValues -like "$wordToComplete*"
            })]
        $Instance
    )
    # Call ShouldProcess method to support ShouldProcess/ShouldContinue
    begin{
        #telemetry tracking #cmdletName
        Send-PnPWsl2TrackEventTelemetry -EventName $MyInvocation.MyCommand.Name
        $env:LogScope = ""
        if (-Not(Test-Wsl2Enabled)) {
            Write-Log "`bWSL2 is not enabled"
            return
        }
    }
    Process {
        # Existing code inside the function
        $config = Get-ModuleConfiguration
        $cmd = $config.Commands.'Start-PnPWsl2'
        Write-Log "[[green Starting $Instance !`n"
        Invoke-Expression -Command $cmd
    }
}