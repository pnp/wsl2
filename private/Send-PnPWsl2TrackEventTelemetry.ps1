#Telemetry

<#
.SYNOPSIS
Sends a custom event telemetry to Application Insights.

.DESCRIPTION
The Send-PnPWsl2TrackEventTelemetry function sends a custom event telemetry to Application Insights. 
It uses the Application Insights ingestion endpoint and instrumentation key from environment variables. 
It accepts an event name and a hashtable of custom properties as parameters. 
The function prepares a REST request body and sends it to the ingestion endpoint.

.PARAMETER EventName
Specifies the name of the custom event. This parameter is mandatory.

.PARAMETER CustomProperties
Specifies a hashtable of custom properties for the event. This parameter is optional.

.EXAMPLE
Send-PnPWsl2TrackEventTelemetry -EventName "MyEvent" -CustomProperties @{ "Property1" = "Value1"; "Property2" = "Value2" }

This command sends a custom event named "MyEvent" with two custom properties to Application Insights.

.NOTES
The function uses the Invoke-RestMethod cmdlet to send the REST request. 
The function uses the ConvertTo-JSON cmdlet to convert the request body to JSON. 
The function uses the $env:PNPWSL2_APPI_ENDPOINT and $env:PNPWSL2_APPI_INSTRKEY environment variables to get the ingestion endpoint and instrumentation key.
#>
function Send-PnPWsl2TrackEventTelemetry
{
   
    [CmdletBinding()]
    Param
    (
		[Parameter(
            Mandatory=$true,
            HelpMessage='Specify the name of the custom event.')]
		[System.String]
		[ValidateNotNullOrEmpty()]
		$EventName,
		[Parameter(Mandatory=$false)]
		[Hashtable]
		$CustomProperties
    )
    Begin{
		
		# if telemetry is off, do not send telemetry
		if ($env:PNPWSL2_DISABLETELEMETRY -eq $true)
		{
			return
		}
        $currentErrorActionPreference = $ErrorActionPreference
		if ($env:PNPWSL2_DEBUG -eq 1)
		{
        	$ErrorActionPreference = "Stop"
		}
		else {
			$ErrorActionPreference = "SilientlyContinue"
		}
    }
    Process
    {
		## always add custom properties that will have instance running
		if ($PSBoundParameters.ContainsKey('CustomProperties') -and $CustomProperties.Count -gt 0)
		{
			$customPropertiesObj = [PSCustomObject]$CustomProperties;
		}
		else
		{
			$customPropertiesObj = [PSCustomObject]@{};
		}

		$customPropertiesObj | Add-Member -MemberType NoteProperty -Name "ProdUID" -Value $env:PNPWSL2_TELEMETRY_INSTANCE
		$customPropertiesObj | Add-Member -MemberType NoteProperty -Name "ProdName" -Value $env:PRODUCT_NAME
		$customPropertiesObj | Add-Member -MemberType NoteProperty -Name "ProdVersion" -Value $env:PNPWSL2_VERSION 
		$customPropertiesObj | Add-Member -MemberType NoteProperty -Name "CmdLet" -Value $EventName
		## test if property exists
		if ($customPropertiesObj.psobject.properties.Name -notcontains "CmdLetValue1")
		{
			$customPropertiesObj | Add-Member -MemberType NoteProperty -Name "CmdLetValue1" -Value ""
		}
		$customPropertiesHT = @{}
		$customPropertiesObj.psobject.properties |Sort-Object name -Descending| ForEach-Object { $customPropertiesHT[$_.Name] = $_.Value }
		
		$result= Send-TrackEventTelemetry -EventName $EventName -CustomProperties $customPropertiesHT
		if ($env:PNPWSL2_DEBUG -eq 1)
		{
        	$result
		}
    }
    End{
        $ErrorActionPreference = $currentErrorActionPreference
    }
}
function Send-TrackEventTelemetry
{
   
    [CmdletBinding()]
    Param
    (
		[Parameter(
            Mandatory=$true,
            HelpMessage='Specify the name of the custom event.')]
		[System.String]
		[ValidateNotNullOrEmpty()]
		$EventName,
		[Parameter(Mandatory=$false)]
		[Hashtable]
		$CustomProperties
    )
    Begin{
		# app insights has a single endpoint where all incoming telemetry is processed.
		$AppInsightsIngestionEndpoint=$env:PNPWSL2_APPI_ENDPOINT
		$InstrumentationKey=$env:PNPWSL2_APPI_INSTRKEY
    }
    Process
    {
  
	
		# custom properties
		# convert the hashtable to a custom object, if properties were supplied.
		
		if ($PSBoundParameters.ContainsKey('CustomProperties') -and $CustomProperties.Count -gt 0)
		{
			$customPropertiesObj = [PSCustomObject]$CustomProperties;
		}
		else
		{
			$customPropertiesObj = [PSCustomObject]@{};
		}

		# prepare the REST request body schema.
		$bodyObject = [PSCustomObject]@{
			'name' = "Microsoft.ApplicationInsights.$InstrumentationKey.Event"
			'time' = ([System.dateTime]::UtcNow.ToString('o'))
			'iKey' = $InstrumentationKey
			'tags' = [PSCustomObject]@{
                'ai.cloud.roleInstance' = $env:PRODUCT_NAME
				'ai.device.os:' = $PSVersionTable.OS
			}
			'data' = [PSCustomObject]@{
				'baseType' = 'EventData'
				'baseData' = [PSCustomObject]@{
					'ver' = '2'
					'name' = $EventName
					'properties' = $customPropertiesObj
				}
			}
		};

		# convert the body object into a json blob.
		$bodyAsCompressedJson = $bodyObject | ConvertTo-JSON -Depth 10 -Compress;

		# prepare the headers
		$headers = @{
			'Content-Type' = 'application/x-json-stream';
		};

		# send the request
	    Invoke-RestMethod -Uri $AppInsightsIngestionEndpoint -Method Post -Headers $headers -Body $bodyAsCompressedJson 
		
    }
    End{
        
    }
}