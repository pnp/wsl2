---
external help file: PnP.Wsl2-help.xml
Module Name: PnP.Wsl2
online version:
schema: 2.0.0
---

# Export-PnPWsl2Instance

## SYNOPSIS
Exports a WSL2 instance to a file.

## SYNTAX

```
Export-PnPWsl2Instance [-Instance] <Object> [-Type] <Object> [-ExportPath] <Object>
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
The \`Export-PnPWsl2Instance\` function exports a WSL2 instance to a file.
The type of the file can be either a tar file or a VHD file.

## EXAMPLES

### EXAMPLE 1
```
Export-PnPWsl2Instance -Instance "Ubuntu-20.04" -Type "TarFile" -ExportPath "/path/to/export"
```

This example exports the "Ubuntu-20.04" WSL2 instance to a tar file.

The export file will be saved in "/path/to/export".



### -Instance
The name of the WSL2 instance to export.
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

### -Type
The type of the export file.
It can be either "TarFile" or "VhdFile".
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

### -ExportPath
The path where the export file will be saved.
This parameter is mandatory.

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: True
Position: 3
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