## test if platyPS is installed
if (-not (Get-Command New-MarkdownHelp -ErrorAction SilentlyContinue)) {
    Install-Module -Name platyPS -Force -Scope CurrentUser
}
import-Module $PSScriptRoot\..\PnP.Wsl2.psd1

$folder = "$PSScriptRoot\.\documentation"
Remove-Item -Path $folder -Recurse -Force -ErrorAction SilentlyContinue
New-Item -ItemType Directory -Path $folder -Force
New-MarkdownHelp  -module "PnP.Wsl2" -OutputFolder $folder  -Force
New-ExternalHelp $folder  -OutputPath $folder -Force
$files = Get-ChildItem -Path $folder -Recurse -Include *.md

$finders = "## PARAMETERS;## INPUTS;## OUTPUTS;## NOTES;## RELATED LINKS;### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).".Split(";");
##cleanup the files

foreach ($f in $files) {
    $content = Get-Content -Path $f.FullName -Raw
    foreach ($find in $finders) {
        $content = $content.replace($find, '')

    }
    Set-Content -Path $f.FullName -Value $content.Trim() -NoNewline
}


foreach ($f in $files) {
    $content = Get-Content -Path $f.FullName
    $ct=0
    $pCt=1
    foreach ($line in $content) {
        $line
        if ($line -eq '```') {
            $pCt++
        }
        # if ((($pCt % 2) -eq 0) -and ($line -eq '```')) {	
        #     $content[$ct] = '```powershell'
        #     $pCt+=2
        # }
      $ct++
    }
    Set-Content -Path $f.FullName -Value ($content -join "`n") -NoNewline
    $a=""
    #Set-Content -Path $f.FullName -Value $content.Trim() -NoNewline
}


