#!/bin/bash
# Define the module\section name
modName="Node"
modSection="install"
# Define the help messages
# shellcheck disable=SC2034
HELP_MESSAGE="Installs a specified version of Node.js using the Node Version Manager (NVM)." 
##write descritpion
HELP_MESSAGE_LONG="Installs a specified version of [Node.js](https://nodejs.org/en) using the Node Version Manager (NVM).

  1) It first checks if the requested version is already installed.
  2) If the requested version is not installed, the script installs it using NVM
  3) Sets installed version as the current version
"
# Get the directory of the current script
SCRIPTS_CORE_ROOT_FOLDER="$(dirname "$0")"
# Source the core.sh script from the _core directory
# shellcheck disable=SC1091
source "$SCRIPTS_CORE_ROOT_FOLDER/../_core/core.sh"

# Print a separator with the module name and section
echo-print-separator "$modName"  "$modSection"

function install-node() {
    # Print the help message
    echo-print " $HELP_MESSAGE_LONG"
    # Initialize is_valid_input as 0
    is_valid_input=0  
    # While loop that keeps asking for input until a valid number is entered
    while [[ $is_valid_input == 0 ]]
    do
        # Prompt the user for input
        echo-print-n "${LIGHT_WHITE} Install which Node.js version number (format V.X.Y.Z) ?${RESET} "
        # shellcheck disable=SC2162
        read input
        # Check if the input matches the pattern X.Y.Z where X, Y, and Z are numbers, and store the result in a variable
        is_valid_input=$(if [[ $input =~ ^[0-9]+(\.[0-9]+){0,2}$ ]]; then echo 1; else echo 0; fi)
        if [[ $is_valid_input == 0 ]]
        then
            echo-print-n "  ${RED}Invalid input (format V.X.Y.Z) !${RESET}\n"
        fi
    done


    echo-print " Start"

    # loads nvm bash_completion
    install-nvm

    echo-print "   Check if v$input is installed"
    # Check if Node v%1 is installed

    # Now you can use the is_installed variable in your script
    # shellcheck disable=SC2086
    version=$(nvm version $input)

    if [ "$version" == "N/A" ]; then
        echo-print "   Node v$input is not installed."
        echo-print "    Installing ..."

        printf "\n\n"
        # Install Node v$1 and use it
        nvm install "$input"
        printf "\n\n"
        echo-print "   Node v$input is installed !"
    else
        echo-print "   Node v$input is already installed!"
        nvm use "$input"
    fi
        echo-print " End\n"
}
# Call the install-node function with the input as the first argument
install-node