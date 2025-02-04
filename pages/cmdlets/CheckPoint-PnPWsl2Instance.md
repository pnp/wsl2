---
external help file: PnP.Wsl2-help.xml
Module Name: PnP.Wsl2
online version:
schema: 2.0.0
---

# CheckPoint-PnPWsl2Instance

## SYNOPSIS
Creates a new checkpoint of a WSL2 instance.

## SYNTAX

```
CheckPoint-PnPWsl2Instance [-Instance] <Object> -CheckpointName <Object> [-Force]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
The CheckPoint-PnPWsl2Instance function creates a new checkpoint of a specified WSL2 instance.

## EXAMPLES

### EXAMPLE 1
```
CheckPoint-PnPWsl2Instance -Instance "Ubuntu-20.04" -CheckpointName "MyCheckpoint"
```

This command creates a new checkpoint of the "Ubuntu-20.04" WSL2 instance with the name "MyCheckpoint".
Checkpoints (vhdx) exist within the PnPWsl2/instance location under the "checkpoints" folder.



### -Instance
Specifies the WSL2 instance to checkpoint.
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

### -CheckpointName
Specifies the name of the checkpoint.
This parameter is mandatory.

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Force
If this switch is provided, it will not prompt for confirmation before creating the checkpoint.

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