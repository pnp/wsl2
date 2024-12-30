using module ..\private\PnPWsl2Helpers.psm1
using module ..\private\ValidateWslLocalInstance.psm1
using module ..\private\PSColors.psm1

Set-StrictMode -Version 3
$ErrorActionPreference = "Stop"
$DebugPreference = "Continue"

<#
.SYNOPSIS
   Removes a PnP WSL2 instance.

.DESCRIPTION
   The Remove-PnPWsl2Instance cmdlet removes a specified PnP WSL2 instance.
   It requires the name of the instance as a mandatory parameter.
   The cmdlet validates the instance name before attempting to remove it.
   If the -Force switch is not provided, it prompts for confirmation before removing the instance.

.PARAMETER Instance
   The name of the PnP WSL2 instance to remove. This parameter is mandatory and accepts pipeline input.

.PARAMETER Force
   If this switch is provided, the cmdlet does not prompt for confirmation before removing the instance.

.EXAMPLE
   # Remove a PnP WSL2 instance named "MyInstance"
   Remove-PnPWsl2Instance -Instance "MyInstance"

.EXAMPLE
   # Remove a PnP WSL2 instance named "MyInstance" without prompting for confirmation
   Remove-PnPWsl2Instance -Instance "MyInstance" -Force
#>
function Remove-PnPWsl2Instance {
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType([System.String])]
    Param(
        [Parameter(Mandatory = $true, Position = 0, ValueFromPipeline = $true)]
        [ValidateScript({
           $Instance=$_

            # Get the valid instances
            $validInstances = [ValidateWslLocalInstance]::new().GetValidValues()
            if ($null -eq $validInstances)
            {
                throw "No instances available"
            }
            if ($Instance.GetType().Name -eq "String")
            {
                $validInstance =$Instance
            }
            else{
                $validInstance =$Instance.Name
            }
            # Check if the instance is valid
            if ($validInstances -contains $validInstance) {
                $true
            } else {
                throw "Invalid instance: $Instance. Valid instances are: $validInstances"
            }
        })]
        [ArgumentCompleter({
                param($wordToComplete)
                    [string[]] $validValues = [ValidateWslLocalInstance]::new().GetValidValues()
                    $validValues -like "$wordToComplete*"
            })]
        $Instance,
        [switch]$Force)
    Begin {
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
        if ($Instance.GetType().Name -ne "String")
        {
            $Instance =$Instance.Name
        }
        if (-Not $Force) {
            $msg = "`n[[brwhite Remove $Instance ?[/ [[[yellowy[//[[yellowN[/]"
            $out = Show-ConfirmPrompt -msg $msg -yesKey "y" -quitKey "n"
            if (-Not $out) {
                Write-Log "`n Exiting ..."
                $env:LogScope
                return
            }
        }

        if ( $ENV:PNPWSL2DontWipeRecursive -eq $false ) {
            Write-Log "`b`nRemoving ... [/" -NoNewLine
        }

        $dist = Get-WSl2Distributions -online $false  -instanceName $Instance
        if ($null -eq $dist) {
            Write-Log "[[red[Distribution $Instance not found."
            return
        }

        Invoke-Expression (($config.Commands.'Remove-WslInstance') -f $Instance) | Out-Null
        $instancesFolder = "$($config.PnPWsl2RootFolder)\instances"
        $instanceFolder = "$instancesFolder\$Instance"
        if (-Not(Test-Path -Path $instanceFolder)) {
            Write-Log "[[red[Error: $Instance folder doesn't exist.]"
        }
        else {

            if ( $ENV:PNPWSL2DontWipeRecursive -eq $false ) {
                # Remove-Item -Path $instanceFolder -Force -ErrorAction SilentlyContinue -Recurse
                Remove-Item -Path $instanceFolder -Force -Recurse
            }



        }


        if ( $ENV:PNPWSL2DontWipeRecursive -eq $false ) {
            Write-Log "`b[[green$Instance[/ Instance removed!`n"
        }
        $env:LogScope = ""
    }
}
