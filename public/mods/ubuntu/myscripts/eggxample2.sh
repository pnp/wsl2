#!/bin/bash
# Define the module\section name
modName="MyScripts" 
modSection="Eggxample2"
# Set the help message
# next line is shellcheck override to avoid SC2034 warning
# shellcheck disable=SC2034
HELP_MESSAGE="Eggxample2 is a script that runs a PowerShell script that calls a windows process and plays a rickroll. "
# Set the long help message(message is formatted using markdown and then passed to the echo-print function to format it for the terminal. 
# Is also prepared to be a faithful markdown file to be used in the documentation)
HELP_MESSAGE_LONG="Eggxample2 is a script that runs a RickRool PowerShell script.

  Eggxample2 is a script that runs a PowerShell script that calls a windows process and plays a rickroll.  

  Purpose : show how to run a process in windows within wsl.
"
# Set the root folder for the core scripts
SCRIPTS_CORE_ROOT_FOLDER="$(dirname "$0")"
# Source the core script
# next line is shellcheck override to avoid SC1091 warning
# shellcheck disable=SC1091 
source "$SCRIPTS_CORE_ROOT_FOLDER/../_core/core.sh"

# Print a separator with the module name and section
echo-print-separator "$modName"  "$modSection"
# Print the long help message
echo-print "\n $HELP_MESSAGE_LONG"

## script itself 
## it will run a powershell script that will open a browser and play a rickroll 
# URL of the PowerShell script (dont worry is a rickroll! #harmless #doanloaded manually and check)
url="https://raw.githubusercontent.com/youknowedo/rickroll/main/roll.p1"
# Download the PowerShell script and store it in a variable
content=$(wget -qO- $url)
# Remove the carriage return characters from the content
# shellcheck disable=SC2116
content=$(echo "Write-Host 'Script running scope ...'

\$variable = (get-variable -Name Home).Value
Write-Host (' Home Path:' + \$variable)
\$variable = (get-variable -Name PSCommandPath).Value
Write-Host (' PSCommandPath:' + \$variable)
Write-Host ''
Write-Host 'Notice that you are running a bash script in linux, that is calling a Windows process.'
Write-Host 'Hit Return to Continue'
Read-Host
Write-Host ''
Write-Host 'Now it will run a powershell script that plays a rickroll. (While the demo is rolling Hit C or Q to quit)'
Write-Host 'Hit Return to Continue'
Read-Host
$content")

# Save the content to a temporary file
echo "$content" > temp.ps1

# Start a new PowerShell process to execute the temporary file
echo "Start-Process pwsh.exe -ArgumentList '-ExecutionPolicy Bypass -File ./temp.ps1'" | pwsh.exe

# Print two newlines
echo-print "\n\n"