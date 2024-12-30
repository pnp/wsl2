Set-StrictMode -Version 3
$ErrorActionPreference = "Stop"
Set-Location -Path "$PSScriptRoot\.."
$path = (Resolve-Path -Path "$PSScriptRoot").path

# copy documentation to output folder
Write-Host "1. Copying documentation files to page cmdlets"
Copy-Item -Path "$path/documentation/*.md" -Destination "$path/../pages/cmdlets" -Force


# Generate cmdlet toc
Write-Host "2. Generating cmdlet toc"
$cmdletPages = Get-ChildItem -Path "$path/../pages/cmdlets/*.md" -Exclude "index.md" | Sort-Object -Property Name
$toc = ""
foreach ($cmdletPage in $cmdletPages) {
    $toc = $toc + "- name: $($cmdletPage.BaseName)`n  href: $($cmdletPage.Name)`n"
}
$toc | Out-File "$path/../pages/cmdlets/toc.yml" -Force

# Generate cmdlet index page

Write-Host "3. Generating cmdlet indexpages"
$cmdletIndexPageContent = Get-Content -Path "$path/templates/cmdlet-index.template" -Raw
$cmdletIndexPageContent = $cmdletIndexPageContent.Replace("%%cmdletcount%%", $cmdletPages.Length)

$cmdletIndexPageList = ""
$previousCmdletVerb = ""
foreach ($cmdletPage in $cmdletPages)
{

    # Define the verb of the cmdlet
    if($cmdletPage.BaseName.Contains("-"))
    {
        $cmdletVerb = $cmdletPage.BaseName.Remove($cmdletPage.BaseName.IndexOf("-"))

        if($cmdletVerb -ne $previousCmdletVerb)
        {
            # Add a new heading for the new verb
            $cmdletIndexPageList += "## $($cmdletVerb)`n"
        }
        $previousCmdletVerb = $cmdletVerb
    }
    else
    {
        $cmdletVerb = ""
    }

    # Add a new entry for the verb
    $cmdletIndexPageList += "- [$($cmdletPage.BaseName)]($($cmdletPage.Name))"
    $cmdletIndexPageList = $cmdletIndexPageList + "`n"
}

$cmdletIndexPageContent = $cmdletIndexPageContent.Replace("%%cmdletlisting%%", $cmdletIndexPageList)
$cmdletIndexPageContent | Out-File "$path/../pages/cmdlets/index.md" -Force

# Generate candy index page

Write-Host "4. Generating candy index page"
# $cmdletIndexPageContent = Get-Content -Path "$path/templates/cmdlet-index.template" -Raw
# $cmdletIndexPageContent = $cmdletIndexPageContent.Replace("%%cmdletcount%%", $cmdletPages.Length)
# $cmdletIndexPageList = ""
# $previousCmdletVerb = ""

function ParseElements($file)
{
    $item= Get-Item -Path $file
    $name="{0}-{1}-{2}" -f $item.directory.parent.name.Substring(0, 2), `
    $item.directory.name, [System.IO.Path]::GetFileNameWithoutExtension($item.Name)

    $scriptContent = Get-Content -Path $file -Raw
    $modNamePattern = 'modName="(.*)"'
    $modSectionPattern = 'modSection="(.*)"'
    $helpMessagePattern = 'HELP_MESSAGE="(.*)"'
    $helpMessageLongPattern = 'HELP_MESSAGE_LONG="(.*)"'
    $helpMessageLongPattern2 =  'HELP_MESSAGE_LONG="([\s\S]*?)"\r?\n'

    $modName = [regex]::Match($scriptContent, $modNamePattern).Groups[1].Value.Trim()
    $modSection = [regex]::Match($scriptContent, $modSectionPattern).Groups[1].Value.Trim()
    $helpMessage = [regex]::Match($scriptContent, $helpMessagePattern).Groups[1].Value.Trim()
    $helpMessageLong = [regex]::Match($scriptContent, $helpMessageLongPattern).Groups[1].Value.Trim() -join "`n"

    if ($helpMessageLong -eq "")
    {
        $helpMessageLong = [regex]::Match($scriptContent, $helpMessageLongPattern2).Groups[1].Value.Trim() -join "`n"
    }
    ##create psobject
    $obj = New-Object PSObject
    $obj | Add-Member -MemberType NoteProperty -Name "Name" -Value $name
    $obj | Add-Member -MemberType NoteProperty -Name "modName" -Value $modName
    $obj | Add-Member -MemberType NoteProperty -Name "modSection" -Value $modSection
    $obj | Add-Member -MemberType NoteProperty -Name "HELP_MESSAGE" -Value $helpMessage.replace("\n","\")
    $obj | Add-Member -MemberType NoteProperty -Name "HELP_MESSAGE_LONG" -Value $helpMessageLong.replace("\n","`n")

    #exception for "m365"
    $obj.modName = $obj.modName.Replace("m365", "M365")
    #exception for "pwsh"
    $obj.modName = $obj.modName.Replace("pwsh", "PowerShell")
    #exception for "SPFX"
    $obj.modName = $obj.modName.Replace("SPFX", "SharePoint Framework")
    #exception for "SYS"
    $obj.modName = $obj.modName.Replace("SYS", "System")
    return $obj
}
$allCandy = Get-ChildItem -Path "$path/../public/mods/*.sh" -Exclude "alias.sh","core.sh","init.sh" -Recurse | Sort-Object -Property FullName

$candyIndexPageList=@()
$previousModName = ""
$ctCandy=0;
$myScripts = @()
foreach ($candy in $allCandy)
{
    $elem= ParseElements($candy.FullName)
    # Write-Host "- $($elem.modSection)"

    # Define the verb of the cmdlet
        $modName = $elem.modName
        if ($modName -eq "myscripts")
        {
            # $myScripts += "### $($modName)`n"
            # Add a new entry for the verb
            $myScripts += "- #### 🍭$($elem.Name)"
            $myScripts += "  $($elem.HELP_MESSAGE_LONG)"
            $myScripts += ' ```powershell'
            $myScripts += "   Add-PnPWsl2Candy -Candy $($elem.Name) -Instance myinstance"
            $myScripts += ' ```'
        }
        else {
            if($modName -ne $previousModName)
            {
                # Add a new heading for the new verb
                $candyIndexPageList += "### $($modName)"
            }
                $previousModName = $modName
                # Add a new entry for the verb
                $candyIndexPageList += "- #### 🍭$($elem.Name)"
                $candyIndexPageList += "  $($elem.HELP_MESSAGE_LONG)"
                $candyIndexPageList += ' ```powershell'
                $candyIndexPageList += "   Add-PnPWsl2Candy -Candy $($elem.Name) -Instance myinstance"
                $candyIndexPageList += ' ```'
            }
    $ctCandy++
    $candyIndexPageList += "`n"
}
$myScripts = "### MyScripts`n" + ($myScripts -join "`n")
$candyIndexPageList = ($candyIndexPageList -join "`n") + $myScripts
$candyIndexPageContent = Get-Content -Path "$path/templates/candy-index.template" -Raw
$candyIndexPageContent = $candyIndexPageContent -f $ctCandy,$candyIndexPageList

$candyIndexPageContent | Out-File "$path/../pages/candy/index.md" -Force

Write-Host "5. Cleaning up"
## Clean up
## get all documentation files remove ## EXAMPLES string
$docFiles = Get-ChildItem -Path "$path/documentation" -Recurse -Include *.md
foreach ($docFile in $docFiles) {
    $content = Get-Content -Path $docFile.FullName -Raw
    $content = $content.Replace("## EXAMPLES", "")
    $content = $content.Replace("### EXAMPLE", "## EXAMPLE")
    Set-Content -Path $docFile.FullName -Value $content -Force
}
Write-Host "6. DocFx build"
## detect if docfx is installed
if (-not (Get-Command docfx -ErrorAction SilentlyContinue)) {
    Write-Host "DocFx is not installed. Installing DocFx"
    dotnet tool update -g docfx
}
docfx build -t default,templates/material "$path/../pages/docfx.json"
$docsFolder=  "$path/../docs"
New-Item -ItemType Directory -Force -Path $docsFolder
Write-Host "7. Copy All to docs"
$docsPath= (Resolve-Path -Path  $docsFolder).path
Copy-Item -Path "$path/../pages/_site/*" -Destination $docsFolder -Force -Recurse
Remove-Item -Path "$path/../pages/_site" -Force -Recurse
Write-Host "docsPath:$docsPath"
Set-Location $docsPath
ls
Write-Host "done!"
Set-Location -Path "$PSScriptRoot"
## to be use for local testing
##docfx -t default,templates/material "$path/../pages/docfx.json"  --serve