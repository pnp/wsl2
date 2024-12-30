#!/bin/bash
# Define the module\section name
modName="SPFX"
modSection="git config"
# Define the help messages
# shellcheck disable=SC2034
HELP_MESSAGE="Configure Git" 
HELP_MESSAGE_LONG="This script is used to configure git (username;useremail)."

# Get the directory of the current script
SCRIPTS_CORE_ROOT_FOLDER="$(dirname "$0")"
# Source the core.sh script from the _core directory
# shellcheck disable=SC1091
source "$SCRIPTS_CORE_ROOT_FOLDER/../_core/core.sh"
# Define a function to set git config
gitconfig() {
    # Print a separator with the module name and section
    echo-print-separator "$modName"  "$modSection"
    # Print the help message
    echo-print " $HELP_MESSAGE_LONG"
    
    echo-print " Start"
    echo-print "  Config ..."

    echo-print-n "${LIGHT_WHITE}  Type git user name :${YELLOW}"
    read -r username
    echo-print-n "${LIGHT_WHITE}  Type git user email:${YELLOW}"
    read -r useremail

    printf "\n"
    # Set git config
    git config --global user.name "$username"
    git config --global user.email "$useremail"
    git config --global core.filemode false
    git config --global core.autocrlf true
    echo-print "  Configured!"
    echo-print " End"
}
gitconfig
