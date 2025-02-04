---
external help file: PnP.Wsl2-help.xml
Module Name: PnP.Wsl2
online version:
schema: 2.0.0
---

# Copy-PnPWsl2Instance

## SYNOPSIS
Copies a WSL 2 Instance to a new Instance.

## SYNTAX

```
Copy-PnPWsl2Instance [-Instance] <Object> -NewInstanceName <Object> [-Force]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
This function allows you to copy an existing WSL 2 Instance to a new Instance with a specified name.



## EXAMPLE 1
```
Copy-PnPWsl2Instance -Instance "Ubuntu-20.04" -NewInstanceName "MyUbuntu"
```

This example copies the "Ubuntu-20.04" Instance to a new instance named "MyUbuntu".



### -Instance
Specifies the name of the WSL 2 Instance to be copied.
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

### -NewInstanceName
Specifies the name of the new Instance to be created.
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
{{ Fill Force Description }}

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
