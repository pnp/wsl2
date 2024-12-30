#!/bin/bash
# Defines the module\section name
modName="Azure"
modSection="AzureCli"
# Define the help message
# shellcheck disable=SC2034
HELP_MESSAGE="Installs Azure Cli"
HELP_MESSAGE_LONG="
 Installs Azure Cli . 

     [Azure Cli](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli) is a Microsoft Azure command-line tool used to create and manage Azure resources  
"

# Get the directory of the script being run
SCRIPTS_CORE_ROOT_FOLDER="$(dirname "$0")"
# Source the core.sh script which contains common functions and variables
# shellcheck disable=SC1091
source "$SCRIPTS_CORE_ROOT_FOLDER/../_core/core.sh"
# Print a separator with the module name and section
echo-print-separator "$modName"  "$modSection"
# Print the help message
echo-print "\n $HELP_MESSAGE_LONG"


# Ask the user if they want to install AzureCli
inquire "  Install AzureCli ? "

# If the user confirmed the installation
if [ "$?" -eq 1 ]
then
    # Print an empty line
    echo-print ""    
    
    # Call the function to install AzureCli
    install-azurecli # this script is inside _core
fi

# Print two new lines
echo-print "\n\n"