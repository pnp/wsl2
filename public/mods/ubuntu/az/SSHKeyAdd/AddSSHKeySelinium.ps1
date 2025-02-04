<#
This script uses Selenium WebDriver to automate the process of adding an SSH key to an Azure DevOps
organization. It navigates to the Azure DevOps SSH keys page, finds the "New" button and clicks it, 
fills in the SSH key name and content, and then navigates to the "Save" button and clicks it.
If the "New" button is not found, it prints "New button not found".
#>

# Parameters for the script: organization name, SSH key name, and SSH key content
param($organization, $sshaKeyName, $sshaKeyContent)
$ErrorActionPreference = "Stop"
$blue = "`e[5;36m"
$reset = "`e[0m";
function getAssemblyLastVersion ([string] $assembly, $files) {
    $assemblyExtension = $assembly.Substring($assembly.Length - 4)
    ##remove extension from assembly
  

    $allFiles = $files | Where-Object { $_.Name -like "*$assembly" -and $_.DirectoryName -notlike "*netstandard*" } #| Copy-Item -Destination $packageDir -Force
    $assembly = $assembly.Substring(0, $assembly.Length - 4)
    $versionedPaths = $allFiles | ForEach-Object {
        # Extract version (e.g., 'net8.0', 'net8.0.11', 'net9.0') from the path
        if ($_ -match ('\\lib\\(net[\d\.]+)\\' + $assembly + '\' + $assemblyExtension)) {
            [PSCustomObject]@{
                Path    = $_
                Version = [version]($matches[1].Replace('net', ''))
            }
        }
    }

    # Find the highest version
    $highestVersionPath = $versionedPaths | Sort-Object Version -Descending | Select-Object -First 1
    $highestVersionPath.Path.FullName
}
function getExeLastVersion ([string] $assembly, $files) {
    $assemblyExtension = $assembly.Substring($assembly.Length - 4)
    ##remove extension from assembly
  

    $allFiles = $files | Where-Object { $_.Name -like "*$assembly" -and $_.DirectoryName -notlike "*netstandard*" } #| Copy-Item -Destination $packageDir -Force
    $assembly = $assembly.Substring(0, $assembly.Length - 4)
    $versionedPaths = $allFiles | ForEach-Object {
        # Extract version (e.g., 'net8.0', 'net8.0.11', 'net9.0') from the path
        if ($_ -match ('\\driver\\(win[\d\.]+)\\' + $assembly + '\' + $assemblyExtension)) {
            [PSCustomObject]@{
                Path    = $_
                Version = ($matches[1].Replace('win', ''))
            }
        }
    }
    $is64Bit = ([Environment]::Is64BitOperatingSystem) 
    if ($is64Bit) {
        $versionedPaths = $versionedPaths | Where-Object { $_.Path.FullName -like "*win64*" }
    }
    else {
        $versionedPaths = $versionedPaths | Where-Object { $_.Path.FullName -like "*win86*" }
    }
    # Find the highest version
    $highestVersionPath = $versionedPaths | Sort-Object Version -Descending | Select-Object -First 1
    $highestVersionPath.Path.FullName
}
Write-Host " Start"
$packageDir = "$PSScriptRoot\assemblies"
$packageDirTmp = "$packageDir\tmp"
## get current edge version


# Install Selenium.WebDriver.MSEdgeDriver
$nodePath = "$packageDir\nuget.exe"


## create tmp folder
$packageDirTmp = "$packageDir\tmp\WebDriver"


Write-Host "  Install Selenium.WebDriver $blue"
New-Item -Path $packageDirTmp -Force -ItemType Directory | Out-Null
& $nodePath install Selenium.WebDriver -OutputDirectory $packageDirTmp -Source https://api.nuget.org/v3/index.json | Out-Null

$files = Get-ChildItem -Path $packageDirTmp -Recurse
$assemblyToCopy = getAssemblyLastVersion -assembly "WebDriver.dll" -files $files
##Copy the assembly to the assemblies folder
Copy-Item -Path $assemblyToCopy -Destination $packageDir -Force
##remove Selenium.WebDriver from the tmp folder

Remove-Item -Path $packageDirTmp -Recurse -Force

$packageDirTmp = "$packageDir\tmp\MSEdgeDriver"
Write-Host "  Install Selenium.WebDriver.MSEdgeDriver $blue"
New-Item -Path $packageDirTmp -Force -ItemType Directory | Out-Null

& $nodePath install Selenium.WebDriver.MSEdgeDriver -OutputDirectory $packageDirTmp -Source https://api.nuget.org/v3/index.json | Out-Null

$files = Get-ChildItem -Path $packageDirTmp -Recurse
$assemblyToCopy = getExeLastVersion -assembly "msedgedriver.exe" -files $files
##Copy the assembly to the assemblies folder
Copy-Item -Path $assemblyToCopy -Destination $packageDir -Force

##remove Selenium.WebDriver from the tmp folder
Remove-Item -Path $packageDirTmp -Recurse -Force

$packageDirTmp = "$packageDir\tmp"
Remove-Item -Path $packageDirTmp -Recurse -Force

# # Paths to WebDriver.dll and WebDriver.Support.dll
$dll1Path = Join-path -path (Join-path -path $PSScriptRoot -ChildPath 'assemblies') -ChildPath 'WebDriver.dll'
# # Load the WebDriver and WebDriver.Support assemblies
Add-Type -Path $dll1Path 
# Add-Type -Path $dll2Path 
$seleniumManagerPath = "$packageDir\msedgedriver.exe"

# Create EdgeDriver object to control Microsoft Edge
Write-Host "  Create EdgeDriver object to control Microsoft Edge `n`r"
Write-Host "######################"
# Create EdgeOptions object to customize EdgeDriver's behavior
$edgeOptions = New-Object OpenQA.Selenium.Edge.EdgeOptions
$edgeOptions.AddExcludedArgument("--enable-logging");
# $edgeOptions.AddArguments("headless","log-level=3") 

$Edge = New-Object OpenQA.Selenium.Edge.EdgeDriver -ArgumentList $seleniumManagerPath, $edgeOptions


# Navigate to the Azure DevOps SSH keys page
$Url = "https://dev.azure.com/$organization/_usersSettings/keys"
Write-Host "######################"
Write-Host "`n  This tool uses Selenium to add SSH keys to Azure DevOps organizations"
Write-Host "  Currently the API doesn't support the operation (yeah , its ugly but hey ..it works)"

$Edge.Url = $Url
Write-Host "`n  Launching $Url ...`n  Hit [Return] to continue when after login and the page refreshes completely"
# Wait for user to log in
Read-Host

# Find the New button and click it ( Devops last version=> 2023 , if find element throw exception is because is the old devops version)
$elementSaveButtonNewVersion = $null
try {
    $elementSaveButtonNewVersion = $Edge.FindElement([OpenQA.Selenium.By]::CssSelector("[aria-roledescription='button']"));
    $elementSaveButtonNewVersion.Click();
}
catch {
    $elementSaveButtonNewVersion = $null
    $elementSaveButtonNewVersion = $Edge.FindElement([OpenQA.Selenium.By]::CssSelector("[command='add']"));
    $elementSaveButtonNewVersion.Click();
}


if ($null -ne $elementSaveButtonNewVersion) {
    Start-Sleep -Seconds 5
    # Fill in the SSH key name and content
    $element = $Edge.SwitchTo().ActiveElement();
    $element.SendKeys($sshaKeyName)
    $element.SendKeys([OpenQA.Selenium.Keys]::Tab)     
    $element = $Edge.SwitchTo().ActiveElement();
    $element.SendKeys($sshaKeyContent)
    
    # Navigate to the save button and click it
    $element.SendKeys([OpenQA.Selenium.Keys]::Tab)
    $element = $Edge.SwitchTo().ActiveElement();
    if ($element.Text -ne "Save") {
        $element.SendKeys([OpenQA.Selenium.Keys]::Tab)
        $element = $Edge.SwitchTo().ActiveElement(); 
    }
    
    [Console]::Beep()
    Write-Host "  Hit return to save the SSH key"
    Read-Host
    if ($null -ne $element) {
        $element.Click();        
    }
    Write-Host "  SSH key submitted !`n"
    Write-Host "  Validate if everything is Ok and hit return to exit"
    Read-Host
    $Edge.Quit();
}
else {
    Write-Host "New button not found"
}