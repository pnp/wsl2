---
external help file: PnP.Wsl2-help.xml
Module Name: PnP.Wsl2
online version:
schema: 2.0.0
---

# Add-PnPWsl2Candy

## SYNOPSIS
Installs a WSL PnPCandy\tool.

## SYNTAX

```
Add-PnPWsl2Candy [-Instance] <Object> [-Candy] <Object> [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

## DESCRIPTION
The Add-PnPWsl2Candy function installs WSL tools (Candy) by executing the specified scripts.

## EXAMPLES

### EXAMPLE 1
```
Add-PnPWsl2Candy -Instance "Ubuntu-20.04" -Candy "PowerShell"
```

Installs PowerShell on the specified WSL Instance .



### -Instance
Specifies the WSL Instance to install the pnpcandy on.
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

### -Candy
Specifies the Candy\tool to install.
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