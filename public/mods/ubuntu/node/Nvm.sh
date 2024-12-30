#!/bin/bash
# Define the module\section name
modName="Node"
modSection="Install"
# Set the help message
# shellcheck disable=SC2034
HELP_MESSAGE="Installs the Node Version Manager (nvm)"
# Set the long help message
HELP_MESSAGE_LONG="Installs the Node Version Manager (nvm).

  [Node Version Manager (NVM)](https://github.com/nvm-sh/nvm) is a tool used to download, install, manage, and upgrade Node.js versions
"
# Set the root folder for the core scripts
SCRIPTS_CORE_ROOT_FOLDER="$(dirname "$0")"
# Source the core script
# shellcheck disable=SC1091
source "$SCRIPTS_CORE_ROOT_FOLDER/../_core/core.sh"

# Print a separator with the module name and section
echo-print-separator "$modName"  "$modSection"


# Print the long help message
echo-print "\n $HELP_MESSAGE_LONG"

# Call the install-nvm function from the core script
install-nvm # this script is inside _core

# Print two newlines
echo-print "\n\n"