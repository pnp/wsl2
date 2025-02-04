using namespace System.Management.Automation
using module ./PSColors.psm1
using module ./PSScreens.psm1
Set-StrictMode -Version 3.0

. $PSScriptRoot/Send-PnPWsl2TrackEventTelemetry.ps1
$ENV:PNPWSL2_CONFIG_FILE = "PnP.Wsl2.Json"
$ENV:PNPWSL2_SCREEN_MAIN = "$PSScriptRoot\assets\screens\splscr-main.ascii"
$ENV:PNPWSL2_SCREEN_SMALL = "$PSScriptRoot\assets\screens\splscr-small.ascii"
$ENV:PNPWSL2_CandyModsFolder = "$PSScriptRoot\..\public\mods"
$ENV:PnPWsl2_FileInstance = "$HOME\PnPWsl2.sys"

$ErrorActionPreference = "Stop"
<#
.SYNOPSIS
Checks if WSL 2 is enabled on the current Windows system.

.DESCRIPTION
The Test-Wsl2Enabled function checks if WSL 2 (Windows Subsystem for Linux 2) is enabled on the current Windows system. It does this by executing the `wsl --list` command and checking the output for the presence of the help message.

.RETURNVALUE
Returns a boolean value indicating whether WSL 2 is enabled (True) or not (False).

.EXAMPLE
Test-Wsl2Enabled
Checks if WSL 2 is enabled on the current Windows system.

.NOTES
This function relies on the `wsl` command-line tool to list the available WSL distributions. It assumes that the function is being run with appropriate permissions to execute the `wsl` command.
#>
function Test-Wsl2Enabled() {
    $command = "wsl --list"
    $output = Invoke-Expression $command
    $isOfF = $($output | Out-String) -like '*-?-?h?e?l?p*'
    return -Not($isOfF)
}
## WSL functions
<#
.SYNOPSIS
Checks if WSL 2 is enabled by checking the required Windows features.

.DESCRIPTION
The Test-Wsl2EnabledByFeature function checks if WSL 2 (Windows Subsystem for Linux 2) is enabled on the current Windows system. It does this by checking the presence of the required Windows features: 'Microsoft-Windows-Subsystem-Linux' and 'VirtualMachinePlatform'.

.RETURNVALUE
Returns a boolean value indicating whether WSL 2 is enabled (True) or not (False).

.EXAMPLE
Test-Wsl2EnabledByFeature
Checks if WSL 2 is enabled on the current Windows system.

.NOTES
This function relies on the Get-WindowsFeature cmdlet to check the presence of the required Windows features. It assumes that the function is being run with appropriate permissions to access and query Windows features.
#>
function Test-Wsl2EnabledByFeature() {
    $feature1 = Get-WindowsFeature -Name 'Microsoft-Windows-Subsystem-Linux'
    $feature2 = Get-WindowsFeature -Name 'VirtualMachinePlatform'
    return ($feature1 -and $feature2)
}
<#
.SYNOPSIS
    Retrieves a list of WSL2 distributions.

.DESCRIPTION
    This function retrieves a list of WSL2 distributions either from the online source or the local source, based on the specified parameters.

.PARAMETER online
    Specifies whether to retrieve the distributions from the online source. If set to $true, the function will use the online source. If set to $false, the function will use the local source.

.PARAMETER instanceName
    Specifies the name of a specific WSL2 instance to retrieve. If provided, the function will filter the results to only include the specified instance.

.OUTPUTS
    System.String[]
    An array of strings representing the names of the WSL2 distributions.

.EXAMPLE
    Get-WSl2Distributions -online $true
    Retrieves a list of WSL2 distributions from the online source.

.EXAMPLE
    Get-WSl2Distributions -online $false -instanceName "Ubuntu-20.04"
    Retrieves a list of WSL2 distributions from the local source and filters the results to only include the "Ubuntu-20.04" instance.

#>
function Get-WSl2Distributions($online, $instanceName) {
    $env:LogScope = ""
    if (-Not(Test-Wsl2Enabled)) {
        return $null
    }
    $config = Get-ModuleConfiguration
    # Define the command
    if ($online) {
        $command = $config.Commands."Get-WslDistributionsOnline"
        $skipValue = 3
    }
    else {
        $command = $config.Commands."Get-WslDistributionsLocal"
        $skipValue = 1
    }

    # Get the output of the command
    $output = Invoke-Expression $command
    $errorCodeToCheck = "Error code: Wsl/WSL_E_DEFAULT_DISTRO_NOT_FOUND"
    $noDist = $output | Where-Object { $_ -like "$errorCodeToCheck" }
    if ($noDist -eq $errorCodeToCheck) {
        ## no Dist, therefore ...

        return $null
    }
    # Split the output into lines
    $lines = $output -split "`n"
    $lines = ($lines -join "`n") -replace "`0" , ""
    ##replace (Default) string with empty space
    $lines = $lines -replace " \(Default\)" , ""

    $lines = @($lines -split '\r?\n' | Where-Object { $_.Trim() -ne "" } | Select-Object -Skip $skipValue)
    # Initialize an array to hold the strings
    $strings = @()

    # Loop through the rest of the lines
    for ($i = 0; $i -lt $lines.Count; $i++) {
        # Split the line into values
        $values = $lines[$i] -split "\s+"

        # Add the strings to the array
        $strings += $values[0]
    }
    if ($null -ne $instanceName -and $instanceName.Length -gt 0) {
        $strings = $strings | Where-Object { $_ -eq $instanceName }
    }
    $strings = @($strings | Where-Object { $_ -ne "Distributions" -and $_ -notlike "https://*" })
    # Output
    if ($strings.Count -eq 0) {
        return $null
    }
    $ht = $strings | Sort-Object | ForEach-Object { [PSCustomObject]@{ Name = $_; } }
    $ht
}
<#
.SYNOPSIS
Checks if a Windows feature is enabled.

.DESCRIPTION
The Get-WindowsFeature function checks if a specified Windows feature is enabled on the current system. It uses the Get-WindowsOptionalFeature cmdlet to retrieve the state of the feature and determines if it is enabled.

.PARAMETER name
The name of the Windows feature to check.

.RETURNVALUE
Returns a boolean value indicating whether the specified Windows feature is enabled (True) or not (False).

.EXAMPLE
Get-WindowsFeature -name "Microsoft-Windows-Subsystem-Linux"
Checks if the "Microsoft-Windows-Subsystem-Linux" feature is enabled on the current system.

.NOTES
This function relies on the Get-WindowsOptionalFeature cmdlet to retrieve the state of the Windows feature. It assumes that the function is being run with appropriate permissions to access and query Windows features.
#>
function Get-WindowsFeature([string] $name) {
    $feature = Get-WindowsOptionalFeature -FeatureName $name -Online
    return ($feature.State -eq "Enabled")
}
## Configuration functions
<#
    .SYNOPSIS
        Initializes the module configuration.

    .DESCRIPTION
        This function initializes the module configuration by checking if a local configuration file exists. If not, it copies the original configuration file and adjusts the configuration settings.

    .EXAMPLE
        Initialize-ModuleConfiguration
        Initializes the module configuration.
#>
function Initialize-ModuleConfiguration() {
    $label = ""
    if (-Not(Test-Path -Path $ENV:PnPWsl2_FileInstance )) {
        do {

            $msg = "`n[[bryellowPnPWsl2 assets[/ are not present in the system`n"
            $msg += "`nInput [[cyanPnP.Wsl2 Rootfolder [/[default [[[bryellow$HOME[/]]:"
            Write-Log -msg $msg -noNewLine


            $RootFolder = Read-Host
            if ($RootFolder.Length -eq 0) {
                $RootFolder = $HOME
            }
            if ($RootFolder.Length -gt 0) {

                try {
                    $ErrorActionPreference = "Continue"
                    $RootFolder = Resolve-Path -Path $RootFolder -ErrorAction Stop
                }
                catch {
                    $msg = "[[redRoot folder [$RootFolder] does not exist. Please try again. (CTRL+C to abort)[/"
                    Write-Log -msg $msg
                    $RootFolder = $null
                }

            }
            else {
                $RootFolder = (Get-Location).Path
            }
        } while ($null -eq $RootFolder)
        $ErrorActionPreference = "Stop"
        $RootFolder | Set-Content -Path  $ENV:PnPWsl2_FileInstance -NoNewline
    }
    $RootFolder = Get-Content -Path  $ENV:PnPWsl2_FileInstance -Raw    
    New-Item -Path "$RootFolder\PnPWsl2\mods" -ItemType Directory -Force -ErrorAction SilentlyContinue
    $version = (Import-PowerShellDataFile $PSScriptRoot\..\PnP.Wsl2.psd1).ModuleVersion
    
    [PSScreens]::ShowMainScreen($label,$version)

    $localConfigFile = "$RootFolder\PnPWsl2\$($ENV:PNPWSL2_CONFIG_FILE)"


    # if (-not (Test-Path $localConfigFile)) {
    $oriConfigFile = "$PSScriptRoot\..\$($ENV:PNPWSL2_CONFIG_FILE)"
    $env:WriteToFilePath = "$RootFolder\PnPWsl2\logs\PnPWsl2_{0}.log" -f $((Get-Date).ToString("yyyyMMddhh"))
    New-Item -Path "$RootFolder\PnPWsl2\logs" -ItemType Directory -Force -ErrorAction SilentlyContinue | Out-Null
    if (-Not(Test-Path -Path $localConfigFile)) {
    
        Copy-Item -Path $oriConfigFile -Destination $localConfigFile
        
    }
    #validate if .sh scripts were modified
    $myScriptsFolder = "*\myscripts\*"
    $option = Invoke-ModFilesBackup -folderOrigin "$PSScriptRoot\..\public\mods" -folderDest "$RootFolder\PnPWsl2\mods" `
        -dontWatchFolder  $myScriptsFolder 
    if ($option -eq "Q") {
        Write-Log -msg "`n[[brwhiteImport aborted by user[/"
        return
    }
    if ($option -eq "O") {
        Write-Log -msg "`n[[brwhite Overwriting files ...[/"
    }
    ## Kill pending processes
    Stop-PendingProcesses
    # copy mods to local folder
    # this actually changes the file encoding in destination folder so no good!
    # Copy Files is a copycat of the copy-item function that preserves the file encoding

    Copy-Files -source "$PSScriptRoot\..\public\mods" -destination "$RootFolder\PnPWsl2\mods" -dontCopyFolder  $myScriptsFolder 
   
    ## get all files in "$RootFolder\PnPWsl2\mods" and create bash aliases in ~/.bashrc
    ##adjust configuration
    $ENV:PNPWSL2_CONFIG_FILE = $localConfigFile
    $config = Get-ModuleConfiguration
    $config.WslCandyFolder = "$RootFolder\PnPWsl2\mods"
    $config.WslActiveDistribution = "ubuntu"
    #powershell tempo folder

    $config.WslTempFolder = (Get-Item $env:TEMP).FullName
    $config.PnPWsl2RootFolder = "$RootFolder\PnPWsl2"
    # $imagesFolder =$null
    # if ($null -ne $config.WslTempFolder) { 
    #     $imagesFolder = $config.WslTempFolder 
    #     $instancesFolder = "$imagesFolder\..\instances" 
    #     New-Item -Path $imagesFolder -ItemType Directory -Force | Out-Null
    #     New-Item -Path $instancesFolder -ItemType Directory -Force | Out-Null
    # }


    Save-ModuleConfiguration -configFileObj $config
    # }
    $config = Get-ModuleConfiguration
    $ENV:PNPWSL2_CONFIG_FILE = $localConfigFile
    $ENV:PNPWSL2_CandyModsFolder = $config.WslCandyFolder
    $ENV:PNPWSL2_ImagesRootFolder = $config.PnPWsl2RootFolder
    if ($option -eq "O" -or $option -eq "B") {
        Write-Log -msg "[[brwhiteDone ![/`n"
    }
}
<#
    .SYNOPSIS
        Retrieves the module configuration.

    .DESCRIPTION
        This function retrieves the module configuration from the PnP.Wsl2.Json file.

    .OUTPUTS
        System.Object
            The module configuration object.

    .EXAMPLE
        Get-ModuleConfiguration
        Retrieves the module configuration.
#>
function Get-ModuleConfiguration() {
    $configFile = $ENV:PNPWSL2_CONFIG_FILE
    if (-not (Test-Path $configFile)) {
        return $null

    }
    $config = Get-Content $configFile | ConvertFrom-Json -Depth 5
    return $config
}
<#
    .SYNOPSIS
        Saves the module configuration.

    .DESCRIPTION
        This function saves the module configuration to the PnP.Wsl2.Json file.

    .PARAMETERS
        -configFileObj
            The module configuration object to save.

    .EXAMPLE
        Save-ModuleConfiguration -configFileObj $config
        Saves the module configuration.
#>
function Save-ModuleConfiguration($configFileObj) {
    $configFileContent = $configFileObj | ConvertTo-Json
    $configFileContent | Set-Content $ENV:PNPWSL2_CONFIG_FILE -NoNewline
}

<#
    .SYNOPSIS
        Writes a log message.

    .DESCRIPTION
        This function writes a log message with the specified message, scope, user ID, process ID, and file path.

    .PARAMETERS
        -msg
            The log message to write.

        -Scope
            The scope of the log message.

        -UserId
            The user ID associated with the log message.

        -ProcessID
            The process ID associated with the log message.

        -WriteToFilePath
            The file path to write the log message to.

    .EXAMPLE
        Write-Log -msg "This is a log message" -Scope "Module" -UserId "user1" -ProcessID "1234" -WriteToFilePath "C:\Logs\log.txt"
        Writes a log message with the specified scope, user ID, process ID, and file path.
#>
function Write-Log {
    [CmdletBinding(DefaultParameterSetName = 'msg')]
    Param (
        [Parameter(ParameterSetName = 'msg', Mandatory = $true, Position = 0)]
        [String] $msg,
        [Parameter(Mandatory = $false)]
        [String] $Scope,
        [Parameter(Mandatory = $false)]
        [String] $UserId,
        [Parameter(Mandatory = $false)]
        [String] $ProcessID,
        [Parameter(Mandatory = $false)]
        [String] $WriteToFilePath,
        [Parameter(Mandatory = $false)]
        [switch] $NoNewLine,
        [switch] $NoInitialSpace
    )

    [bool] $writeToFile = $false
    if ((-Not $WriteToFilePath) -and ($env:WriteToFilePath)) {
        $WriteToFilePath = $env:WriteToFilePath
        $writeToFile = $true
    }
    if ($WriteToFilePath) {
        $writeToFile = $true
    }
    if ((-Not $Scope) -and ($env:LogScope)) {
        $Scope = $env:LogScope
    }
    if ((-Not $UserId) -and ($env:LogUserId)) {
        $UserId = $env:LogUserId
    }
    if ((-Not $ProcessID) -and ($env:LogProcessID)) {
        $ProcessID = $env:LogProcessID
    }
    $processIDLabel = ""
    if ($ProcessID) {
        $processIDLabel = "[" + $ProcessID + "]"
    }
    $logHasDate = $false
    if ($env:LogHasDate) {
        $logHasDate = $true
    }
    if ($Scope.length -gt 0) {
        $Scope = "[" + $Scope + "]"
    }
    $outputMsg = "$Scope$processIDLabel$msg"
    $outputMsg = [PSColors]::ApplyColors($outputMsg)
    if ($writeToFile) {
        $outputMsgFile = "[$((Get-Date).ToString("yyyy-MM-dd hh:mm:ss.fff"))] $outputMsg"
        $outputMsgFile = [PSColors]::RemoveColors($outputMsgFile, $false, $null)
        if (-not (Test-Path $WriteToFilePath)) {
            New-Item -Path $WriteToFilePath -ItemType File -Force -ErrorAction SilentlyContinue | Out-Null
        }
        Add-Content -Path $WriteToFilePath -Value $outputMsgFile
    }
    $initialSpace = " "
    if ($NoInitialSpace) {
        $initialSpace = ""
    }
    $outputMsg = $initialSpace + $outputMsg
    if ($NoNewLine) {
        Write-Host -NoNewline $outputMsg
    }
    else {
        Write-Host $outputMsg
    }

}

# add description
<#
.SYNOPSIS
    This function modifies the content of a file to use Unix-style line endings and UTF-8 NoBOM encoding.

.DESCRIPTION
    The Set-UnixFileContent function takes one parameter: a file object.
    It reads the content of the file, replaces all carriage return characters with nothing (effectively converting any Windows-style line endings to Unix-style),
    and then writes the modified content back to the file using UTF-8 NoBOM encoding.

.PARAMETER file
    The file object whose content is to be modified. This should be a valid file object with a FullName property.

.EXAMPLE
    Set-UnixFileContent -file $file

    This command modifies the content of the file represented by the $file object to use Unix-style line endings and UTF-8 NoBOM encoding.

.NOTES
    The function uses the Get-Content cmdlet to read the content of the file.
    It uses the -replace operator to replace carriage return characters.
    It uses the Set-Content cmdlet to write the modified content back to the file.
#>
function Set-UnixFileContent([string]$filePath) {
    $fileContent = Get-Content -Path $filePath  -Raw
    $modifiedContent = $fileContent -replace '\r', ''
    Set-Content -Path $filePath -Value $modifiedContent -Encoding utf8NoBOM -NoNewline
}
# This function is used to kill any pending processes
function Stop-PendingProcesses() {
    # Define the processes to be killed
    #MicrosoftWebDriver.exe <- use in mod\az\SSHKeyAdd.sh
    $pendingProcesses = "MicrosoftWebDriver".split(",")
    # Loop through each process
    foreach ($processName in $pendingProcesses) {
        # Get the process by its name
        $processes = Get-Process -Name $processName -ErrorAction SilentlyContinue
        # If the process exists
        if ($processes) {
            # Loop through each process found
            foreach ($process in $processes) {
                # Kill the process
                $process.Kill()
            }
        }
    }
}
<#
.SYNOPSIS
    This function copies files from a source directory to a destination directory, recursivly.
    Why this function right? Apparantely Copy-Item with -Recurse doesn preserve the file encoding
#>
function Copy-Files {
    param (
        [string]$source,
        [string]$destination,
        [string]$dontCopyFolder
    )

    # Ensure source and destination paths are resolved
    $sourcePath = (Resolve-Path -Path $source).Path
    $destinationPath = (Resolve-Path -Path $destination).Path

    # Ensure destination directory exists
    if (-not (Test-Path -Path $destinationPath)) {
        New-Item -ItemType Directory -Path $destinationPath -Force | Out-Null
    }

    # Get all files from source directory
    $files = Get-ChildItem -Path $sourcePath -File -Recurse

    foreach ($file in $files) {
        # Determine the destination file path
        $relativePath = $file.FullName.Substring($sourcePath.Length)
        $destFilePath = Join-Path -Path $destinationPath -ChildPath $relativePath

        # Ensure the destination directory exists
        $destDir = Split-Path -Path $destFilePath -Parent
        if (-not (Test-Path -Path $destDir)) {
            New-Item -ItemType Directory -Path $destDir -Force | Out-Null
        }
        try {
            $theFile=$null;
            if ($file.FullName -like $dontCopyFolder) {
                ## test if file dest already exists [only copy if doesnt exists]
                $myScriptsFile = $destFilePath
                if (-not (Test-Path -Path $myScriptsFile)) {
                    $theFile = Copy-Item -Path $file.FullName -Destination $destFilePath -Force -PassThru
                }
            }
            else {
                $theFile=Copy-Item -Path $file.FullName -Destination $destFilePath -Force -PassThru
            }
            # Copy the file
           
            if ($null -ne $theFile -and ($file.Extension -eq '.txt' -or $file.Extension -eq '.sh')) {
                Set-UnixFileContent -FilePath $theFile.FullName
            }
        }   
        catch {
                $a=""
        }
        
    }
}
# This function copies all files from the specified source directory to the destination directory. 
# If the destination directory does not exist, it will be created. 
# For each file copied, if the file is a text file (.txt) or a shell script (.sh), the function will call Set-UnixFileContent to process the file.
function Copy-Files22($source, $dest, $dontCopyFolder) {
    Copy-FolderRecursively -source $source -destination $dest
    exit
    $source = $source.ToLower()
    $dest = $dest.ToLower()

    # copy all files from $source $dest and on each file  if its a text file or sh call 
    
    # Ensure destination directory exists
    if (-not (Test-Path -Path $dest)) {
        New-Item -ItemType Directory -Path $dest
    }

    # Get all files from source directory
    $files = Get-ChildItem -Path $source -File -Recurse
    $theFile = $null
    foreach ($file in $files) {
        Write-Host " Copy-Files theFile10 "
        Write-Host "     source = $($source) "
        Write-Host "     destPath= $($dest)"
        Write-Host "     FullName=$($file.Fullname)"

       
        $sourcePath = (Resolve-Path -Path $source).Path
        Write-Host "     sourcePath = $($sourcePath) "
        Write-Host " REPLACE=$($file.Fullname.replace($sourcePath, $dest))"
        $tobe = $file.Fullname -replace ('(?i)' + $sourcePath), $dest
        Write-Host " tobe=$tobe"
        exit
        $destPath = Split-Path -Path ( $tobe) -Parent 
        Write-Host " Copy-Files theFile11 sourcePath = $($sourcePath) destPath= $($destPath)"
        if ($file.FullName -like $dontCopyFolder) {
            ## test if file dest already exists [only copy if doesnt exists]
            $myScriptsFile = $destPath
            if (-not (Test-Path -Path $myScriptsFile)) {
                New-Item -Path $dest -ItemType Directory -Force | Out-Null
                Write-Host " Copy-Files myScriptsFile"
                $theFile = Copy-Item -Path $file.FullName -Destination $myScriptsFile -Force -PassThru
            }
        }
        else {
            <# Action when all if and elseif conditions are false #>
            New-Item -Path $destPath -ItemType Directory -Force | Out-Null
            Write-Host " Copy-Files theFile11"
            $theFile = Copy-Item -Path $file.FullName -Destination $destPath -PassThru
            exit
        }
        # Check if the file is a text file or a shell script
        if ($null -ne $theFile -and ($file.Extension -eq '.txt' -or $file.Extension -eq '.sh')) {
            Set-UnixFileContent -FilePath $theFile.FullName
        }
    }


}
function Copy-FilesOld($source, $dest, $dontCopyFolder) {
 
    $source = Resolve-Path -Path $source
    if (-Not(Test-Path -Path $dest)) {
        New-Item -Path $dest -ItemType Directory -Force | Out-Null
    }
    $destination = Resolve-Path -Path $dest
    Write-Host "Copy0 item custom source=$source dest=$dest"

    $filesOrigin = (Get-ChildItem $source -Recurse -File)
       
    foreach ($f in $filesOrigin) {
        [System.IO.FileInfo] $file = $f;
        Write-Host "Copy0112 /source:$($source.Path)"
        Write-Host "Copy0112 /dest:$($destination.Path)" 
        Write-Host "Copy0112 /file:$($file.FullName)"            
        $fileDest = $file.FullName.Replace($source.Path, $destination.Path)
        Write-Host "Copy0112 /fileDest:$fileDest"            
        $fileDest = $fileDest.Replace($file.Name, "")
        $fileDest = $fileDest.TrimEnd("\")
        if (-not (Test-Path -Path $fileDest)) {
            New-Item -Path $fileDest -ItemType Directory -Force | Out-Null
        }

        #check if its a text file
        if ($file.Extension -eq ".sh" -or $file.Extension -eq ".txt") {
            Set-UnixFileContent -file $file.FullName
        }
        if ($file.FullName -like $dontCopyFolder) {
            ## test if file dest already exists
            $myScriptsFile = "$($fileDest)\$($file.name)"
            if (-not (Test-Path -Path $myScriptsFile)) {
                Copy-Item -Path $file.FullName -Destination $fileDest -Force
            }
        }
        else {
            Write-Host "Copy0113"
            Write-Host "Copy0113 - $($file.FullName) to $($fileDest)"
            Copy-Item -Path $file.FullName -Destination $fileDest -Force
        }
        

    }
}
<#
.SYNOPSIS
Invokes a script within a WSL 2 distribution using the specified parameters.

.DESCRIPTION
The Invoke-ModScript function allows you to invoke a script within a WSL 2 (Windows Subsystem for Linux 2) distribution. It takes the script base name, distribution name, and super user flag as parameters. The function retrieves the script content, creates a temporary file in the WSL 2 environment, and executes the script within the specified distribution.

.PARAMETER scriptBaseName
The base name of the script to be invoked.

.PARAMETER distribution
The name of the WSL 2 distribution in which the script should be executed.

.PARAMETER superUser
A boolean flag indicating whether the script should be executed with super user privileges (sudo).

.RETURNVALUE
Returns the output of the executed script.

.EXAMPLE
Invoke-ModScript -scriptBaseName "myscript.sh" -distribution "Ubuntu-20.04" -superUser $false
Invokes the script "myscript.sh" within the "Ubuntu-20.04" WSL 2 distribution without super user privileges.

.NOTES
This function relies on the Get-ModuleConfiguration function to retrieve the configuration settings. It assumes that the function is being run with appropriate permissions to access and execute scripts within the WSL 2 environment.
#>
function Invoke-ModScript($scriptBaseName, $distribution, $superUser) {
    $config = Get-ModuleConfiguration
    $toolsFolder = $config.WslCandyFolder
    $cmdFile = "$toolsFolder\$scriptBaseName"
    $cmdFile = (Get-Content -Path  $cmdFile -Raw).Trim()
    New-Item -Path "$Env:TEMP\PnPWsl2\"  -ItemType Directory -Force | Out-Null
    $parent = (Split-Path "$Env:TEMP\PnPWsl2\$scriptBaseName" -Parent)
    New-Item -Path $parent  -ItemType Directory -Force | Out-Null
    $cmdFile | Set-Content -Path "$Env:TEMP\PnPWsl2\$scriptBaseName"  -NoNewline
    $envTempFullPath = (Get-Item $env:TEMP).FullName
    $cmdFile = "$envTempFullPath\PnPWsl2\$scriptBaseName".Replace("\", "/")
    Write-Log -msg $cmdFile -NoNewLine
    $cmd = $config.Commands.'Get-WSlPath' -f $distribution, $cmdFile
    $cmdFileExecute = Invoke-Expression -Command $cmd

    $cmd = $config.Commands.'Execute-WSlBashFile' -f $distribution, $cmdFileExecute, $superUser
    $output = Invoke-Expression -Command $cmd
    return $output
}
<#
.SYNOPSIS
Displays a confirmation prompt and waits for user input.

.DESCRIPTION
The Show-ConfirmPrompt function displays a confirmation prompt with a specified message and waits for user input. It allows the user to confirm or quit the operation by pressing the corresponding keys.

.PARAMETER msg
The message to be displayed as the confirmation prompt.

.PARAMETER yesKey
The key that represents the confirmation action. Pressing this key will confirm the operation.

.PARAMETER quitKey
The key that represents quitting the operation. Pressing this key will cancel the operation.

.RETURNVALUE
Returns a boolean value indicating whether the user confirmed (True) or quit (False) the operation.

.EXAMPLE
Show-ConfirmPrompt -msg "Are you sure you want to proceed? (Y/N)" -yesKey "Y" -quitKey "N"
Displays the confirmation prompt with the specified message and waits for the user to press either "Y" to confirm or "N" to quit.

.NOTES
This function relies on the [Console]::ReadKey method to read the user's input from the console. It assumes that the function is being run in a console environment.
#>
function Show-ConfirmPrompt($msg, $yesKey, $quitKey) {

    ##write-host with no new line
    Write-Log -msg $msg -NoNewLine
    $out = $false
    $prompt = $null;
    while (-not $out ) {
        $answer = [Console]::Readkey($true)
        if ($answer.key -eq $yesKey) {
            $out = $true
            $prompt = $true

        }
        if ($answer.key -eq $quitKey) {
            $out = $true
            $prompt = $false
        }
    }
    $prompt
}
<#
.SYNOPSIS
Displays a prompt with multiple options and waits for user input.

.DESCRIPTION
The Show-ConfirmOptionsPrompt function displays a prompt with two options and waits for user input. It allows the user to select one of the options or quit the operation by pressing the corresponding keys.

.PARAMETER msg
The message to be displayed as the prompt.

.PARAMETER option1
The first option to be displayed.

.PARAMETER option2
The second option to be displayed.

.PARAMETER quitKey
The key that represents quitting the operation. Pressing this key will cancel the operation.

.RETURNVALUE
Returns the selected option or the quit key.

.EXAMPLE
Show-ConfirmOptionsPrompt -msg "Select an option: (1) Option A, (2) Option B, (Q) Quit" -option1 "1" -option2 "2" -quitKey "Q"
Displays the prompt with the specified message and options, and waits for the user to select an option or quit.

.NOTES
This function relies on the [Console]::ReadKey method to read the user's input from the console. It assumes that the function is being run in a console environment.
#>
function Show-ConfirmOptionsPrompt($msg, $option1, $option2, $quitKey) {

    ##write-host with no new line
    Write-Log -msg $msg -NoNewLine
    $out = $false
    $prompt = $null;
    while (-not $out ) {
        $answer = [Console]::Readkey($true)
        if ($answer.key -eq $option1) {
            $out = $true
            $prompt = $option1

        }
        if ($answer.key -eq $option2) {
            $out = $true
            $prompt = $option2

        }
        if ($answer.key -eq $quitKey) {
            $out = $true
            $prompt = $quitKey
        }
    }
    $prompt
}
<#
.SYNOPSIS
Performs a backup of modified files in a specified folder.

.DESCRIPTION
The Invoke-ModFilesBackup function compares files in the origin folder with files in the destination folder. It identifies files that have been modified and provides options to either overwrite them or create a backup before overwriting.

.PARAMETER folderOrigin
The path to the origin folder containing the files to be compared.

.PARAMETER folderDest
The path to the destination folder where the files will be compared against.

.RETURNVALUE
Returns the user's selected option: "O" for overwrite, "B" for backup and overwrite, or "Q" for quit.

.EXAMPLE
Invoke-ModFilesBackup -folderOrigin "C:\Path\To\Origin" -folderDest "C:\Path\To\Destination"
Performs a backup of modified files in the origin folder and provides options to overwrite or create a backup in the destination folder.

.NOTES
This function relies on the Get-FileHash cmdlet to calculate the MD5 hash of each file. It assumes that the function is being run with appropriate permissions to access and modify files in the specified folders.
#>
function Invoke-ModFilesBackup($folderOrigin, $folderDest, $dontWatchFolder) {
    $folderOrigin = (Resolve-Path -Path $folderOrigin).Path.ToLower()
    $folderDest = (Resolve-Path -Path $folderDest).Path.ToLower()

    $filesOrigin = (Get-ChildItem  $folderOrigin -Recurse -File) | ForEach-Object {
        $hash = (Get-FileHash $_.FullName -Algorithm MD5).Hash
        $_ | Select-Object @{Name = 'BaseName'; Expression = { $_.FullName.toLower().Replace($folderOrigin, "") } }, Length, `
        @{Name = 'Hash'; Expression = { $hash } },
        FullName,
        Operation,
        LastWriteTime
    }
    $filesDest = (Get-ChildItem  $folderDest -Recurse -File) | ForEach-Object {
        $hash = (Get-FileHash $_.FullName -Algorithm MD5).Hash
        $_ | Select-Object @{Name = 'BaseName'; Expression = { $_.FullName.toLower().Replace($folderDest, "") } }, Length, `
        @{Name = 'Hash'; Expression = { $hash } },
        FullName,
        Operation,
        LastWriteTime

    }

   
    foreach ($file in $filesOrigin) {

        $fileDest = $filesDest | Where-Object { ($_.BaseName -notLike $dontWatchFolder) -and ($_.BaseName -eq $file.BaseName) }
        # Write-Host ("Ori:" + $file.FullName + "`nDet:" + $fileDest.FullName  + "`n")
        if ($null -eq $fileDest ) {
            # Write-Host "File not found in destination folder: $($file.FullName)"
        }
        else {
            if ($file.Hash -ne $fileDest.Hash) {
                $fileDest.Operation = "Changed"
            }
        }
    }
    $files = @($filesDest | Where-Object { $_.Operation -eq "Changed" })
    $p = $null
    if ($files.Count -gt 0) {
        [string]$msg = "[[cyan`nPnPWsl2[[brwhite is already installed, and apparently some files inside the mods folder are outdated\modified:`n`n "
        Write-Log -msg $msg
        $msg = ($files | Select-Object FullName, LastWriteTime | Format-Table | Out-String ).Trim()
        Write-Log -msg "[[gray $msg"
        $msg = "`n`n[[brwhite[[[bryellowO[[brwhite]verwrite all files? [[brwhite[[[bryellowB[[brwhite]ackup and overwrite? [[brwhite[[[bryellowQ[[brwhite]uit :"
        $p = Show-ConfirmOptionsPrompt -msg $msg -option1 "O" -option2 "B" -quitKey "Q"
        Write-Log -msg " "
    }
    ## move old mods folder to backup
    if ($p -eq "B") {
        # Move-Item -Path "$folderDest\*" -Destination $folderBackup
        $folderBackup = "$folderDest\_backup"
        New-Item -Path $folderBackup -ItemType Directory -Force | Out-Null
        $destinationZip = "$folderBackup\mods_$((Get-Date).ToString("yyyyMMddHHmmss")).zip"
        # Excluded folder(s)
        $excludedFolders = @("_backup")
        # Get a list of items excluding specified folders
        $itemsToCompress = Get-ChildItem -Path $folderOrigin | Where-Object { $_.name -notin $excludedFolders }
        Compress-Archive -Path $itemsToCompress.FullName -DestinationPath $destinationZip -Force
        Write-Log "`n [[brwhiteBackup folder created ([[yellow$folderBackup[[brwhite) !"
    }
    $p
}
<#
.SYNOPSIS
    Generates bash aliases for all .sh files in a specified directory and its subdirectories, excluding "core.sh" and "init.sh".

.DESCRIPTION
    This function takes a directory as input and finds all .sh files in that directory and its subdirectories, excluding "core.sh" and "init.sh".
    For each file found, it constructs a bash alias command in the format "alias pnpwsl2-{parent-dir}-{dir}-{filename}='bash {full-path}'",
    where {parent-dir} is the first two characters of the parent directory name, {dir} is the directory name, and {filename} is the file name without extension.
    The function returns an array of all the alias commands, enclosed between "#### PNPWSL2 CANDY ALIAS STARTS HERE" and "#### PNPWSL2 CANDY ALIAS ENDS HERE".

.PARAMETER folder
    The directory to search for .sh files. The path should be in Windows format (using backslashes).

.EXAMPLE
    PS C:\> Get-CandyBashAliases -folder "C:\work"

.OUTPUTS
    String[]. An array of bash alias commands.

.NOTES
    The function assumes that all .sh files are directly under a subdirectory of the root directory, and that the parent directory of each file has a name of at least two characters.
#>
function Get-CandyBashAliases {
    param (
        [string]$folder
    )

    $allAlias = @()
    $allAlias += " #### PNPWSL2 CANDY ALIAS STARTS HERE"
    # Get all files in the directory
    $files = Get-ChildItem -Path $folder -Recurse -Filter "*.sh" -Exclude "core.sh", "init.sh"
    # For each file, create a bash alias
    foreach ($file in $files) {
        # Construct the alias command
        $linuxPath = $file.FullName.replace("\", "/")
        $aliasName = "pnpwsl2-{0}-{1}-{2}" -f $file.directory.parent.name.Substring(0, 2), `
            $file.directory.name, `
            [System.IO.Path]::GetFileNameWithoutExtension($file.Name) `

        $aliasCommand = "alias " + $aliasName + "='bash " + $linuxPath + "'"
        $allAlias += $aliasCommand
    }
    $allAlias += " #### PNPWSL2 CANDY ALIAS ENDS HERE"
    $allAlias
}