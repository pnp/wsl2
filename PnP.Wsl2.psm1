# Importing required modules
using module ./private/PnPWsl2Helpers.psm1
using module ./private/PSScreens.psm1

Set-StrictMode -Version 3.0
## Telemetry send module loaded + version

# get current module version loading pnp.wsl.psd1
# Import the .psd1 file
$moduleData = Import-PowerShellDataFile -Path $PSScriptRoot/PnP.Wsl2.psd1
# Get the module version
$env:PRODUCT_NAME = "PnP.Wsl2"
$env:PNPWSL2_VERSION = $moduleData.ModuleVersion
$env:PNPWSL2_APPI_ENDPOINT= $moduleData.PrivateData.Constants.AppInsightsIngestionEndpoint
$env:PNPWSL2_APPI_INSTRKEY =  $moduleData.PrivateData.Constants.AppInsightsInstrumentationKey
$env:PNPWSL2_TELEMETRY_INSTANCE = ([guid]::NewGuid().ToString("N"))
$env:PNPWSL2_TELEMETRY_ISON = $true
Send-PnPWsl2TrackEventTelemetry -EventName "Import-Module" 
# Get and private function definition files
$public = @(Get-ChildItem -Path "$PSScriptRoot\Public\*.ps1" -Exclude "*.Tests.*" -ErrorAction SilentlyContinue)
# Importing all functions
foreach ($import in $public) {
    try {
        Write-Verbose "Importing $($import.FullName)..."
        . $import.FullName
    }
    catch {
        Write-Error "Failed to import function $($import.FullName): $_"
    }
}
Initialize-ModuleConfiguration 

Export-ModuleMember -Function $public.BaseName

# SIG # Begin signature block
# MIIFkgYJKoZIhvcNAQcCoIIFgzCCBX8CAQExDzANBglghkgBZQMEAgEFADB5Bgor
# BgEEAYI3AgEEoGswaTA0BgorBgEEAYI3AgEeMCYCAwEAAAQQH8w7YFlLCE63JNLG
# KX7zUQIBAAIBAAIBAAIBAAIBADAxMA0GCWCGSAFlAwQCAQUABCAz6ddZ8sQSLiiB
# xxvGK6WtWIIGSpRWmPORkutpvGWlU6CCAw8wggMLMIIB86ADAgECAhAVxkIxeBJ4
# t0V4EHgxM2DoMA0GCSqGSIb3DQEBBQUAMBMxETAPBgNVBAMMCFBuUC5Xc2wyMB4X
# DTI0MDMwNjAyMzcxNloXDTI1MDMwNjAyNTcxNlowEzERMA8GA1UEAwwIUG5QLldz
# bDIwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQCjHaRVBXr7lzZwCh91
# RzpuU4jN7vFOlxuohUE9zq0pchbYRbLoFF55q37xM5y1AU078gllQRFMFXq2GPqt
# VIRYCUuJhtHT6RLqvbhymM0jauU9zMFAg0SdyB4aLoJAaSMg30N1alobCI9Lfmzi
# W1P0pMvGoHv2wtim8t49eTvu7/P9nUmuz3+b1MHSz2svzL1wyBGaWm7AxnAsczzt
# FKN3XVKBEcSd4EA0xItF3Tq2Q72uzCYU9R2MDJ6/Y5HQYPMM5hujvIYr5nQd0i5q
# YjA1G97kI5ODJSzb+blWfbV9vvMLr953EjU+ZRUg8Ngs3nm/gHSIhBKmNfDZt4Os
# 7K7JAgMBAAGjWzBZMA4GA1UdDwEB/wQEAwIHgDATBgNVHSUEDDAKBggrBgEFBQcD
# AzATBgNVHREEDDAKgghQblAuV3NsMjAdBgNVHQ4EFgQUtdtaPpYKnkxw9SUxZCkC
# Fqad33EwDQYJKoZIhvcNAQEFBQADggEBAHACMWCbbjQvx71CO9eANmT8rQFzffEX
# gW/bdTtpGMFh4Fka6BOL+6y7fAvatzon2yBBluTrorBmQqR37u3WgY4v+OCrEphn
# uPuEKp2KdR4WKKdatlRrL5zYR5IXFW29oHhWQlxwcm5cGE0nx94i1FCBlOwJWA/u
# QqeoGemSedPeItMkHCTYfXOjiYP6ZtiFq6jMaSoAGE7F5hn4Dk7htAWP5EWBO2Cs
# PaZ2AnOCLyXuPGj8gwvTeoZDetmpBkuszdHV1l0/nDft5iU6jm0e1zxskAGfJDHM
# 3ndKL1xxg7+aMPkpujJK1XyxzS4qULPm11iVntJSVsXIZYWvsMvkrwIxggHZMIIB
# 1QIBATAnMBMxETAPBgNVBAMMCFBuUC5Xc2wyAhAVxkIxeBJ4t0V4EHgxM2DoMA0G
# CWCGSAFlAwQCAQUAoIGEMBgGCisGAQQBgjcCAQwxCjAIoAKAAKECgAAwGQYJKoZI
# hvcNAQkDMQwGCisGAQQBgjcCAQQwHAYKKwYBBAGCNwIBCzEOMAwGCisGAQQBgjcC
# ARUwLwYJKoZIhvcNAQkEMSIEIL0NiiwfW07C2V6UTDTVfdu/XuAjh975NTUFHTSv
# tnbmMA0GCSqGSIb3DQEBAQUABIIBABnH/qSapNIhNXdOaRnYU10zTMwDiR6qo7Cf
# ZKn+keZojEHwteyyR+3Nkurhsnjmo5eWYQdzKevYjHQO/2oi3z2c5AIYcpnQpFpg
# gCQHVOwgmSgBhbhUoPSDDiVCF2F1wPZ3NmKUcBWlYy/0voSSnw/lLRFv9VLXvdXI
# eOsk4VNm6AbpnEGINit7tNSSjomIwcIBX0vU0rKnsEBdXq6FlPeb9xAXrdgAFeEn
# QupYsq7V6/dAQUWORUAxUFXkEPvxQkTTPsvliFiv2NbSZtUcXa3M7nZJA+Ot0OAu
# cArORCYGP73E5dLIokgeMXCOeq7zqTJD/l1zpN0iVAc31reMMS8=
# SIG # End signature block
