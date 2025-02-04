---
external help file: PnP.Wsl2-help.xml
Module Name: PnP.Wsl2
online version:
schema: 2.0.0
---

# Get-PnPWsl2CheckPoint

## SYNOPSIS
Retrieves a list of checkpoints of a WSL2 instance.

## SYNTAX

```
Get-PnPWsl2CheckPoint [-Instance] <Object> [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
The Get-PnPWsl2CheckPoint function retrieves the checkpoints of a specified WSL2 instance.



## EXAMPLE 1
```
Get-PnPWsl2CheckPoint -Instance "Ubuntu-20.04"
```

This command retrieves a list of checkpoints of the "Ubuntu-20.04" WSL2 instance.



### -Instance
Specifies the WSL2 instance to get the checkpoints from.
This parameter is mandatory.

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByValue)
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
