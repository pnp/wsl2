# Change Log

All notable changes to this module will be documented in this file.

## 1.1.7
- Initial release
## 1.1.8
- General change regarding StrictMode from latest to version 3
- General cleanup and improvement on scripts\bashfiles\cmdlets
- Added current version to the initial screen
- Changed CheckPoint-PnPWsl2Instance + Export-PnPWsl2Instance cmdlets where OOB vhdx export doesnt work if an instance is active therefore vhdx checkpoints\exports are a copy of the instance file with a new name.
- Improved Parameter ValidateSet on the Remove-PnPWsl2Instance cmdlet
- Improved AddSSHKeySelinium script ( used to add SSHKeys)  to be more broader
- Improved gulp-TrustDevCert.sh
