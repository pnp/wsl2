Set-StrictMode -Version 3
$ErrorActionPreference = "Stop"
<#
.SYNOPSIS
Stops the WSL2 service.

.DESCRIPTION
The Stop-PnPWsl2 cmdlet stops the WSL2 service if it is currently running.

.PARAMETER None
This cmdlet does not accept any parameters.

.EXAMPLE
Stop-PnPWsl2

This command stops the WSL2 service.

#>
function Stop-PnPWsl2 {
    [CmdletBinding()]
    # Call ShouldProcess method to support ShouldProcess/ShouldContinue

    Param()
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
        $cmd = $config.Commands.'Stop-PnPWsl2'
        Invoke-Expression -Command $cmd
    }
}