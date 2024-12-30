<#
    .SYNOPSIS
    PsColors class provides methods to apply and remove colors from a screen content.

    .DESCRIPTION
    The PsColors class contains methods to apply and remove colors from a screen content. It also provides functionality to capture and apply a color map to a screen file.

    .NOTES
    Author: [Your Name]
    Date: [Current Date]

    #>
class PsColors {
    [hashtable]$color
    PsColors() {
        $this.color = $this.GetColorMap()
    }
    
    <#
        .SYNOPSIS
        Retrieves the color map for PsColors class.
        
        .DESCRIPTION
        This method returns a hashtable containing the color map for PsColors class. The color map consists of color names as keys and their corresponding unicode and wildcard values as properties.
        
        .OUTPUTS
        hashtable
            A hashtable containing the color map.
    #>
    [hashtable] GetColorMap() {
        ##unicode of bright yellow
        ##$([char]0x1b)[33;1m
        
        $colorMap = @{
            "red"      = @{
                "unicode"  = "$([char]0x1b)[31m"
                "wildcard" = "\[\[red"
            }
            "black"    = @{
                "unicode"  = "$([char]0x1b)[30m"
                "wildcard" = "\[\[black"
            }
            "green"    = @{
                "unicode"  = "$([char]0x1b)[1;32m"
                "wildcard" = "\[\[green"
            }
            "yellow"   = @{
                "unicode"  = "$([char]0x1b)[33;1m"
                "wildcard" = "\[\[yellow"
            }
            "bryellow" = @{
                "unicode"  = "$([char]0x1b)[33;1m"
                "wildcard" = "\[\[bryellow"
            }                  
            "blue"     = @{
                "unicode"  = "$([char]0x1b)[34m"
                "wildcard" = "\[\[blue"
            }
            "gray"     = @{
                "unicode"  = "$([char]0x1b)[2m"
                "wildcard" = "\[\[gray"
            }
            "magenta"  = @{
                "unicode"  = "$([char]0x1b)[35m"
                "wildcard" = "\[\[magenta"
            }
            "cyan"     = @{
                "unicode"  = "$([char]0x1b)[36m"
                "wildcard" = "\[\[cyan"
            }
            "brcyan"   = @{
                "unicode"  = "$([char]0x1b)[96m"
                "wildcard" = "\[\[brcyan"
            }
            "white"    = @{
                "unicode"  = "$([char]0x1b)[37m"
                "wildcard" = "\[\[white"
            }
            "brwhite"  = @{
                "unicode"  = "$([char]0x1b)[1;97m"
                "wildcard" = "\[\[brwhite"
            }
            "bblack"   = @{
                "unicode"  = "$([char]0x1b)[7m"
                "wildcard" = "\[\[bblack"
            }
            "bred"     = @{
                "unicode"  = "$([char]0x1b)[41m"
                "wildcard" = "\[\[bred"
            }
            "bgreen"   = @{
                "unicode"  = "$([char]0x1b)[42m"
                "wildcard" = "\[\[bgreen"
            }
            "byellow"  = @{
                "unicode"  = "$([char]0x1b)[43m"
                "wildcard" = "\[\[byellow"
            }
            "bblue"    = @{
                "unicode"  = "$([char]0x1b)[44m"
                "wildcard" = "\[\[bblue"
            }
        
            "bmagenta" = @{
                "unicode"  = "$([char]0x1b)[45m"
                "wildcard" = "\[\[bmagenta"
            }
            "bgcyan"   = @{
                "unicode"  = "$([char]0x1b)[46m"
                "wildcard" = "\[\[bgcyan"
            }
            "bgwhite"  = @{
                "unicode"  = "$([char]0x1b)[47m"
                "wildcard" = "\[\[bgwhite"
            }
            "reset"    = @{
                "unicode"  = "$([char]0x1b)[0m"
                "wildcard" = "\[/"
            }
        }

        return $colorMap
    }
    
    <#
        .SYNOPSIS
        Applies the color map to the specified screen file.
        
        .DESCRIPTION
        This method reads the content of the screen file and applies the color map to it. It inserts the color at the specified index in the description. If the 'savefile' parameter is set to $true, it saves the modified content to a new file with the same name but different extension.
        
        .PARAMETER screenFilePath
        The path of the screen file to apply the color map to.
        
        .PARAMETER screenColorMapFilePath
        The path of the color map file.
        
        .PARAMETER savefile
        Specifies whether to save the modified content to a file.
        
        .OUTPUTS
        string
            The modified screen content with colors applied.
    #>
    static [string] ApplyColorsMap([string]$screenFilePath, [string]$screenColorMapFilePath, [bool] $savefile) {
        $screenContent = Get-Content -Path $screenFilePath -Raw
        $screenColorMap = Get-Content -Path $screenColorMapFilePath -Raw
        $screenColorMap = $screenColorMap | ConvertFrom-Json

        foreach ($entry in $screenColorMap) {
            # Insert the color at the specified index in the description
            $screenContent = $screenContent.Insert($entry.index, $entry.color)
        }
        $screenContent = $screenContent -replace '\s+$', ''
        $screenContent += "`r`n" 
        if ($savefile) {
            $screenContent |  Set-Content -Path ($screenFilePath.Replace(".ascii_raw", ".ascii"))  -NoNewline 
        }
        return $screenContent
    }
    
    <#
        .SYNOPSIS
        Captures the colors map from the specified screen file.
        
        .DESCRIPTION
        This method reads the content of the screen file and captures the colors map based on the color wildcards defined in the PsColors class. If the 'savefile' parameter is set to $true, it saves the captured colors map to a new file with a different extension.
        
        .PARAMETER screenFilePath
        The path of the screen file to capture the colors map from.
        
        .PARAMETER savefile
        Specifies whether to save the captured colors map to a file.
        
        .OUTPUTS
        PSObject[]
            An array of PSObjects representing the captured colors map. Each object contains the color and index properties.
    #>
    static [PSObject[]] CaptureColorsMap([string]$screenFilePath, [bool] $savefile) {
        $screenContent = Get-Content -Path $screenFilePath -Raw
        $obj = [PsColors]::new()
        $keys = $obj.color.Keys
        $keys = $keys.Clone()
        $pos = @()
        foreach ($key in $keys) {
            $value = $obj.color[$key]
            $tmp = $value.wildcard.replace("\[", "[") 
            $tmp = [PsColors]::GetColorsIndex($screenContent, $tmp)
            $pos += $tmp
        }
        $pos = $pos | Sort-Object index
        if ($savefile) {
            $file = ($screenFilePath.Replace(".ascii", ".ascii_map"))
            $pos | ConvertTo-Json | Set-Content -Path $file  -NoNewline 
            Write-host "Color map saved to $file"
        }
        return $pos
    }
    
    <#
        .SYNOPSIS
        Retrieves the positions of the colors in the main string.
        
        .DESCRIPTION
        This method searches for the specified substring in the main string and returns an array of PSObjects representing the positions of the colors. Each object contains the color and index properties.
        
        .PARAMETER MainString
        The main string to search for the colors.
        
        .PARAMETER Substring
        The substring representing the color to search for.
        
        .OUTPUTS
        PSObject[]
            An array of PSObjects representing the positions of the colors. Each object contains the color and index properties.
    #>
    static [PSObject[]] GetColorsIndex([string]$MainString, [string]$Substring) {
        $positions = @()
        $index = $MainString.IndexOf($Substring)
        while ($index -ne -1) {
            $elemen = [PSObject]::new()
            $elemen | Add-Member -MemberType NoteProperty -Name "color" -Value $Substring -PassThru
            $elemen | Add-Member -MemberType NoteProperty -Name "index" -Value $index -PassThru
            $positions += $elemen
            $index = $MainString.IndexOf($Substring, $index + 1)
        }
        return $positions
    }
    
    <#
        .SYNOPSIS
        Applies the color map to the specified string.
        
        .DESCRIPTION
        This method applies the color map to the specified string by replacing the color wildcards with their corresponding unicode values.
        
        .PARAMETER s
        The string to apply the color map to.
        
        .OUTPUTS
        string
            The modified string with colors applied.
    #>
    static [string] ApplyColors([string]$s) {
        $obj = [PsColors]::new()
        $keys = $obj.color.Keys
        $keys = $keys.Clone()
        foreach ($key in $keys) {
            $value = $obj.color[$key]
            $s = $s -replace $value.wildcard , $value.unicode
        }
        return $s
    }
    
    <#
        .SYNOPSIS
        Removes the colors from the specified screen content.
        
        .DESCRIPTION
        This method removes the colors from the specified screen content by replacing the color wildcards with an empty string. If the 'savefile' parameter is set to $true, it saves the modified content to a new file with a different extension.
        
        .PARAMETER screenContent
        The screen content to remove the colors from.
        
        .PARAMETER savefile
        Specifies whether to save the modified content to a file.
        
        .PARAMETER screenFilePath
        The path of the screen file to save the modified content.
        
        .OUTPUTS
        string
            The modified screen content with colors removed.
    #>
    static [string] RemoveColors([string]$screenContent, [bool] $savefile, [string]$screenFilePath) {
        $obj = [PsColors]::new()
        $keys = $obj.color.Keys
        $keys = $keys.Clone()
        foreach ($key in $keys) {
            $value = $obj.color[$key]
            $screenContent = $screenContent -replace $value.wildcard , ""
            $screenContent = $screenContent.replace($value.unicode , "")
        }
        $screenContent = $screenContent -replace '\s+$', ''
        $screenContent += "`r`n" 
        if ($savefile) {
            $screenContent | Set-Content -Path $screenFilePath.Replace(".ascii", ".ascii_raw")
        }
        return $screenContent
    }
   
    <#
        .SYNOPSIS
        Displays the available colors.
        
        .DESCRIPTION
        This method displays the available colors by printing the color codes and their corresponding text.
    #>
    static ShowColors() {
        Get-PSReadLineOption

        $yEsc = [char]0x1b 
        
        Write-Host 'The following command should print “hello” in bright red underscore text:'
        Write-Host "$yEsc[91;4mHello$yEsc[0m"
        
        # ForEach ($code in 30..49) {
        #     Write-Host  ("{0}[{1}mEsc[{1}m{0}[0m  {0}[{1};1mEsc[{1};1m{0}[0m  {0}[{1};3mEsc[{1};3m{0}[0m  {0}[{1};4mEsc[{1};4m{0}[0m  {0}[{2}mEsc[{2}m{0}[0m" -f $Esc, $code, ($code + 60))
        # }
 
        # foreach ($code in 0..255) {  Write-Host ("{0}[38;5;{1}mESC[38;5;{1}m{0}[0m" -f $Esc, $code) }    
        # # ForEach ($code in 39.100) {
        # #     Write-Host  ("{0}[{1}mEsc[{1}m{0}[0m  {0}[{1};1mEsc[{1};1m{0}[0m  {0}[{1};3mEsc[{1};3m{0}[0m  {0}[{1};4mEsc[{1};4m{0}[0m  {0}[{2}mEsc[{2}m{0}[0m" -f $Esc, $code, ($code + 60))
        # # }

        ForEach ($code in 0..107) {
            Write-Host  ("$yEsc[{0}m test Esc[$($code)m  $yEsc[0m" -f $code)
        }
    }
}
