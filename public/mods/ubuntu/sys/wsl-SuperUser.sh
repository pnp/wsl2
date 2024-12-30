#!/bin/bash
# Set the module\section name
modName="SYS"
modSection="Wsl-SuperUser"
# Set the help message
# shellcheck disable=SC2034
HELP_MESSAGE="Sets the default user for a WSL instance"
# Set the long help message
HELP_MESSAGE_LONG="This script is a bash shell script that sets the default user for a WSL instance"

# Set the root folder for the core scripts
SCRIPTS_CORE_ROOT_FOLDER="$(dirname "$0")"
# Source the core script
# shellcheck disable=SC1091
source "$SCRIPTS_CORE_ROOT_FOLDER/../_core/core.sh"

# Print a separator
echo-print-separator "$modName"  "$modSection"

# Print the long help message
echo-print " $HELP_MESSAGE_LONG"

# Define a function to set up a superuser
setup-superuser() {
    # Start the setup process
    echo-print " Start"
    echo-print "  Modify the /etc/wsl.conf file adding setup user as default user"

    # Get the username from the function argument
    setup_username=$1

    # Print the username
    echo -e "\n   SetupUser:$setup_username"

    # Remove user lines from wsl.conf
    sudo sed -i '/^\[user\]$/d' /etc/wsl.conf
    sudo sed -i '/default=/d' /etc/wsl.conf

    # Add default user to wsl.conf
    echo "[user]" | sudo tee -a /etc/wsl.conf  > /dev/null
    echo "default=$setup_username" | sudo tee -a /etc/wsl.conf  > /dev/null

    # Print the contents of wsl.conf
    echo -e "\n# WSL.Conf File #########"
    cat /etc/wsl.conf
    echo -e "\n#########################\n"

    # End the setup process
    echo-print " End"
}

# Ask the user for their username
echo-print "  Type user name"
read -r username

# Call the setup-superuser function with the username
setup-superuser "$username"

# Print two newlines
echo-print "\n\n"