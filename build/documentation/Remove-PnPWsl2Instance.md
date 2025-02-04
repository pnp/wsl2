---
external help file: PnP.Wsl2-help.xml
Module Name: PnP.Wsl2
online version:
schema: 2.0.0
---

# Remove-PnPWsl2Instance

## SYNOPSIS
Removes a PnP WSL2 instance.

## SYNTAX

```
Remove-PnPWsl2Instance [-Instance] <Object> [-Force] [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## DESCRIPTION
The Remove-PnPWsl2Instance cmdlet removes a specified PnP WSL2 instance.
It requires the name of the instance as a mandatory parameter.
The cmdlet validates the instance name before attempting to remove it.
If the -Force switch is not provided, it prompts for confirmation before removing the instance.



## EXAMPLE 1
```
# Remove a PnP WSL2 instance named "MyInstance"
Remove-PnPWsl2Instance -Instance "MyInstance"
```

## EXAMPLE 2
```
# Remove a PnP WSL2 instance named "MyInstance" without prompting for confirmation
Remove-PnPWsl2Instance -Instance "MyInstance" -Force
```



### -Instance
The name of the PnP WSL2 instance to remove.
This parameter is mandatory and accepts pipeline input.

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

### -Force
If this switch is provided, the cmdlet does not prompt for confirmation before removing the instance.

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







### System.String
