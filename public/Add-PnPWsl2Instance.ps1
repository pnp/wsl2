using module ..\private\PnPWsl2Helpers.psm1
using module ..\private\ValidateWslOnlineDistribution.psm1

Set-StrictMode -Version 3
$ErrorActionPreference = "Stop"

<#
.SYNOPSIS
Adds a new WSL2 instance.

.DESCRIPTION
The Add-PnPWsl2Instance adds a new WSL2 instance with a specified distribution.
Behind the scenes, it creates a folder in PnPWsl2/instances with the  instance name and will export a backup of the current instance in the PnPWsl2/images folder

.PARAMETER Distribution
Specifies the distribution for the new WSL2 instance.
This parameter is mandatory.

.PARAMETER InstanceName
Specifies the name for the new WSL2 instance.
This parameter is mandatory.

.EXAMPLE
    Add-PnPWsl2Instance -Distribution "Ubuntu-20.04" -InstanceName "MyInstance"

    This command adds a new WSL2 instance named "MyInstance" with the "Ubuntu-20.04" distribution.
#>

function Add-PnPWsl2Instance {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $true)]
        [ValidateSet( [ValidateWslOnlineDistribution] )]
        [ArgumentCompleter({
        param($wordToComplete)
                [string[]] $validValues = [ValidateWslOnlineDistribution]::new().GetValidValues()
                $validValues -like "$wordToComplete*"
            })]
        $Distribution,
        [Parameter(Mandatory = $true)]
        $InstanceName
    )
    begin{
        #telemetry tracking #cmdletName + distribution
        Send-PnPWsl2TrackEventTelemetry -EventName $MyInvocation.MyCommand.Name -CustomProperties @{CmdLetValue1=$Distribution}
        $env:LogScope = ""
        if (-Not(Test-Wsl2Enabled)) {
            Write-Log "`bWSL2 is not enabled"
            return
        }
        $config = Get-ModuleConfiguration
    }
    Process {


        Write-Log "`n The [[brwhiteAdd-PnPWsl2Instance[/ will ...: `n[/
  1) Set WSL2 defaultversion to 2
  2) Installs a Wsl2 temporary instance based on the named distribution
  3) Installs baseline packages in the Wsl2 temp instance
  4) Adds the named instance as local wsl2 instance
  5) Removes the temp instance
  6) Creates a checkpoint"
        $msg="`n[[brwhiteContinue ?[/ [[[yellowy[//[[yellowN[/]"
        $out = Show-ConfirmPrompt -msg $msg -yesKey "y" -quitKey "n"
        if (-Not $out) {
            Write-Log "`nExiting ..."
            $env:LogScope =""
            return
        }
        ## test if $instanceName already exists
        $instanceName = $InstanceName
        $imagesFolder = $config.WslTempFolder
        $instancesFolder = "$($config.PnPWsl2RootFolder)\instances"
        $out = Get-WSl2Distributions -online $false -instanceName $instanceName
        if ($out) {
            Write-Log "`n`n [[[yellow$instanceName[/] instance [[redalready exists[/ in WSL2 !"
            Write-Log "Exiting ...`n"
            return
        }
        Write-Log "`n`n   ([[brwhite1/6[/) Set WSL2 defaultversion to [[cyan2 [/"
        Invoke-Expression $config.Commands.'Set-WslDefaultVersion' | Out-Null

        # Install WSL2 for the specified distribution and super user
        Write-Log "  ([[brwhite2/6[/) Installing temporary [[cyan$Distribution[/ instance in Wsl2 ...[/" -NoNewLine
        # Write-Log "[[gray - WSL OUTPUT -----------------------------------`n"
        Start-Process -FilePath "wsl" -ArgumentList "--install -d $Distribution"
        # Write-Log "`n[[gray  ------------------------------------------------`n[/"


        # Create WSL images and instances folders if not provided
        # Write-Log " Creating Wsl images + Instances folders !"

        New-Item -Path $imagesFolder -ItemType Directory -Force | Out-Null
        New-Item -Path $instancesFolder -ItemType Directory -Force | Out-Null
        New-Item -Path "$instancesFolder\$instanceName" -ItemType Directory -Force | Out-Null


        # Write-Log " Wsl images + Instances folders created ![[cyan $DefaultWslRootFolder\wsl\images[/"
        # Prompt user to continue after setting up the distribution
        $msg=" [[green[[[/ [[[yellowc[/] [[brwhitewhen the install is done /[[[yellowQ[/] [[brwhiteto exit[[green ]][/`n"
        $out = Show-ConfirmPrompt -msg $msg -yesKey "c" -quitKey "q"
        if (-Not $out) {
            Write-Log " Exiting ..."
            $env:LogScope =""
            return
        }
        #Install nvm and node 10 as baseline
        Write-Log "  ([[brwhite3/6)[/ Installing baseline packages ... ([[yellowActive Linux Distribution [[/[[cyan$($config.WslActiveDistribution)[[yellow][/)"
        # Write-Log "[[gray - WSL OUTPUT -----------------------------------`n"
        $toolsFolder = $config.WslCandyFolder
        $cmdFile = "$toolsFolder\$($config.WslActiveDistribution)\_core\init.sh"
        Invoke-PnPWsl2Script -ScriptPath $cmdFile -Instance $Distribution
        ##add alias
        $cmdFile = "$toolsFolder\$($config.WslActiveDistribution)\_core\alias.sh"
        Invoke-PnPWsl2Script -ScriptPath $cmdFile -Instance $Distribution

        # Write-Log "`n[[gray  ------------------------------------------------`n[/"
        # Export the current WSL image to the specified images folder
        Write-Log "  ([[brwhite4/6)[/ Adding Wsl instance ... " -NoNewLine

        Copy-PnPWsl2Instance -Instance $Distribution -NewInstanceName $instanceName -Force | Out-Null

        # Remove the current WSL instance
        Write-Log "  ([[brwhite5/6)[/ Removing temporary  [[cyan[$Distribution][/ Wsl instance ... " -NoNewLine
        Invoke-Expression ($config.Commands.'Remove-WslInstance' -f $Distribution )| Out-Null
        Write-Log "  [[greenRemoved ![/"
        Write-Log "  ([[brwhite6/6)[/ Creating Checkpoint ... " -NoNewLine
        CheckPoint-PnPWsl2Instance -Instance $instanceName -CheckpointName "Initial" -Force | Out-Null
        $instanceFolder = "{0}\{1}" -f $config.PnPWsl2RootFolder, "instances\$instanceName"
        $basicInfo = @"
[[green`n`nInstance installed !
---------------------------------------------------------[/
 Name:              [[cyan$instanceName[/
 Based on:          [[cyan$Distribution[/
 Instance Folder:   [[cyan$instanceFolder[/`n
 ---------------------------------------------------------[/
 If you are using Windows Terminal , the new instance will
 not be available until you restart Windows Terminal.
 ---------------------------------------------------------[/
"@
        Write-Log $basicInfo

        $env:LogScope = ""
    }
}