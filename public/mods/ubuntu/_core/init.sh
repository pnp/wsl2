#!/bin/bash

# Get the directory of the script being run
SCRIPTS_CORE_ROOT_FOLDER="$(dirname "$0")"

# Source the core.sh script which contains common functions and variables
# shellcheck disable=SC1091
source "$SCRIPTS_CORE_ROOT_FOLDER/core.sh"

# Define the module name
# shellcheck disable=SC2034
modName="Initialization"

# Print the start of the environment initialization process
echo-print "\n${GREEN}Environment Initialization...\n"

# Print the steps that will be performed during the initialization
echo-print " ${YELLOW}- ${RESET}${LIGHT_WHITE}User added in the setup will be setted as [${BLUE}default user${RESET}]"
echo-print " ${YELLOW}- ${BLUE}WSLU tools${LIGHT_WHITE} will be installed (usefull wsltools like wslview(fake WSL browser that will open link in default Windows browser))"
echo-print " ${YELLOW}- ${BLUE}NVM${LIGHT_WHITE} will be installed${RESET}"
echo-print " ${YELLOW}- ${BLUE}Node10${LIGHT_WHITE} will be installed${RESET}"
# Ask the user to confirm the environment initialization

# Move to a new line after the key is pressed
echo
echo-print "\n\n${GREEN}Environment will be initialized ...\n"

# Call the initialization function
initialize

# Install the last added superuser
install-superuser-lastadded

# Install WSLU tools
install-wslu

# Install Node Version Manager (NVM)
install-nvm

# Install Node.js version 10
install-node10

# Print the end of the environment initialization process
echo-print "\n\n${GREEN}Environment ready !\n"

#!/bin/bash
