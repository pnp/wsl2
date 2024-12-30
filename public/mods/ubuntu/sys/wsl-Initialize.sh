#!/bin/bash
# Set the module\section name
modName="SYS"
modSection="Wsl-Initialize"
# Set the help message
# shellcheck disable=SC2034
HELP_MESSAGE="Initializes a ubuntu environment"
# Set the long help message
HELP_MESSAGE_LONG="Initializes a ubuntu environment"
# Set the root folder for the core scripts
SCRIPTS_CORE_ROOT_FOLDER="$(dirname "$0")"
# Print a separator with the module name and section
echo-print-separator "$modName"  "$modSection"
# shellcheck disable=SC1091
source "$SCRIPTS_CORE_ROOT_FOLDER/../_core/core.sh"
# Print the long help message
echo-print " $HELP_MESSAGE_LONG"

# Change directory to the _core directory relative to the root folder
# shellcheck disable=SC2164
cd "$SCRIPTS_CORE_ROOT_FOLDER/../_core"

# Execute the init.sh script in the _core directory
"./init.sh"