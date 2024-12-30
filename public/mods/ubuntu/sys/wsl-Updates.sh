#!/bin/bash
# Set the module\section name
modName="SYS"
modSection="Wsl-Updates"
# Set the help message
# shellcheck disable=SC2034
HELP_MESSAGE="Updates current linux dist packages"
# Set the long help message
HELP_MESSAGE_LONG="This script is a bash shell script that updates the current Linux distribution packages"

# Set the root folder for the core scripts
SCRIPTS_CORE_ROOT_FOLDER="$(dirname "$0")"
# Source the core script
# shellcheck disable=SC1091
source "$SCRIPTS_CORE_ROOT_FOLDER/../_core/core.sh"

# Print a separator
echo-print-separator "$modName"  "$modSection"
# Print the long help message
echo-print "\n $HELP_MESSAGE_LONG"

# Update the list of available packages and their versions
sudo apt update

# Install newer versions of the packages you have
sudo apt upgrade