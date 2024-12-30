using namespace System.Management.Automation
using module .\PSColors.psm1

<#
.SYNOPSIS
    PsScreens class provides functions to display screens in PowerShell.

.DESCRIPTION
    PsScreens class contains static functions to display screens in PowerShell. It includes functions to show the main screen and small screen with customizable title and description.

#>
<#
.SYNOPSIS
PsScreens class provides functions to display screens with formatted content.

.DESCRIPTION
The PsScreens class provides functions to display screens with formatted content. It includes methods to show a main screen and a small screen, which can be used to present information in a visually appealing way.

.NOTES
This class relies on the PsColors class to apply colors to the screen content. It assumes that the screen templates are stored in environment variables: $ENV:PNPWSL2_SCREEN_MAIN and $ENV:PNPWSL2_SCREEN_SMALL.

.EXAMPLE
$mainScreen = [PsScreens]::ShowMainScreen("Welcome to My App")
Displays the main screen with the provided label "Welcome to My App".

$smallScreen = [PsScreens]::ShowSmallScreen("Title", "This is a sample description")
Displays the small screen with the provided title "Title" and description "This is a sample description".
#>
class PsScreens {
        
    static [string] ShowMainScreen($label) {
        $screen= [PsColors]::ApplyColors((Get-Content -path "$ENV:PNPWSL2_SCREEN_MAIN" -Raw ) + $label)
        Write-Host $screen
        return $screen
    }

    <#
    .SYNOPSIS
        ShowSmallScreen function displays a small screen with a title and description.

    .DESCRIPTION
        ShowSmallScreen function reads the content of the small screen template file, replaces the placeholders with the provided title and description, applies colors, and displays the screen.

    .PARAMETER title
        The title to be displayed on the small screen.

    .PARAMETER description
        The description to be displayed on the small screen.

    .EXAMPLE
        ShowSmallScreen -title "Welcome" -description "This is a sample description"

    #>
    static [string] ShowSmallScreen($title,$description) {
        $screen= [PsColors]::ApplyColors((Get-Content -path "$ENV:PNPWSL2_SCREEN_SMALL" -Raw ))
        $screen = $screen -replace "{TITLE}" , $title
        $screen = $screen -replace "{DESCRIPTION}" , $description
        Write-Host $screen
        return $screen
    }
}