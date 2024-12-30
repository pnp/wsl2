#!/bin/bash
# Set the module\section name
modName="SYS"
modSection="Wsl-SSHKeyGenerate"
# Set the help message
# shellcheck disable=SC2034
HELP_MESSAGE="Generates SSH keys"
# Set the long help message
HELP_MESSAGE_LONG="This script is a bash shell script that will create an SSH key in WSL and will update your windows host with the same key"

# Set the root folder for the core scripts
SCRIPTS_CORE_ROOT_FOLDER="$(dirname "$0")"

# Source the core script
# shellcheck disable=SC1091
source "$SCRIPTS_CORE_ROOT_FOLDER/../_core/core.sh"

# Print a separator with the module name and section
echo-print-separator "$modName"  "$modSection"
# Define a function to generate and set SSH keys
set-sshk() {
    echo-print "\n\n  Start"
    echo-print "   Add ssh key (wsl2_idrsa) ...\n"

    # Set the current file to the wsl2_idrsa file in the .ssh directory
    currentFile=~/.ssh/wsl2_idrsa

    # Generate the SSH key
    ssh-keygen -t rsa -b 4096 -C "user" -f $currentFile
    echo-print "\n"
    # Get the Windows username
    WINDOWS_USER=$(/mnt/c/Windows/System32/cmd.exe /c 'echo %USERNAME%' | sed -e 's/\r//g')

    # Change directory to the Windows user's directory
    # shellcheck disable=SC2086
    # shellcheck disable=SC2164
    cd /mnt/c/Users/$WINDOWS_USER

    echo-print "   Test if ${YELLOW}.ssh folder${LIGHT_WHITE} exists (Windows)"

    # Check if the .ssh directory exists
    if [[ -d .ssh ]] 
    then
        echo-print "    ${YELLOW}.ssh folder${LIGHT_WHITE} in Windows, exist!\n"
    else
        echo-print "   ${YELLOW}.ssh folder${LIGHT_WHITE} in Windows dont exist, Creating ...\n"

        # Create the .ssh directory
        mkdir .ssh
    fi    

    echo-print "   Copy ${YELLOW}wsl2_idrsa*${LIGHT_WHITE} to .ssh Windows folder\n" 

    # Change directory to the .ssh directory
    cd .ssh || exit

    # Copy the SSH keys to the .ssh directory
    cp ~/.ssh/wsl2_idrsa* .

    echo-print  "   Keys copied to Windows ${YELLOW}.ssh folder${LIGHT_WHITE}!" 

    # Print two newlines
    printf "\n\n"

    echo-print "  End"
}

# Print the long help message
echo-print "\n $HELP_MESSAGE_LONG"

# Ask the user if they want to create an SSH key
inquire "  Create ssh key "

# If the user wants to create an SSH key
if [ "$?" -eq 1 ]
then
    # Call the set-sshk function
    set-sshk
fi

# Print two newlines
echo-print "\n\n"