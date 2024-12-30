<#
This script uses Selenium WebDriver to automate the process of adding an SSH key to an Azure DevOps
organization. It navigates to the Azure DevOps SSH keys page, finds the "New" button and clicks it, 
fills in the SSH key name and content, and then navigates to the "Save" button and clicks it.
If the "New" button is not found, it prints "New button not found".
#>

# Parameters for the script: organization name, SSH key name, and SSH key content
param($organization,$sshaKeyName,$sshaKeyContent)
$ErrorActionPreference = "Stop"

# Paths to WebDriver.dll and WebDriver.Support.dll
$dll1Path = Join-path -path (Join-path -path $PSScriptRoot -ChildPath 'assemblies') -ChildPath 'WebDriver.dll'
$dll2Path = Join-path -path (Join-path -path $PSScriptRoot -ChildPath 'assemblies') -ChildPath 'WebDriver.Support.dll'

# Load the WebDriver and WebDriver.Support assemblies
Add-Type -Path $dll1Path 
Add-Type -Path $dll2Path 

# Create EdgeOptions object to customize EdgeDriver's behavior
$SeleniumOptions = New-Object OpenQA.Selenium.Edge.EdgeOptions

# Create EdgeDriverService object to interact with EdgeDriver
New-Variable -Name EdgeS -Value ([OpenQA.Selenium.Edge.EdgeDriverService]) -Force
$DefaultService = $EdgeS::CreateDefaultService()
$DefaultService.HideCommandPromptWindow = $true

# Create EdgeDriver object to control Microsoft Edge
$Edge = New-Object OpenQA.Selenium.Edge.EdgeDriver -ArgumentList @($DefaultService, $SeleniumOptions)

# Navigate to the Azure DevOps SSH keys page
$Url="https://dev.azure.com/$organization/_usersSettings/keys"
Write-Log "`n  This tool uses Selenium to add SSH keys to Azure DevOps organizations"
Write-Log "  Currently the API doesn't support the operation (yeah , its ugly but hey ..it works)"

$Edge.Url =$Url
Write-Log "`n  Launching $Url ...`n  Hit [Return] to continue when the page refreshes completely"
# Wait for user to log in
Read-Host

# Find the New button and click it ( Devops last version=> 2023 , if find element throw exception is because is the old devops version)
$elementSaveButtonNewVersion= $null
try {
    $elementSaveButtonNewVersion = $Edge.FindElement([OpenQA.Selenium.By]::CssSelector("[aria-roledescription='button']"));
    $elementSaveButtonNewVersion.Click();
}
catch {
    $elementSaveButtonNewVersion= $null
    $elementSaveButtonNewVersion = $Edge.FindElement([OpenQA.Selenium.By]::CssSelector("[command='add']"));
    $elementSaveButtonNewVersion.Click();
}


if($null -ne $elementSaveButtonNewVersion)
{
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
    if ($element.Text -ne "Save")
    {
        $element.SendKeys([OpenQA.Selenium.Keys]::Tab)
        $element = $Edge.SwitchTo().ActiveElement(); 
    }
    
    [Console]::Beep()
    Write-Log "  Hit return to save the SSH key"
    Read-Host
    if($null -ne $element)
    {
        $element.Click();        
    }
    Write-Log "  SSH key submitted !`n"
    Write-Log "  Validate if everything is Ok and hit return to exit"
    Read-Host
    $Edge.Quit();
}else
{
    Write-Log "New button not found"
}