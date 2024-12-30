param(
    [string]$certPath
)
Write-Log "Exporting-DevCert Start ..`n"
$certStore = "Cert:\LocalMachine\Root"
Import-Certificate -FilePath $certPath -CertStoreLocation $certStore
Write-Log "`nExporting-DevCert End .."
Write-Log "`nDev Certificated imported to your host ! `n"
Write-Log "Press [Enter] to continue"
Read-Host 