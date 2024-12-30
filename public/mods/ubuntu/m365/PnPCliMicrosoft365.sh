#!/bin/bash
# Defines the module\section name
modName="m365"
modSection="@pnp/cli-microsoft365"
# Define the help message
# shellcheck disable=SC2034
HELP_MESSAGE="Installs @pnp/cli-microsoft365."
HELP_MESSAGE_LONG="Installs @pnp/cli-microsoft365.

  [pnp/cli-microsoft365](https://pnp.github.io/cli-microsoft365/) is a command-line interface (CLI) that allows users to manage 
  their Microsoft 365 tenant and SharePoint Framework projects on any platform  
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

install-pnpclim365() {
    
    echo-print "  Start"
    echo-print "   Install ..."

    printf "\n\n"
    npm install @pnp/cli-microsoft365 -g -force
    printf "\n\n"

    echo-print "  Installed!"
    echo-print " End"
}
# Ask the user if they want to install @pnp/cli-microsoft365
inquire "  Install @pnp/cli-microsoft365 ? "

# If the user confirmed the installation
if [ "$?" -eq 1 ]
then
    # Print an empty line
    echo-print ""
    
    # Call the function to install @pnp/cli-microsoft365
    install-pnpclim365  # this script is inside _core
fi

# Print two new lines
echo-print "\n\n"