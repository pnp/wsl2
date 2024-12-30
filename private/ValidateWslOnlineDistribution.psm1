using namespace System.Management.Automation
using module ..\private\PnPWsl2Helpers.psm1

<#
    .SYNOPSIS
    Generates valid values for WSL online distributions.

    .DESCRIPTION
    This class implements the IValidateSetValuesGenerator interface to generate valid values for WSL online distributions.

    .NOTES
    The GetValidValues method retrieves a list of WSL online distributions using the Get-WSL2Distributions cmdlet.

    #>
class ValidateWslOnlineDistribution : IValidateSetValuesGenerator {


    [string[]] GetValidValues() {
        $list = Get-WSL2Distributions -online $true
        return $list.Name
    }
}
