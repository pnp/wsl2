param(
    [string]$certPath
)
$certPath = $certPath.Replace("\","\\")
$certPath = (Get-Item -Path $certPath).FullName

#Start-Process pwsh.exe -ArgumentList @("-Command","Read-Host -Prompt 'Press Enter to continue99 ->$parm<-'")
#pwsh.exe -File "$windows_path\\..\\az\\SSHKeyAdd\\AddSSHKeySelinium.ps1" -organization "$devopsOrg" -sshaKeyName "$devopsTokenName" -sshaKeyContent "$ssh_key"
Start-Process pwsh.exe -ArgumentList @("-File","$PSScriptRoot\Export-DevCert.ps1","-certPath","$certPath")

