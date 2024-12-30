
using module ..\private\PnPWsl2Helpers.psm1
using module ..\private\ValidateWslLocalInstance.psm1
using module ..\private\PSColors.psm1

Set-StrictMode -Version 3
$ErrorActionPreference = "Stop"


<#
.SYNOPSIS
Exports a WSL2 instance to a file.

.DESCRIPTION
The `Export-PnPWsl2Instance` function exports a WSL2 instance to a file.
The type of the file can be either a tar file or a VHD file.

.PARAMETER Instance
The name of the WSL2 instance to export. This parameter is mandatory.

.PARAMETER Type
The type of the export file. It can be either "TarFile" or "VhdFile".
This parameter is mandatory.

.PARAMETER ExportPath
The path where the export file will be saved.
This parameter is mandatory.

.EXAMPLE
Export-PnPWsl2Instance -Instance "Ubuntu-20.04" -Type "TarFile" -ExportPath "/path/to/export"

This example exports the "Ubuntu-20.04" WSL2 instance to a tar file.

The export file will be saved in "/path/to/export".
#>
function Export-PnPWsl2Instance {
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
        [Parameter(Mandatory = $true, Position = 1)]
        [ValidateSet("TarFile", "VhdFile")]
        $Type,
        [Parameter(Mandatory = $true, Position = 2)]
        $ExportPath
    )

    Process {
        $env:LogScope = ""
        if (-Not(Test-Wsl2Enabled)) {
            Write-Log "`bWSL2 is not enabled"
            return
        }
        $config = Get-ModuleConfiguration
        ##test path
        if (-Not (Test-Path $ExportPath)) {
            Write-Log "`n[[red$ExportPath[/ does not exist."
            return
        }
        Write-Log "Exporting ... [/" -NoNewLine
        $exportFile= "$ExportPath\$($Instance)-$((Get-Date).ToString("yyyyMMddhhmm"))"
        if ($Type -eq "VhdFile") {
            $exportFile+= ".vhdx --vhdx"
        }
        else {
            $exportFile+= ".tar "
        }
        Invoke-Expression ($config.Commands.'Export-WslInstance' -f $Instance, $exportFile )
        Write-Log "[[green$Instance[/ Instance exported to $ExportPath !`n"
        $env:LogScope = ""
    }
}
