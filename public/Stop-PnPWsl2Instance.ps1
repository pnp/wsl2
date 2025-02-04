# Import required modules
using module ..\private\PnPWsl2Helpers.psm1
using module ..\private\ValidateWslLocalInstance.psm1

Set-StrictMode -Version 3
$ErrorActionPreference = "Stop"
<#
.SYNOPSIS
Stops a WSL2 instance.

.DESCRIPTION
The Stop-PnPWsl2Instance cmdlet stops a running WSL2 instance. The instance to stop is specified by the Instance parameter.

.PARAMETER Instance
Specifies the instance to stop. This parameter is mandatory and accepts only valid WSL2 instance names.

.EXAMPLE
Stop-PnPWsl2Instance -Instance "MyInstance"

This command stops the WSL2 instance named "MyInstance".

#>
function Stop-PnPWsl2Instance {
    [CmdletBinding(SupportsShouldProcess)]
    # Call ShouldProcess method to support ShouldProcess/ShouldContinue

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
        $config = Get-ModuleConfiguration
        $cmd = $config.Commands.'Terminate-WSLInstance' -f $Instance

        Invoke-Expression -Command $cmd

    }
}