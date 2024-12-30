using module ..\private\PnPWsl2Helpers.psm1
using module ..\private\ValidateWslLocalInstance.psm1
using module ..\private\PSColors.psm1

Set-StrictMode -Version 3
$ErrorActionPreference = "Stop"



<#
.SYNOPSIS
    Copies a WSL 2 Instance to a new Instance.

.DESCRIPTION
    This function allows you to copy an existing WSL 2 Instance to a new Instance with a specified name.

.PARAMETER Instance
    Specifies the name of the WSL 2 Instance to be copied.
    This parameter is mandatory.

.PARAMETER NewInstanceName
    Specifies the name of the new Instance to be created.
    This parameter is mandatory.

.EXAMPLE
    Copy-PnPWsl2Instance -Instance "Ubuntu-20.04" -NewInstanceName "MyUbuntu"

    This example copies the "Ubuntu-20.04" Instance to a new instance named "MyUbuntu".
#>
function Copy-PnPWsl2Instance {
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
        $NewInstanceName,
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
        $msg = "`n[[brwhite Copy [[green$Instance[/ to [[cyan$NewInstanceName[/ ?[/ [[[yellowy[//[[yellowN[/]"
        if (-Not $Force) {
            $out = Show-ConfirmPrompt -msg $msg -yesKey "y" -quitKey "n"
            if (-Not $out) {
                Write-Log "`n Exiting ..."
                $env:LogScope = ""
                return
            }

            Write-Log "`b`nCopying ... [/" -NoNewLine
        }
        $instancesFolder = $config.PnPWsl2RootFolder + "\instances"
        $imagesFolder = $config.WslTempFolder
        New-Item -Path "$instancesFolder\$NewInstanceName" -ItemType Directory -Force | Out-Null

        $exportFile = "$imagesFolder\$($NewInstanceName)_$($Instance)-$((Get-Date).ToString("yyyyMMddhhmm")).tar"
        Write-Log "`b`b"
        Invoke-Expression ($config.Commands.'Export-WslInstance' -f $Instance, $exportFile )
        #Import the WSL image to the specified images folder
        Write-Log "`b`b"
        Invoke-Expression ($config.Commands.'Import-WslInstance' -f $NewInstanceName , "$instancesFolder\$NewInstanceName", $exportFile )
        Write-Log "[[green$NewInstanceName[/ Instance copied!`n"
        ## delete the export file
        Remove-Item -Path $exportFile -Force -ErrorAction SilentlyContinue
        $env:LogScope = ""
    }
}
