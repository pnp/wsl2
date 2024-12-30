# Import required modules
using module ..\private\PnPWsl2Helpers.psm1
using module ..\private\ValidateWslLocalInstance.psm1

Set-StrictMode -Version 3
$ErrorActionPreference = "Stop"
<#
.SYNOPSIS
    Invokes a Bash script in a WSL 2 Instance.

.DESCRIPTION
    The Invoke-PnPWsl2Script function is used to execute a Bash script in a WSL 2 Instance.
    It takes the script base name and the target WSL 2 Instance as mandatory parameters.

.PARAMETER ScriptPath
    The Bash script path to be executed.

.PARAMETER Instance
    The target WSL 2 Instance where the script will be executed.
    Use the ValidateWslLocalInstance argument completer to provide valid Instance names.

.EXAMPLE
    Invoke-PnPWsl2Script -scriptBaseName "MyScript.sh" -Instance "Ubuntu-20.04"

    This example invokes the Bash script named "MyScript.sh" in the "Ubuntu-20.04" WSL 2 Instance.
#>
function Invoke-PnPWsl2Script {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $true)]
        $ScriptPath, # The Bash script path to be executed.
        [Parameter(Mandatory = $true)]
        [ValidateSet([ValidateWslLocalInstance])]
        [ArgumentCompleter({
        param($wordToComplete)
            [string[]] $validValues = [ValidateWslLocalInstance]::new().GetValidValues()
            $validValues -like "$wordToComplete*"
        })]
        $Instance # The target WSL 2 Instance where the script will be executed.
    )
    Begin{
        #telemetry tracking #cmdletName
        Send-PnPWsl2TrackEventTelemetry -EventName $MyInvocation.MyCommand.Name
        $env:LogScope = ""
    }
    Process {
        if (-Not(Test-Wsl2Enabled)) {
            Write-Log "`bWSL2 is not enabled"
            return
        }
        $config = Get-ModuleConfiguration
        $cmdFile = $scriptPath # Path to the script file
        $cmdFileWsl =  $cmdFile.Replace("\","/").Replace("//","/") # Replace backslashes with forward slashes in the file path
        $cmd = $config.Commands.'Get-WSlPath' -f $Instance, $cmdFileWsl # Generate the command to get the WSL path of the script file
        $cmdFileExecute = Invoke-Expression -Command $cmd # Execute the command to get the WSL path of the script file
        $cmd = $config.Commands.'Execute-WSlBashFile' -f $Instance, $cmdFileExecute   # Generate the command to execute the script file in WSL
        Invoke-Expression -Command $cmd # Execute the command to execute the script file in WSL
    }
}