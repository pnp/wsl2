---
external help file: PnP.Wsl2-help.xml
Module Name: PnP.Wsl2
online version:
schema: 2.0.0
---

# Get-PnPWsl2Distributions

## SYNOPSIS
Retrieves the WSL2 distributions.

## SYNTAX

```
Get-PnPWsl2Distributions [[-instanceName] <String>] [<CommonParameters>]
```

## DESCRIPTION
This function retrieves the WSL2 distributions based on the specified parameters.



## EXAMPLE 1
```
Get-PnPWsl2Distributions 
Retrieves all online WSL2 distributions.
```

## EXAMPLE 2
```
Get-PnPWsl2Distributions -instanceName "Ubuntu-20.04"
Retrieves the WSL2 distribution with the specified instance name.
```



### -instanceName
Specifies the name of the WSL2 instance.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

