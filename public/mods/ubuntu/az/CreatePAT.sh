#!/bin/bash
# Defines the module\section name
modName="Azure"
modSection="Azure Devops - Create PAT (1 Year)"
# Define the help message
# shellcheck disable=SC2034
HELP_MESSAGE="Creates a AzureDevOps Personal Access Token (1 Year)" 
HELP_MESSAGE_LONG="Creates a AzureDevOps Personal Access Token that is valid for 1 year" 

# Get the directory of the script being run
SCRIPTS_CORE_ROOT_FOLDER="$(dirname "$0")"
# Source the core.sh script which contains common functions and variables
# shellcheck disable=SC1091
source "$SCRIPTS_CORE_ROOT_FOLDER/../_core/core.sh"

# Print a separator with the module name and section
echo-print-separator "$modName"  "$modSection"
# Print the help message
echo-print "\n $HELP_MESSAGE_LONG"

# Define a function to create a AzureDevOps Personal Access Token that is valid for 1 year
create-azdevopsOneYearPAT() {
    # Define the section name



    # Print a message indicating the start of the process
    echo-print " Start"
    
    # Check if Azure CLI is installed
    testExists=$(command -v az)
    if  [[ "$testExists" == *"/mnt/c/"* ]]; then
        exists=0
    elif [[ -z "$testExists" ]]; then
        exists=0
    else
        exists=1
    fi

    # If Azure CLI is not installed
    if  [[ $exists -eq 0 ]]; then
        # Print a message indicating that Azure CLI is not installed and will be installed
        echo-print "  azure cli is not installed, installing ..."

        # Install Azure CLI
        install-azurecli # this script is inside _core

        # Print a message indicating that Azure CLI has been installed
        echo-print "   azure cli installed!"

        # Print a separator
        modSection="create PAT (1 Year)"
        echo-print-separator "$modName"  "$modSection"
    fi

    # Ask the user to enter their DevOps organization
    
    echo-print-n "\n${LIGHT_WHITE}  Type your Devops Org : ${YELLOW}"
    read -r devopsOrg
    # Ask the user to enter the token name
    echo-print-n  "${LIGHT_WHITE}  Type the Token Name  : ${YELLOW}"
    read -r devopsTokenName

    # Login to Azure
    az login 

    # Print a message indicating that the PAT is being created
    echo-print "  creating PAT ..."

    # Get the current date and time and add one year to it
    current_date=$(date "+%Y-%m-%d %H:%M:%S")
    one_year_later=$(date -d "$current_date + 1 year" "+%Y-%m-%d %H:%M:%S")

    # Convert the date and time to UTC
    utc_date=$(date -u -d "$one_year_later" "+%Y-%m-%d %H:%M:%S")

    # Define the URL for creating the PAT
    url="https://vssps.dev.azure.com/$devopsOrg/_apis/tokens/pats?api-version=7.1-preview.1"

    # Define the body of the request
    body='{"displayName": "'"$devopsTokenName"'","scope": "app_token","validTo": "'"$utc_date"'",  "allOrgs": false }'

    # Send the request to create the PAT
    az rest --headers "Content-Type=application/json" \
        --resource '499b84ac-1321-427f-aa17-267ca6975798' \
        --method POST --url "$url" --body "$body" 
}

# Print an empty line
echo-print ""

# Call the function to create the PAT
modSection="create PAT"
create-azdevopsOneYearPAT  

# Print two new lines
echo-print "\n\n"