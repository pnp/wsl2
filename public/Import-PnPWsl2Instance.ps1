using module ..\private\PnPWsl2Helpers.psm1
using module ..\private\ValidateWslLocalInstanceWithNewEntry.psm1
using module ..\private\PSColors.psm1
Set-StrictMode -Version 3
$ErrorActionPreference = "Stop"

<#
.SYNOPSIS
Imports a WSL2 Instance from a tar file (zip file).

.DESCRIPTION
The Import-PnPWsl2Instance function imports a WSL2 Instance from a tar file (zip file) and creates a new Instance with the specified name.

.PARAMETER InstanceFile
The path to the Instance file
File can be either a tar file or a VHD file.

.PARAMETER Instance
The name of the new Instance.

.EXAMPLE
Import-PnPWsl2Instance -InstanceFile "C:\path\to\Instance.tar" -Instance "MyInstance"
Imports the WSL2 Instance from the specified tar file (zip file) and creates a new Instance named "MyInstance".
#>

function Import-PnPWsl2Instance {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $true)]
        $InstanceFile,
        [Parameter(Mandatory = $true, Position = 1, ValueFromPipeline = $true)]
        [ValidateSet( [ValidateWslLocalInstanceWithNewEntry] )]
        [ArgumentCompleter({
                param($wordToComplete)
                [string[]] $validValues = [ValidateWslLocalInstanceWithNewEntry]::new().GetValidValues()
                $validValues -like "$wordToComplete*"
            })]
        $Instance
    )
    Begin {
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
        ##test path
        if (-Not (Test-Path $InstanceFile)) {
            Write-Log "`n[[red$InstanceFile[/ does not exist." # Log an error message if the Instance tar file (zip file) does not exist
            return
        }
        Write-Log "`n Importing ... [/" -NoNewLine
        $instancesFolder = $config.PnPWsl2RootFolder + "\instances"

        $importFile = $InstanceFile
        if ($Instance -ne '<NEW INSTANCE>') {
            Remove-PnPWsl2Instance -Instance $Instance -Force
            $importInstance = $Instance.ToString()
        }
        else {
            Write-Log "`n  New instance requested.`n  Creating a new one based on the export file "
            do {
                Write-Log " Type new instance name: [[yellow " -NoNewLine
                Write-Log "`b" -NoNewLine
                $newInstance = Read-Host
                Write-Log "[/  Checking if the instance [[[yellow$newInstance[/] name already exists "
                $allinstances = Get-PnPWsl2Instance
                if ($null -ne $allinstances) {
                    $inst=$allinstances| Where-Object { $_.Name -eq $newInstance } | Select-Object -ExpandProperty Name
                    if ($null -ne $inst) {
                        Write-Log "  [[red Instance already exist. Please choose another name.[/"
                    }
                    else {
                        Write-Log "  [[green Instance doesn't exist ! Import can continue . [/ `n"
                    }
                }else {
                    $inst= $null
                    Write-Log "  [[green Instance doesn't exist ! Import can continue . [/ `n"
                }
            }
            while ($null -ne $inst)
            $importInstance = $newInstance

        }

        New-Item -Path "$instancesFolder\$importInstance" -ItemType Directory -Force | Out-Null
        $cmd = $config.Commands.'Import-WslInstance'
        Invoke-Expression ( $cmd -f $importInstance , "$instancesFolder\$importInstance", $importFile )

        Write-Log "[[green$importInstance[/ Instance imported!`n" # Log a success message after importing the Instance
        $env:LogScope = ""
    }
}
