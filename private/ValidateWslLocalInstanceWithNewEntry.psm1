using namespace System.Management.Automation
using module ..\private\PnPWsl2Helpers.psm1
<#
    .SYNOPSIS
    Generates valid values for WSL local instances.

    .DESCRIPTION
    This class implements the IValidateSetValuesGenerator interface to generate valid values for WSL local instances.

    .NOTES
    The GetValidValues method retrieves a list of WSL local instances using the Get-WSL2Distributions cmdlet.

    #>
class ValidateWslLocalInstanceWithNewEntry : IValidateSetValuesGenerator {
    [string[]] GetValidValues() {
        $list =@(Get-WSL2Distributions -online $false)
        $list+= [PSCustomObject]@{ Name = '<NEW INSTANCE>';  }
        if ($null -eq $list ) {
            return $null
        }
        return $list.Name
    }
}
