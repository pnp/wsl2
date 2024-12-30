using module ..\private\PnPWsl2Helpers.psm1
using module ..\private\ValidateWslLocalInstance.psm1
using module ..\private\PSColors.psm1

Set-StrictMode -Version 3
$ErrorActionPreference = "Stop"
<#
.SYNOPSIS
Creates a new checkpoint of a WSL2 instance.

.DESCRIPTION
The CheckPoint-PnPWsl2Instance function creates a new checkpoint of a specified WSL2 instance.

.PARAMETER Instance
Specifies the WSL2 instance to checkpoint.
This parameter is mandatory.


.PARAMETER CheckpointName
Specifies the name of the checkpoint.
This parameter is mandatory.

.PARAMETER Force
If this switch is provided, it will not prompt for confirmation before creating the checkpoint.

.EXAMPLE
CheckPoint-PnPWsl2Instance -Instance "Ubuntu-20.04" -CheckpointName "MyCheckpoint"

This command creates a new checkpoint of the "Ubuntu-20.04" WSL2 instance with the name "MyCheckpoint".
Checkpoints (vhdx) exist within the PnPWsl2/instance location under the "checkpoints" folder.

#>
function CheckPoint-PnPWsl2Instance {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $true, Position = 0, ValueFromPipeline = $true)]
        [ValidateSet( [ValidateWslLocalInstance] )]
        [ArgumentCompleter({
        param($wordToComplete)
                [string[]] $validValues = [ValidateWslLocalInstance]::new().GetValidValues()
                $validValues -like "$wordToComplete*"
            })]
        $Instance,
        [Parameter(Mandatory = $true)]
        $CheckpointName,
        [Parameter(Mandatory = $false)]
        [switch]$Force
    )
    Begin{
        #telemetry tracking #cmdletName
        Send-PnPWsl2TrackEventTelemetry -EventName $MyInvocation.MyCommand.Name
        $env:LogScope = ""
        if (-Not(Test-Wsl2Enabled)) {
            Write-Log "`bWSL2 is not enabled"
            return
        }
        $config = Get-ModuleConfiguration
    }
    Process {
        $msg = "`n[[brwhite Create  [[green$Instance[/  checkpoint - [[cyan$CheckpointName[/ ?[/ [[[yellowy[//[[yellowN[/]"
        if (-Not $Force) {
            $out = Show-ConfirmPrompt -msg $msg -yesKey "y" -quitKey "n"
            if (-Not $out) {
                Write-Log "`n Exiting ..."
                $env:LogScope = ""
                return
            }

            Write-Log "`b`nCheckpointing ... [/" -NoNewLine
        }
        $instancesFolder = $config.PnPWsl2RootFolder + "\instances"
        New-Item -Path "$instancesFolder\$Instance\checkpoints" -ItemType Directory -Force | Out-Null

        $exportFile = "$instancesFolder\$Instance\checkpoints\$CheckpointName-$((Get-Date).ToString("yyyyMMddhhmm"))_snap.vhdx"
        Write-Log "`b`b"
        Invoke-Expression ($config.Commands.'Export-WslInstance' -f $Instance, $exportFile )
        #Import the WSL image to the specified images folder
        Write-Log "`b`b"
        Write-Log "[[green$CheckpointName : $exportFile[/  created ! `n"
        $env:LogScope = ""
    }
}
