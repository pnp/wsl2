

# Import required modules
using module ..\private\PnPWsl2Helpers.psm1
using module ..\private\ValidateWslLocalInstance.psm1
using module ..\private\ValidateWslLocalCheckPoint.psm1
using module ..\private\PSColors.psm1

# Set strict mode to version 3
Set-StrictMode -Version 3
# Set the error action preference to stop
$ErrorActionPreference = "Stop"

<#
.SYNOPSIS
   Restores a PnP WSL2 instance from a checkpoint.

.DESCRIPTION
   The Restore-PnPWsl2Instance cmdlet restores a specified PnP WSL2 instance from a checkpoint.
   It requires the name of the instance and the checkpoint as mandatory parameters.
   The cmdlet validates the instance name and the checkpoint before attempting to restore.
   If the instance name or the checkpoint is invalid, it throws an error.
   If the -Force switch is not provided, it prompts for confirmation before restoring the instance.

.PARAMETER Instance
   The name of the PnP WSL2 instance to restore. This parameter is mandatory and does not accept pipeline input.
   The cmdlet validates the instance name using the ValidateWslLocalInstance function.

.PARAMETER CheckPoint
   The name of the checkpoint to restore from. This parameter is mandatory and is dynamically added if the Instance parameter is provided.
   The cmdlet validates the checkpoint using the ValidateWslLocalCheckPoint function.

.PARAMETER Force
   If this switch is provided, the cmdlet does not prompt for confirmation before restoring the instance.

.EXAMPLE
   # Restore a PnP WSL2 instance named "MyInstance" from a checkpoint named "MyCheckpoint"
   Restore-PnPWsl2Instance -Instance "MyInstance" -CheckPoint "MyCheckpoint"

.EXAMPLE
   # Restore a PnP WSL2 instance named "MyInstance" from a checkpoint named "MyCheckpoint" without prompting for confirmation
   Restore-PnPWsl2Instance -Instance "MyInstance" -CheckPoint "MyCheckpoint" -Force
#>
function Restore-PnPWsl2Instance {
    # Define the cmdlet binding
    [CmdletBinding()]
    Param(
        # Define the Instance parameter
        [Parameter(Mandatory = $true, Position = 0, ValueFromPipeline = $false)]
        [ValidateSet( [ValidateWslLocalInstance] )]
        [ArgumentCompleter({
                param($wordToComplete)
                [string[]] $validValues = [ValidateWslLocalInstance]::new().GetValidValues()
                $validValues -like "$wordToComplete*"
            })]
        $Instance,

        # Define the Force switch
        [Parameter(Mandatory = $false)]
        [switch]$Force
    )

    # Define dynamic parameters
    DynamicParam {
        if ($Instance) {
            # Define the CheckPoint parameter
            $parameterAttribute = [System.Management.Automation.ParameterAttribute]::new()
            $parameterAttribute.Mandatory = $true
            $parameterAttribute.Position = 1

            $checkPointsObj=[ValidateWslLocalCheckPoint]::new($Instance)
            $attb=$checkPointsObj.GetValidValues()

            $validateSetAttribute = [System.Management.Automation.ValidateSetAttribute]::new($attb)

            $attributes = [System.Collections.ObjectModel.Collection[System.Attribute]]::new()
            $attributes.Add($parameterAttribute)
            $attributes.Add($validateSetAttribute)

            $parameter = [System.Management.Automation.RuntimeDefinedParameter]::new('CheckPoint', [string], $attributes)

            $parameters = [System.Management.Automation.RuntimeDefinedParameterDictionary]::new()
            $parameters.Add('CheckPoint', $parameter)
            return $parameters
        }
    }

    # Define the Begin block
    Begin{
        # Send telemetry tracking
        Send-PnPWsl2TrackEventTelemetry -EventName $MyInvocation.MyCommand.Name
        $env:LogScope = ""
        if (-Not(Test-Wsl2Enabled)) {
            Write-Log "`bWSL2 is not enabled"
            return
        }
        $config = Get-ModuleConfiguration
    }

    # Define the Process block
    Process {
        $CheckPoint = $PSBoundParameters['CheckPoint']
        $msg = "`n[[brwhite Restore  [[green$Instance[/  SnapShot - [[cyan$CheckPoint[/ ?[/ [[[yellowy[//[[yellowN[/]"
        if (-Not $Force) {
            $out = Show-ConfirmPrompt -msg $msg -yesKey "y" -quitKey "n"
            if (-Not $out) {
                Write-Log "`n Exiting ..."
                $env:LogScope = ""
                return
            }

            Write-Log "`b`nRestoring ... [/" -NoNewLine
        }
        $checkPointPath = "$($config.PnPWsl2RootFolder)\instances\$Instance\checkpoints\$CheckPoint.vhdx"
        Write-Log "`b`b"
        Import-PnPWsl2Instance -InstanceFile  $checkPointPath -Instance $Instance
        Write-Log "`b`b"
        Write-Log "[[greenCheckPoint : $checkPointPath[/  applied ! `n"
        $env:LogScope = ""
    }
}