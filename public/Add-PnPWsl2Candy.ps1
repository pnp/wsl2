# Import required modules
using module ..\private\PnPWsl2Helpers.psm1
using module ..\private\ValidateWslLocalInstance.psm1
using module ..\private\ValidateWslCandy.psm1

Set-StrictMode -Version 3
$ErrorActionPreference = "Stop"


<#
.SYNOPSIS
    Installs a WSL PnPCandy\tool.

.DESCRIPTION
    The Add-PnPWsl2Candy function installs WSL tools (Candy) by executing the specified scripts.

.PARAMETER Instance
    Specifies the WSL Instance to install the pnpcandy on.
    This parameter is mandatory.

.PARAMETER Candy
    Specifies the Candy\tool to install.
    This parameter is mandatory.

.EXAMPLE
    Add-PnPWsl2Candy -Instance "Ubuntu-20.04" -Candy "PowerShell"

    Installs PowerShell on the specified WSL Instance .
#>
function Add-PnPWsl2Candy {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $true)]
        [ValidateSet( [ValidateWslLocalInstance] )]
                [ArgumentCompleter({
                param($wordToComplete)
                [string[]] $validValues = [ValidateWslLocalInstance]::new().GetValidValues()
                $validValues -like "$wordToComplete*"
            })]
        $Instance,
        [Parameter(Mandatory = $true)]
        [ValidateSet( [ValidateWslCandy] )]
        [ArgumentCompleter({
        param($wordToComplete)
                [string[]] $validValues = [ValidateWslCandy]::new().GetValidValues()
                $validValues -like "$wordToComplete*"
            })]
        $Candy
    )

    Begin{
        #telemetry tracking #cmdletName + Candy
        Send-PnPWsl2TrackEventTelemetry -EventName $MyInvocation.MyCommand.Name -CustomProperties @{CmdLetValue1=$Candy}
        $env:LogScope = ""
        if (-Not(Test-Wsl2Enabled)) {
            Write-Log "`bWSL2 is not enabled"
            return
        }
    }
    Process {
        Write-Log "`nInstalling WSL Candy ... 🍬"
        # kill pending processes
        Stop-PendingProcesses
        ## Get filename from Candy parameter
        $scripts = @($env:PNPWSL2_Candy | ConvertFrom-Json |  Where-Object { $_.Name -eq $Candy })
        if ($null -eq $scripts) {
            Write-Log "No scripts found for $Candy"
            return
        }
        else {
            if ($scripts[0].FullPath -eq "*") {
                $scripts = @($env:PNPWSL2_Candy | ConvertFrom-Json)
                $scripts = @($scripts | Where-Object { $_.Name -ne $Candy })
            }

            foreach ($script in $scripts) {
                $cmd = $script.FullPath
                Invoke-PnPWsl2Script -ScriptPath $cmd -Instance $Instance
            }

        }
        Write-Log " "
        Write-Log "WSL Candy install is done! 🍬"
        $env:LogScope = ""
    }
}