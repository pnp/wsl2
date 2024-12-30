using module ..\private\PnPWsl2Helpers.psm1
using module ..\private\PsColors.psm1
using module ..\private\PsScreens.psm1

Set-StrictMode -Version 3
$ErrorActionPreference = "Stop"

<#
.SYNOPSIS
    Retrieves the configuration settings for PnPWsl2.

.DESCRIPTION
    The Get-PnPWsl2Configuration function retrieves the configuration settings for PnPWsl2.
    It displays basic information about the configuration, such as the PnPWsl2 root folder, WSL tools folder, and WSL images root folder.
    If the -detailed switch parameter is specified, it also displays the replace parameters and used internal WSL functions.

.PARAMETER details
    Specifies whether to display detailed information about the configuration.
    If this switch parameter is specified, the replace parameters and WSL functions will be displayed.

.EXAMPLE
    Get-PnPWsl2Configuration
    Retrieves and displays the basic configuration information for PnPWsl2.

.EXAMPLE
    Get-PnPWsl2Configuration -details
    Retrieves and displays detailed configuration information for PnPWsl2, including replace parameters and WSL functions.

#>
function Get-PnPWsl2Configuration {
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    Param(
        [switch]
        $details
    )
    begin{
        #telemetry tracking #cmdletName
        Send-PnPWsl2TrackEventTelemetry -EventName $MyInvocation.MyCommand.Name
        $env:LogScope = "" # Set the LogScope environment variable to an empty string
        $config = Get-ModuleConfiguration # Get the module configuration
        if ($null -eq $config) { # If the configuration is null
            Write-Log "The module configuration ($ENV:PNPWSL2_CONFIG_FILE) is not set." # Write a log message indicating that the configuration is not set
            return $null # Return null
        }

    }
    Process {

        $basicInfo = @"
[[green`nPNP.WSL2.CONFIGURATION
---------------------------------------------------------[/
[[whiteWslActiveDistribution:`t[[blue$($config.WslActiveDistribution)
[[whitePnPWsl2RootFolder:`t[[blue$($config.PnPWsl2RootFolder)
"@
        $out = ([PsColors]::ApplyColors($basicInfo)) # Apply colors to the basic information
        Write-Log $out # Write the colored basic information to the log

        if ($details) { # If the detailed switch parameter is specified
              ## removed replace params by inputs on prompt
            # $replaceParams = @{} # Create an empty hashtable for replace parameters
            # foreach ($property in ($config.ReplaceParams.PSObject.Properties | Sort-Object -Property Name)) { # Loop through each property in the ReplaceParams object
            #     $replaceParams[$property.Name] = $property.Value # Add the property name and value to the replaceParams hashtable
            # }

            $wslFunctions = @{} # Create an empty hashtable for WSL functions
            $coll= ($config.Commands.PSObject.Properties | Sort-Object -Property Name)
            foreach ($property in $coll) { # Loop through each property in the Commands object
                $wslFunctions[$property.Name] = $property.Value # Add the property name and value to the wslFunctions hashtable
            }

            $out = ([PsColors]::ApplyColors("[[green---------------------------------------------------------[/")) # Apply colors to a separator line
            Write-Log $out # Write the colored separator line to the log

            ## removed replace params by inputs on prompt
            # $replaceParams # Output the replaceParams hashtable
            $wslFunctions # Output the wslFunctions hashtable
        }

        $env:LogScope = "" # Reset the LogScope environment variable to an empty string
    }
}
