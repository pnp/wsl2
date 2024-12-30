using namespace System.Management.Automation
using module ..\private\PnPWsl2Helpers.psm1
<#
.SYNOPSIS
    This function extracts the value of the HELP_MESSAGE variable from a Bash script.

.DESCRIPTION
    The GetScriptHelpMessage function takes one parameter: the name of a Bash script file.
    It reads the content of the file, uses a regular expression to find the value of the HELP_MESSAGE variable, 
    and then returns this value.

.PARAMETER fileName
    The name of the Bash script file from which the HELP_MESSAGE value is to be extracted. This should be a valid file name.

.EXAMPLE
    GetScriptHelpMessage -fileName "script.sh"

    This command extracts the value of the HELP_MESSAGE variable from the "script.sh" file.

.NOTES
    The function uses the Get-Content cmdlet to read the content of the file.
    It uses the [regex]::Match method to find the value of the HELP_MESSAGE variable.
#>
class ValidateWslCandy : IValidateSetValuesGenerator {

    [string]GetScriptHelpMessage($fileName) {
        # Read the content of the Bash script
        $scriptContent = Get-Content -Path $fileName -Raw
        # Use regular expression to extract the value of HELP_MESSAGE
        $helpMessageRegex = 'HELP_MESSAGE="(.*?)"'
        $helpMessage = [regex]::Match($scriptContent, $helpMessageRegex).Groups[1].Value
        return $helpMessage
    }
    <#
.SYNOPSIS
    This function retrieves the base distribution path of a given file.

.DESCRIPTION
    The GetBaseDistributionPath function takes one parameter: the name of a file.
    It replaces the WslCandyFolder path in the file name with an empty string, effectively retrieving the base distribution path of the file.

.PARAMETER fileName
    The name of the file for which the base distribution path is to be retrieved. This should be a valid file name.

.EXAMPLE
    GetBaseDistributionPath -fileName "C:\WslTools\file.txt"

    This command retrieves the base distribution path of the "file.txt" file.

.NOTES
#>
    [string]GetBaseDistributionPath($fileName) {
        $toolsFolder = ((Get-ModuleConfiguration).WslCandyFolder).ToLower()
        $fileName = $fileName.ToLower()
        $path = $fileName.Replace($toolsFolder, "")
        return $path
    }
    <#
    .SYNOPSIS
    Generates valid values for WSL tools 

    .DESCRIPTION
    This class implements the IValidateSetValuesGenerator interface to generate valid values for WSL tools.

    .NOTES
    The GetValidValues method retrieves a list of filenames in the "mods" folder and performs some modifications to generate valid values.

    #>
   

    [string[]] GetValidValues() {
        ## get all filenames in mods folder
        $config = Get-ModuleConfiguration
        $currentActiveFolder = $config.WslCandyFolder
        $mods = @( Get-ChildItem -Path $currentActiveFolder -Filter "*.sh"  -Recurse | `
                where-Object { $_.FullName -notlike "*\_core\*" } |`
                Select-Object  `
            @{name = 'Name'; expression = { $_.directory.parent.name.Substring(0, 2) + "-" + $_.directory.name + "-" + [System.IO.Path]::GetFileNameWithoutExtension($_.Name) } }, `
            @{name = 'Description'; expression = { $this.GetScriptHelpMessage($_.FullName) } }, `
            @{name = 'BaseName'; expression = { $_.Name } }, `
            @{name = 'BaseDistributionPath'; expression = { $this.GetBaseDistributionPath($_.FullName) } }, `
            @{name = 'FullPath'; expression = { $_.FullName.ToLower().replace("\", "\\") } }, `
            @{name = 'Root'; expression = { $_.directory.parent.name } }, `
            @{name = 'Scope'; expression = { $_.directory.name } } `
        )
        # ## add all options to the list as an item
        # $allTmp = @{
        #     Name        = "*AllCandy*"
        #     Description = "This option will install all available Candy."            
        #     BaseName    = "*"            
        #     FullPath    = "*"  
        #     Root        = "*"  
        #     Scope       = "*" 
        # } 
        # $mods += $allTmp   
        $env:PNPWSL2_Candy = $mods | ConvertTo-Json  ## converto to json 'cause is an environment variable  
        return $mods.Name     
    }
}