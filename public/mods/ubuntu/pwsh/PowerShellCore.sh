#!/bin/bash
# Set the module\section name
modName="pwsh"
modSection="PowerShellCore"
# Set the help message
# shellcheck disable=SC2034
HELP_MESSAGE="Installs powershell core"
# Set the long help message
HELP_MESSAGE_LONG="Installs the latest version of PowerShell Core.

  [PowerShell Core](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/?view=powershell-7.4) is a cross-platform automation and configuration tool/framework that works on Windows, Linux, and macOS. 
  It is based on .NET Core, which allows it to be multiplatform
  
"
#PowerShell Core is a cross-platform automation and configuration tool/framework that works on Windows, Linux, and macOS. It is based on .NET Core, which allows it to be multiplatform
# Set the root folder for the core scripts
SCRIPTS_CORE_ROOT_FOLDER="$(dirname "$0")"
# Source the core script
# shellcheck disable=SC1091
source "$SCRIPTS_CORE_ROOT_FOLDER/../_core/core.sh"

# Print the long help message
echo-print " $HELP_MESSAGE_LONG"

install-pscore(){

    echo-print-separator "$modName"  "$modSection"
    echo-print " Start"
    sudo apt-get install -y wget apt-transport-https software-properties-common
    # shellcheck disable=SC1091
    source /etc/os-release
    # shellcheck disable=SC2086
    wget -q https://packages.microsoft.com/config/ubuntu/$VERSION_ID/packages-microsoft-prod.deb
    sudo dpkg -i packages-microsoft-prod.deb 
    rm packages-microsoft-prod.deb 
    sudo apt-get update 
    sudo apt-get install -y powershell
    echo-print "\n End"
}
# Ask the user if they want to install PowerShell Core
inquire "  Install PowerShellCore  ? "

# If the user answered yes (1), then install PowerShell Core
if [ "$?" -eq 1 ]
then
    echo-print ""
    # Call the install-pscore function from the core script
    install-pscore # this script is inside _core
fi

# Print two newlines
echo-print "\n\n"