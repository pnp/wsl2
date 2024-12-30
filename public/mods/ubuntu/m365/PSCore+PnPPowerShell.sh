#!/bin/bash
# Set the module\section name
modName="m365"
modSection="pscore+pnppowershell"
# Set the help message
# shellcheck disable=SC2034
HELP_MESSAGE="Installs powershell core + pnp powershell "
# Set the long help message
HELP_MESSAGE_LONG="This script will install PowerShell Core and PnP.PowerShell"

# Set the root folder for the core scripts
SCRIPTS_CORE_ROOT_FOLDER="$(dirname "$0")"

# Source the core script
# shellcheck disable=SC1091
source "$SCRIPTS_CORE_ROOT_FOLDER/../_core/core.sh"

## Print a separator with the module name and section
echo-print-separator "$modName"  "$modSection"
# Print the help message
echo-print "\n $HELP_MESSAGE_LONG"

install-pscore-pnppowershell(){
    
    echo-print " Start"
    sudo apt-get install -y wget apt-transport-https software-properties-common
    # shellcheck disable=SC1091
    source /etc/os-release
    wget -q https://packages.microsoft.com/config/ubuntu/$VERSION_ID/packages-microsoft-prod.deb
    sudo dpkg -i packages-microsoft-prod.deb 
    rm packages-microsoft-prod.deb 
    sudo apt-get update 
    sudo apt-get install -y powershell
    echo-print "  Install PnP.PowerShell Start"
    pwsh -Command 'Install-Module PnP.PowerShell'
    echo-print "  Install PnP.PowerShell End"
    echo-print " End"
}
# Ask the user if they want to install PSCore + PnP.PowerShell
inquire " Install PSCore + PnP.PowerShell ? "

# If the user answered yes (1), then install PSCore + PnP.PowerShell
if [ "$?" -eq 1 ]
then
    echo-print ""
    install-pscore-pnppowershell 
fi

# Print two newlines
echo-print "\n\n"