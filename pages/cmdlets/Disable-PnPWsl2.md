---
external help file: PnP.Wsl2-help.xml
Module Name: PnP.Wsl2
online version:
schema: 2.0.0
---

# Disable-PnPWsl2

## SYNOPSIS
Disables the Windows features 'VirtualMachinePlatform' and 'Microsoft-Windows-Subsystem-Linux'.

## SYNTAX

```
Disable-PnPWsl2 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
The Disable-PnPWsl2 function disables the Windows features 'VirtualMachinePlatform' and 'Microsoft-Windows-Subsystem-Linux'.
It prompts the user for confirmation before disabling the features and also checks if the cmdlet is being run as an administrator.
After disabling the features, it prompts the user to restart the machine.

## EXAMPLES

### EXAMPLE 1
```
Disable-PnPWsl2
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