---
external help file: PnP.Wsl2-help.xml
Module Name: PnP.Wsl2
online version:
schema: 2.0.0
---

# Invoke-PnPWsl2Script

## SYNOPSIS
Invokes a Bash script in a WSL 2 Instance.

## SYNTAX

```
Invoke-PnPWsl2Script [-ScriptPath] <Object> [-Instance] <Object> [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

## DESCRIPTION
The Invoke-PnPWsl2Script function is used to execute a Bash script in a WSL 2 Instance.
It takes the script base name and the target WSL 2 Instance as mandatory parameters.



## EXAMPLE 1
```
Invoke-PnPWsl2Script -scriptBaseName "MyScript.sh" -Instance "Ubuntu-20.04"
```

This example invokes the Bash script named "MyScript.sh" in the "Ubuntu-20.04" WSL 2 Instance.



### -ScriptPath
The Bash script path to be executed.

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

### -Instance
The target WSL 2 Instance where the script will be executed.
Use the ValidateWslLocalInstance argument completer to provide valid Instance names.

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
