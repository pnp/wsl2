Set-StrictMode -Version 3
$ErrorActionPreference = "Stop"

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
         Write-Log "[[greenWsl is stopped !`n"
        Invoke-Expression -Command $cmd
    }
}