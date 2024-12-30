using namespace System.Management.Automation
using module ..\private\PnPWsl2Helpers.psm1

class ValidateWslLocalCheckPoint : IValidateSetValuesGenerator {
    [string]$Instance
    ## constructor
    ValidateWslLocalCheckPoint([string]$Instance) {
        $this.Instance = $Instance
    }
    [PSObject] GetAllValues() {
        ## get all filenames in mods folder
        $config = Get-ModuleConfiguration
        $currentImagesFolder = "$($config.PnPWsl2RootFolder)\instances\$($this.Instance)"
        $chkPs = @( Get-ChildItem -Path $currentImagesFolder -Recurse -File -Filter "*_snap.vhdx" | `
                Where-Object {$_.FullName -like '*\checkpoints\*'} | `
                Select-Object  `
            @{name = 'Instance'; expression = { $this.Instance} }, `
            @{name = 'Name'; expression = { [System.IO.Path]::GetFileNameWithoutExtension($_.Name) } }, `
            @{name = 'FullPath'; expression = { $_.FullName.ToLower().replace("\", "\\") } }
        )

        return $chkPs
    }
    [string[]] GetValidValues() {

        if ($this.GetAllValues().Count -eq 0) {
            return "empty"
        }
        return ($this.GetAllValues()).Name
    }
}
