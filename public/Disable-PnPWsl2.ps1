Set-StrictMode -Version 3
$ErrorActionPreference = "Stop"
<#
.SYNOPSIS
Disables the Windows features 'VirtualMachinePlatform' and 'Microsoft-Windows-Subsystem-Linux'.

.DESCRIPTION
The Disable-PnPWsl2 function disables the Windows features 'VirtualMachinePlatform' and 'Microsoft-Windows-Subsystem-Linux'.
It prompts the user for confirmation before disabling the features and also checks if the cmdlet is being run as an administrator.
After disabling the features, it prompts the user to restart the machine.

.EXAMPLE
Disable-PnPWsl2
#>
function Disable-PnPWsl2 {
    [CmdletBinding()]
    Param()
    begin{
        #telemetry tracking #cmdletName
        Send-PnPWsl2TrackEventTelemetry -EventName $MyInvocation.MyCommand.Name
        $env:LogScope = ""
        if (-Not(Test-Wsl2Enabled)) {
            Write-Log "`bWSL2 is not enabled"
            return
        }
    }
    Process {

        ##create red color in unicode
        $redColor = "$([char]0x1b)[1;31m"
        $redDarkColor = "$([char]0x1b)[31m"
        $whiteColor = "$([char]0x1b)[1;97m"
        $resetColor = "$([char]0x1b)[0m"
        $greenColor = "$([char]0x1b)[1;32m"
        $env:LogScope = "Disable-PnPWsl2"
        $env:LogScope = ""
        # Write-Log "Start"
        ##ask for yes or no
        $vmp1= "$redColor VirtualMachinePlatform $resetColor"
        $vmp2= "$redColor Microsoft-Windows-Subsystem-Linux $resetColor"
        ## create a string with 10 '#'
        $line = '#' * 40
        $attention="`n$greenColor### $whiteColor[ATTENTION!] $resetColor $greenColor$line`n"
        ## beep
        [console]::beep(500,300)
        Write-Log $attention
        $answer = Read-Host -Prompt "You are about to$redDarkColor disable$resetColor the following Windows Features: `n`n $whiteColor*$vmp1 `n $whiteColor*$vmp2`n`nDo you want to continue? (y/n)"
        if ($answer -eq "n" ){
            Write-Log "Exiting ..."
            $env:LogScope = ""
            return
        }
        $isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
        if (-not $isAdmin) {
            Write-Log "You need to run this cmdlet as Administrator"
            Write-Log  "Press Enter to continue"
            Read-Host
            Write-Log "End"
            Write-Log "Exiting..."
            $env:LogScope = ""
            return
        }
        Write-Log " Disabling Windows Optional Feature 'VirtualMachinePlatform'"
        Disable-WindowsOptionalFeature -Online -FeatureName 'VirtualMachinePlatform' -NoRestart
        Write-Log " Disabling Windows Optional Feature 'Microsoft-Windows-Subsystem-Linux'"
        Disable-WindowsOptionalFeature -Online -FeatureName 'Microsoft-Windows-Subsystem-Linux' -NoRestart
        [console]::beep(500,300)
        $answer = Read-Host -Prompt "To enforce features disabling this machine need to be$redColor restarted$resetColor.`n`nDo you want to restart this machine? (y/n)"
        if ($answer -eq "n" ){
            Write-Log "Exiting ..."
            $env:LogScope = ""
        }else {
            Write-Log " Restarting ..."
            Restart-Computer -Force
        }

    }
}