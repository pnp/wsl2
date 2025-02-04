---
external help file: PnP.Wsl2-help.xml
Module Name: PnP.Wsl2
online version:
schema: 2.0.0
---

# Restore-PnPWsl2Instance

## SYNOPSIS
Restores a PnP WSL2 instance from a checkpoint.

## SYNTAX

```
Restore-PnPWsl2Instance [-Instance] <Object> [-Force] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
The Restore-PnPWsl2Instance cmdlet restores a specified PnP WSL2 instance from a checkpoint.
It requires the name of the instance and the checkpoint as mandatory parameters.
The cmdlet validates the instance name and the checkpoint before attempting to restore.
If the instance name or the checkpoint is invalid, it throws an error.
If the -Force switch is not provided, it prompts for confirmation before restoring the instance.

## EXAMPLES

### EXAMPLE 1
```
# Restore a PnP WSL2 instance named "MyInstance" from a checkpoint named "MyCheckpoint"
Restore-PnPWsl2Instance -Instance "MyInstance" -CheckPoint "MyCheckpoint"
```

### EXAMPLE 2
```
# Restore a PnP WSL2 instance named "MyInstance" from a checkpoint named "MyCheckpoint" without prompting for confirmation
Restore-PnPWsl2Instance -Instance "MyInstance" -CheckPoint "MyCheckpoint" -Force
```



### -Instance
The name of the PnP WSL2 instance to restore.
This parameter is mandatory and does not accept pipeline input.
The cmdlet validates the instance name using the ValidateWslLocalInstance function.

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

### -Force
If this switch is provided, the cmdlet does not prompt for confirmation before restoring the instance.

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