#!/bin/bash
# Set the module\section name
modName="SYS"
modSection="Wsl-Utils"

# Set the help message
# shellcheck disable=SC2034
HELP_MESSAGE="Installs wsl utils"
# Set the long help message
HELP_MESSAGE_LONG="This script is a bash shell script that installs WSL [utilities](https://github.com/wslutilities/wslu)"

# Set the root folder for the core scripts
SCRIPTS_CORE_ROOT_FOLDER="$(dirname "$0")"

# Source the core script
# shellcheck disable=SC1091
source "$SCRIPTS_CORE_ROOT_FOLDER/../_core/core.sh"

# Print a separator
echo-print-separator "$modName"  "$modSection"
# Print the long help message
echo-print " $HELP_MESSAGE_LONG"

# Ask the user if they want to install wslu
inquire "  Install wslu ? "

# If the user wants to install wslu
if [ "$?" -eq 1 ]
then
    # Print a newline
    echo-print ""

    # Call the install-wslu function
    install-wslu  # this script is inside _core
fi

# Print two newlines
echo-print "\n\n"