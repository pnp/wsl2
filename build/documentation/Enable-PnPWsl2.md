---
external help file: PnP.Wsl2-help.xml
Module Name: PnP.Wsl2
online version:
schema: 2.0.0
---

# Enable-PnPWsl2

## SYNOPSIS
Enables the necessary features for running the Windows Subsystem for Linux 2 (WSL2).

## SYNTAX

```
Enable-PnPWsl2 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
The Enable-PnPWsl2 function enables the required features for running WSL2.
It checks if the cmdlet is running with administrator privileges and then enables the 'Microsoft-Windows-Subsystem-Linux' and 'VirtualMachinePlatform' features.
Finally, it restarts the computer to apply the changes.



## EXAMPLE 1
```
Enable-PnPWsl2
```



### -ProgressAction
{{ Fill ProgressAction Description }}

```yaml
Type: ActionPreference
Parameter Sets: (All)
Aliases: proga

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```
