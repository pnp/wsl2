---
external help file: PnP.Wsl2-help.xml
Module Name: PnP.Wsl2
online version:
schema: 2.0.0
---

# Add-PnPWsl2Instance

## SYNOPSIS
Adds a new WSL2 instance.

## SYNTAX

```
Add-PnPWsl2Instance [-Distribution] <Object> [-InstanceName] <Object> [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

## DESCRIPTION
The Add-PnPWsl2Instance adds a new WSL2 instance with a specified distribution.
Behind the scenes, it creates a folder in PnPWsl2/instances with the  instance name and will export a backup of the current instance in the PnPWsl2/images folder

## EXAMPLES

### EXAMPLE 1
```
Add-PnPWsl2Instance -Distribution "Ubuntu-20.04" -InstanceName "MyInstance"
```

This command adds a new WSL2 instance named "MyInstance" with the "Ubuntu-20.04" distribution.



### -Distribution
Specifies the distribution for the new WSL2 instance.
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

### -InstanceName
Specifies the name for the new WSL2 instance.
This parameter is mandatory.

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
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