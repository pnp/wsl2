#!/bin/bash
# Set the module\section name
modName="m365"
modSection="pnppowershell"
# Set the help message
# shellcheck disable=SC2034
HELP_MESSAGE="Installs pnp powershell  (powershell core must be installed)"
HELP_MESSAGE_LONG="Installs PnP.PowerShell.

  [PnP.PowerShell](https://pnp.github.io/powershell/) is a cross-platform PowerShell Module that provides over 650 cmdlets to work with Microsoft 365 environments  
"

# Set the root folder for the core scripts
SCRIPTS_CORE_ROOT_FOLDER="$(dirname "$0")"
# Source the core script
# shellcheck disable=SC1091
source "$SCRIPTS_CORE_ROOT_FOLDER/../_core/core.sh"

# Print a separator with the module name and section
echo-print-separator "$modName"  "$modSection"
# Print the help message
echo-print "\n $HELP_MESSAGE_LONG"

install-pnppowershell(){
   
    echo-print " Start"
    pwsh -Command 'Install-Module PnP.PowerShell'
    echo-print " End"
}
# Print the help message
echo-print " $HELP_MESSAGE_LONG"

# Ask the user if they want to install PnP.PowerShell
inquire "  Install PnP.PowerShell ? "

# If the user answered yes (1), then install PnP.PowerShell
if [ "$?" -eq 1 ]
then
    echo-print ""
    # Call the install-pnppowershell function from the core script
    install-pnppowershell 
fi

# Print two newlines
echo-print "\n\n"