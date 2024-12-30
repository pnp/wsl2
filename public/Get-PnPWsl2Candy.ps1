# Import required modules
using module ..\private\PnPWsl2Helpers.psm1
using module ..\private\ValidateWslLocalInstance.psm1
using module ..\private\ValidateWslCandy.psm1

Set-StrictMode -Version 3
$ErrorActionPreference = "Stop"
<#
.SYNOPSIS
    This function retrieves a list of current available tools (Candy\scripts).

.DESCRIPTION
    The Get-PnPWsl2Candy retrieves a list of current available tools (Candy\scripts).

.PARAMETER IncludePath
    A switch parameter that determines whether to include the FullPath property in the output.
    If this parameter is provided, FullPath is included.

.EXAMPLE
    Get-PnPWsl2Candy

    This command retrieves a list of current available tools (Candy\scripts).
#>
function Get-PnPWsl2Candy {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $false)]
        [switch]$IncludePath
    )
    Begin{
        #telemetry tracking #cmdletName + includepath parm
        Send-PnPWsl2TrackEventTelemetry -EventName $MyInvocation.MyCommand.Name -CustomProperties @{CmdLetValue1=$IncludePath}
        $env:LogScope = ""
    }
    Process {
        $env:LogScope = ""
        if (-Not(Test-Wsl2Enabled)) {
            Write-Log "`bWSL2 is not enabled"
            return
        }
        [ValidateWslCandy]::new().GetValidValues()| Out-Null
        $scripts = @($env:PNPWSL2_Candy | ConvertFrom-Json)
        if ($IncludePath)
        {
            $scripts =$scripts|  Select-Object Name, Description, FullPath
        }
        else {
            $scripts = $scripts|  Select-Object Name, Description
        }


        $env:LogScope = ""
        return $scripts
    }
}