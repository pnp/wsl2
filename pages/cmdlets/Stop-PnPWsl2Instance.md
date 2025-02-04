---
external help file: PnP.Wsl2-help.xml
Module Name: PnP.Wsl2
online version:
schema: 2.0.0
---

# Stop-PnPWsl2Instance

## SYNOPSIS
Stops a WSL2 instance.

## SYNTAX

```
Stop-PnPWsl2Instance [-Instance] <Object> [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## DESCRIPTION
The Stop-PnPWsl2Instance cmdlet stops a running WSL2 instance.
The instance to stop is specified by the Instance parameter.

## EXAMPLES

### EXAMPLE 1
```
Stop-PnPWsl2Instance -Instance "MyInstance"
```

This command stops the WSL2 instance named "MyInstance".



### -Instance
Specifies the instance to stop.
This parameter is mandatory and accepts only valid WSL2 instance names.

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

### -WhatIf
Shows what would happen if the cmdlet runs.
The cmdlet is not run.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: wi

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Confirm
Prompts you for confirmation before running the cmdlet.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: cf

Required: False
Position: Named
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