# Disable or Enable telemetry

\
By default PnP Wsl2 will report its usage anonymously. 

Information about the **version of PnP Wsl**, the **operation system version** and the **cmdlet** executed is the only information collected.

Notice that telemetry will *not* include parameters used and will *not* include any values of parameters.

Telemetry will also *not* be able to trace the execution back to the specific tenant it ran on, the organization it was used for or the person it was run by.  

Having telemetry in place allows to get insight in the usage of cmdlets and thereby prioritize work towards the most popular cmdlets.

To query if in a connected PnP Wsl2 session the telemetry is enabled, use [Get-PnPWsl2Telemetry](../cmdlets/Get-PnPWsl2Telemetry.md).

## Enable Telemetry

You can enable telemetry to be sent by using [Enable-PnPWsl2Telemetry](../cmdlets/Enable-PnPWsl2Telemetry.md)

## Disable Telemetry

You can disable telemetry to be sent by using [Disable-PnPWsl2Telemetry](../cmdlets/Disable-PnPWsl2Telemetry.md)  

## Enabling\Disabling Telemetry by using an environment variable

To disable telemetry, set the PNPWSL2_DISABLETELEMETRY environment variable to true, i.e. by using $env:PNPWSL2_DISABLETELEMETRY=$true.  

Remove the entry again or set it to false to enable telemetry to be sent again.  
