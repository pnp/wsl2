---
external help file: PnP.Wsl2-help.xml
Module Name: PnP.Wsl2
online version:
schema: 2.0.0
---

# Start-PnPWsl2

## SYNOPSIS
Start a WSL instance

## SYNTAX

```
Start-PnPWsl2 [-Instance] <Object> [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
The Start-PnPWsl2 function starts a WSL instance.



## EXAMPLE 1
```
Start-PnPWsl2 -Instance "Ubuntu-20.04"
```

Starts the specified WSL Instance.



### -Instance
Specifies the WSL Instance to start.
This parameter is mandatory.

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: True
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


































