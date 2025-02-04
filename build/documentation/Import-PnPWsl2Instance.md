---
external help file: PnP.Wsl2-help.xml
Module Name: PnP.Wsl2
online version:
schema: 2.0.0
---

# Import-PnPWsl2Instance

## SYNOPSIS
Imports a WSL2 Instance from a tar file (zip file).

## SYNTAX

```
Import-PnPWsl2Instance -InstanceFile <Object> [-Instance] <Object> [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

## DESCRIPTION
The Import-PnPWsl2Instance function imports a WSL2 Instance from a tar file (zip file) and creates a new Instance with the specified name.



## EXAMPLE 1
```
Import-PnPWsl2Instance -InstanceFile "C:\path\to\Instance.tar" -Instance "MyInstance"
Imports the WSL2 Instance from the specified tar file (zip file) and creates a new Instance named "MyInstance".
```



### -InstanceFile
The path to the Instance file
File can be either a tar file or a VHD file.

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

### -Instance
The name of the new Instance.

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
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
