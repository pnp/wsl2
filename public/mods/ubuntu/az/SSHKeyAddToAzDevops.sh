#!/bin/bash
# Defines the module\section name
modName="Azure"
modSection="Add SSHAzure DevOps"
# Define the help messages
# shellcheck disable=SC2034
HELP_MESSAGE="Adds a Azure DevOps SSH KEY" 
HELP_MESSAGE_LONG="This script is used to add a WSL SSH key to an Azure DevOps organization 

  1) It prompts the user to enter the Azure DevOps organization and the SSH key name
  2) Gets the SSH key from the .ssh directory 
  3) Adds the SSH key to the Azure DevOps organization  

"
# Get the directory of the current script
SCRIPTS_CORE_ROOT_FOLDER="$(dirname "$0")"
# Source the core.sh script from the _core directory
# shellcheck disable=SC1091
source "$SCRIPTS_CORE_ROOT_FOLDER/../_core/core.sh"

# Define a function to add the WSL SSH key to Azure DevOps
AddWslSSHto-azdevops() {
    # Print a separator
    echo-print-separator "$modName"  "$modSection"
    # Print the help message
    echo-print " $HELP_MESSAGE_LONG"
    # Print the start message
    echo-print " Start"
    
    # Prompt the user to enter the Azure DevOps organization
    echo-print-n "\n${LIGHT_WHITE}  Type your Devops Org  :${YELLOW}"
    read -r devopsOrg

    # Prompt the user to enter the SSH key name
    echo-print-n "${LIGHT_WHITE}  Type the SSH Key Name :${YELLOW}"
    read -r devopsTokenName

    # Get the SSH key from the .ssh directory
    echo-print "\n${LIGHT_WHITE}  Getting ssh [${YELLOW}wsl2_idrsa.pub${LIGHT_WHITE}] ..."
    FILE=~/.ssh/wsl2_idrsa.pub
    if [ -f "$FILE" ]; then
        echo-print "  SShKey $FILE exists."
    else 
       echo-print "  SShKey $FILE does not exist."
       echo-print "  SShKey Creation ..."
       # shellcheck disable=SC1091
       source "$SCRIPTS_CORE_ROOT_FOLDER/../sys/wsl-SSHKeyGenerate.sh" 
    fi

    ssh_key=$(cat ~/.ssh/wsl2_idrsa.pub)
    
    # Translate the script directory to a Windows-style path
    # shellcheck disable=SC2086
    windows_path=$(echo $SCRIPTS_CORE_ROOT_FOLDER | sed -e 's|/mnt/\(.\)|\1:|' -e 's|/|\\|g')
    echo-print "${LIGHT_WHITE}"  
    # Run the AddSSHASelinium.ps1 PowerShell script with the organization, SSH key name, and SSH key content as arguments
    pwsh.exe -File "$windows_path\\..\\az\\SSHKeyAdd\\AddSSHKeySelinium.ps1" -organization "$devopsOrg" -sshaKeyName "$devopsTokenName" -sshaKeyContent "$ssh_key"
}

# Print an empty line
echo-print ""

# Call the function to add the WSL SSH key to Azure DevOps
AddWslSSHto-azdevops

# Print two newlines
echo-print "\n"