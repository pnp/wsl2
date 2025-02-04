---
external help file: PnP.Wsl2-help.xml
Module Name: PnP.Wsl2
online version:
schema: 2.0.0
---

# Get-PnPWsl2Configuration

## SYNOPSIS
Retrieves the configuration settings for PnPWsl2.

## SYNTAX

```
Get-PnPWsl2Configuration [-details] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
The Get-PnPWsl2Configuration function retrieves the configuration settings for PnPWsl2.
It displays basic information about the configuration, such as the PnPWsl2 root folder, WSL tools folder, and WSL images root folder.
If the -detailed switch parameter is specified, it also displays the replace parameters and used internal WSL functions.



## EXAMPLE 1
```
Get-PnPWsl2Configuration
Retrieves and displays the basic configuration information for PnPWsl2.
```

## EXAMPLE 2
```
Get-PnPWsl2Configuration -details
Retrieves and displays detailed configuration information for PnPWsl2, including replace parameters and WSL functions.
```



### -details
Specifies whether to display detailed information about the configuration.
If this switch parameter is specified, the replace parameters and WSL functions will be displayed.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
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







### System.Collections.Hashtable
