using module ..\private\PnPWsl2Helpers.psm1
using module ..\private\PsColors.psm1
using module ..\private\PsScreens.psm1

Set-StrictMode -Version 3
$ErrorActionPreference = "Stop"
 <#
.SYNOPSIS
Displays a basic help message for the PnP.WSL2 module.

.DESCRIPTION
The Get-PnPWsl2Help function retrieves the module configuration and displays a small screen with the title and description of the configuration. It then generates a basic information message about the PnP.WSL2 module and its available commands.

.EXAMPLE
PS C:\> Get-PnPWsl2Help
Displays a basic help message for the PnP.WSL2 module.

#>
function Get-PnPWsl2Help {
    Begin {
        #telemetry tracking #cmdletName
        Send-PnPWsl2TrackEventTelemetry -EventName $MyInvocation.MyCommand.Name
        $env:LogScope = ""
        $config = Get-ModuleConfiguration
        if ($null -eq $config) {
            Write-Log "The module configuration ($ENV:PNPWSL2_CONFIG_FILE) is not set."
            return $null
        }
    }
    Process {

        [PSScreens]::ShowSmallScreen( $config.Labels.Configuration.Title, $config.Labels.Configuration.Description)| Out-null

        $basicInfo = @"
[[green`nPNP.WSL2.HELP
---------------------------------------------------------[/
[[cyan Use [[whiteEnable-PnPWsl2[/ [[cyanin case you dont already have Wsl enabled.
[[cyan Use [[whiteDisable-PnPWsl2[/ [[cyanto disable Wsl .
[[cyan Use [[whiteGet-PnPWsl2Distribution[/ [[cyanto get online distributions.
[[cyan Use [[whiteAdd-PnPWsl2Instance[/ [[cyanto install a linux Instance.
[[cyan Use [[whiteRemove-PnPWsl2Instance[/ [[cyanto remove local wsl instance.
[[cyan Use [[whiteGet-PnPWsl2Candy[/ [[cyanto list of current available packages (scripts).
[[cyan Use [[whiteAdd-PnPWsl2Candy[/ [[cyanto add\install packages to a linux Instance.
[[cyan Use [[whiteGet-PnPWsl2Configuration[/ [[cyanto get current configurations.
[[cyan Use [[whiteGet-PnPWsl2Instance[/ [[cyanto get installed local wsl instances.
[[cyan Use [[whiteInvoke-PnPWsl2Script[/ [[cyanto execute a bash script inside the wsl instance.
[[cyan Use [[whiteCopy-PnPWsl2Instance[/ [[cyanto copy a wsl instance to a new instance.
[[cyan Use [[whiteImport-PnPWsl2Instance[/ [[cyanto import a wsl instance from a tar file (zip file).
[[cyan Use [[whiteExport-PnPWsl2Instance[/ [[cyanto export a wsl instance to a tar file (zip file).
[[cyan Use [[whiteGet-PnPWsl2CheckPoint[/ [[cyanto list current checkpoints available for an instance.
[[cyan Use [[whiteCheckPoint-PnPWsl2Instance[/ [[cyanto create a wsl instance checkpoint.
[[cyan Use [[whiteRestore-PnPWsl2Instance[/ [[cyanto restore a wsl instance checkpoint.

[[green---------------------------------------------------------[/
"@
        $out = ([PsColors]::ApplyColors($basicInfo))
        Write-Log $out

    }
}