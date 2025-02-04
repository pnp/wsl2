---
external help file: PnP.Wsl2-help.xml
Module Name: PnP.Wsl2
online version:
schema: 2.0.0
---

# Get-PnPWsl2Distribution

## SYNOPSIS
Retrieves the WSL2 distributions.

## SYNTAX

```
Get-PnPWsl2Distribution [[-instanceName] <String>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
This function retrieves the WSL2 distributions based on the specified parameters.

## EXAMPLES

### EXAMPLE 1
```
Get-PnPWsl2Distribution
Retrieves all online WSL2 distributions.
```

### EXAMPLE 2
```
Get-PnPWsl2Distribution -instanceName "Ubuntu-20.04"
Retrieves the WSL2 distribution with the specified instance name.
```



### -instanceName
Specifies the name of the WSL2 instance.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
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