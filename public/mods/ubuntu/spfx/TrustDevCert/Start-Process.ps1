param(
    [string]$certPath
)
$certPath = $certPath.Replace("\","\\")
$certPath = (Get-Item -Path $certPath).FullName

$certStore = "Cert:\CurrentUser\Root"
Import-Certificate -FilePath $certPath -CertStoreLocation $certStore
