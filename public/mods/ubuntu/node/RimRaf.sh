#!/bin/bash
# Define the module\section name
modName="Node"
modSection="RimRaf"
# shellcheck disable=SC2034
HELP_MESSAGE="Installs the RimRaf Node tool"
# Set the long help message
HELP_MESSAGE_LONG="Installs the RimRaf Node tool.

  [RimRaf](https://github.com/isaacs/rimraf) is a utility for Node.js that provides a faster alternative to the 'rm -rf' shell command.  
  It allows for deep recursive deletion of files and folders
  
"
# Set the root folder for the core scripts
SCRIPTS_CORE_ROOT_FOLDER="$(dirname "$0")"
# Source the core script
# shellcheck disable=SC1091
source "$SCRIPTS_CORE_ROOT_FOLDER/../_core/core.sh"
# Print a separator with the module name and section
echo-print-separator "$modName"  "$modSection"

# Print the long help message
echo-print " $HELP_MESSAGE_LONG"

# Ask the user if they want to install the RimRaf tool
inquire " Install RimRaf tool (add it to all installed Node.js versions )?"

# If the user answered yes (1), then install the RimRaf tool
if [ "$?" -eq 1 ]
then
    is_valid_input=0  
    # While loop that keeps asking for input until a valid number is entered
    while [[ $is_valid_input == 0 ]]
    do
        # Prompt the user for input
        echo-print-n "\n${LIGHT_WHITE} Install which Node.js version number (format V.X.Y.Z) ?${RESET} "
        # shellcheck disable=SC2162
        read input
        # Check if the input matches the pattern X.Y.Z where X, Y, and Z are numbers, and store the result in a variable
        is_valid_input=$(if [[ $input =~ ^[0-9]+(\.[0-9]+){0,2}$ ]]; then echo 1; else echo 0; fi)
        if [[ $is_valid_input == 0 ]]
        then
            echo-print-n "  ${RED}Invalid input (format V.X.Y.Z) !${RESET}\n"
        fi
    done
    echo-print ""
    # Set the module section name
    # Install RimRaf globally using npm in all nodes
    install-nvm # this script is inside _core
    nvm use $input
    # Get a list of all installed Node.js versions
    versions=$( nvm ls --no-colors | grep -v 'N/A' | grep -o -E 'v[0-9]+\.[0-9]+\.[0-9]+' | sort -u)

    # Iterate over the versions and install rimraf in each one
    for version in $versions; do
        echo-print "\n${YELLOW}Installing rimraf in Node.js version $version... ${RESET}\n"
        # shellcheck disable=SC2086
        nvm use $version
        npm i -g rimraf
    done    
fi

# Print two newlines
echo-print "\n\n"