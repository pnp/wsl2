Set-StrictMode -Version 3
$ErrorActionPreference = "Stop"
<#
.SYNOPSIS
Enables the necessary features for running the Windows Subsystem for Linux 2 (WSL2).

.DESCRIPTION
The Enable-PnPWsl2 function enables the required features for running WSL2.
It checks if the cmdlet is running with administrator privileges and then enables the 'Microsoft-Windows-Subsystem-Linux' and 'VirtualMachinePlatform' features.
Finally, it restarts the computer to apply the changes.

.EXAMPLE
Enable-PnPWsl2
#>
function Enable-PnPWsl2 {
    [CmdletBinding()]
    Param()
    begin{
        #telemetry tracking #cmdletName
        Send-PnPWsl2TrackEventTelemetry -EventName $MyInvocation.MyCommand.Name
        $env:LogScope = ""
        $isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
    }
    Process {
        if (-not $isAdmin) {
            Write-Log "You need to run this cmdlet as Administrator"
            Write-Log  "Press Enter to continue"
            Read-Host
            Write-Log "Exiting..."
            $env:LogScope = ""
            return
        }
        $feature1= Get-WindowsFeature -Name 'Microsoft-Windows-Subsystem-Linux'
        $feature2= Get-WindowsFeature -Name 'VirtualMachinePlatform'

        if ($feature1) {
            Write-Log "Microsoft-Windows-Subsystem-Linux is already enabled"
        }
        if ($feature2) {
            Write-Log "VirtualMachinePlatform is already enabled"
        }
        if (-Not($feature1)){
            Write-Log " Enabling Windows Optional Feature 'Microsoft-Windows-Subsystem-Linux'"
            Enable-WindowsOptionalFeature -Online -FeatureName 'Microsoft-Windows-Subsystem-Linux' -All -NoRestart
            $restart = $true
        }

        if (-Not($feature2)){
            Write-Log " Enabling Windows Optional Feature 'VirtualMachinePlatform'"
            Enable-WindowsOptionalFeature -Online -FeatureName 'VirtualMachinePlatform' -All -NoRestart
            Write-Log " Update wsl"
            wsl --update
            $restart = $true
        }

        if ($restart) {
            [console]::beep(500,300)
            $answer = Read-Host -Prompt "To enforce features enabling this machine need to be$redColor restarted$resetColor.`n`nDo you want to restart this machine? (y/n)"
            if ($answer -eq "n" ){
                Write-Log "Exiting ..."
                $env:LogScope = ""
            }else {
                Write-Log " Restarting ..."
                Restart-Computer -Force
            }
        }
        $env:LogScope = ""
    }
}