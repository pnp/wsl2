#!/bin/bash
# Define the module\section name
modName="dotnet"
modSection="install"
# Define the help messages
# shellcheck disable=SC2034
HELP_MESSAGE="Installs a specified version of dontnet." 
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

# Array of strings with Ubuntu versions and .NET SDKs
ubuntu_dotnet_sdks=(
    "ubuntu-24.10:dotnet-9.0-sdk"
    "ubuntu-24.04:dotnet-9.0-sdk"
    "ubuntu-22.04:dotnet-9.0-sdk"
    "ubuntu-20.04:dotnet-8.0-sdk"
    "ubuntu-18.04:dotnet-6.0-sdk"
    "ubuntu-16.04:dotnet-3.1-sdk"
)

# Functions to install .NET SDK for specific Ubuntu versions
install_ubuntu24_10_dotnet_9_sdk() {
    sudo apt-get update && \
    sudo apt-get install -y dotnet-sdk-9.0
}

install_ubuntu24_04_dotnet_9_sdk() {
    sudo add-apt-repository ppa:dotnet/backports -y && \
    sudo apt-get update && \
    sudo apt-get install -y dotnet-sdk-9.0
}

install_ubuntu22_04_dotnet_9_sdk() {
    sudo add-apt-repository ppa:dotnet/backports -y && \
    sudo apt-get update && \
    sudo apt-get install -y dotnet-sdk-9.0
}

install_ubuntu20_04_dotnet_8_sdk() {
    wget https://packages.microsoft.com/config/ubuntu/20.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb && \
    sudo dpkg -i packages-microsoft-prod.deb && \
    rm packages-microsoft-prod.deb && \
    sudo apt-get update && \
    sudo apt-get install -y dotnet-sdk-8.0
}

install_ubuntu18_04_dotnet_6_sdk() {
    wget https://packages.microsoft.com/config/ubuntu/18.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb && \
    sudo dpkg -i packages-microsoft-prod.deb && \
    rm packages-microsoft-prod.deb && \
    sudo apt-get update && \
    sudo apt-get install -y dotnet-sdk-6.0
}

install_ubuntu16_04_dotnet_3_1_sdk() {
    wget https://packages.microsoft.com/config/ubuntu/16.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb && \
    sudo dpkg -i packages-microsoft-prod.deb && \
    rm packages-microsoft-prod.deb && \
    sudo apt-get update && \
    sudo apt-get install -y dotnet-sdk-3.1
}



# Call the function and capture the selected option
selected_option=$(inquireWithMultipleOptions "Select OS/dotnet core version to install" "${ubuntu_dotnet_sdks[@]}")

# Use the selected option with a case statement
case "$selected_option" in
    "ubuntu-24.10:dotnet-9.0-sdk")
        install_ubuntu24_10_dotnet_9_sdk
        ;;
    "ubuntu-24.04:dotnet-9.0-sdk")
        install_ubuntu24_04_dotnet_9_sdk
        ;;
    "ubuntu-22.04:dotnet-9.0-sdk")
        install_ubuntu22_04_dotnet_9_sdk
        ;;
    "ubuntu-20.04:dotnet-8.0-sdk")
        install_ubuntu20_04_dotnet_8_sdk
        ;;
    "ubuntu-18.04:dotnet-6.0-sdk")
        install_ubuntu18_04_dotnet_6_sdk
        ;;
    "ubuntu-16.04:dotnet-3.1-sdk")
        install_ubuntu16_04_dotnet_3_1_sdk
        ;;
    *)
        echo "Invalid selection. Exiting."
        exit 1
        ;;
esac

# Confirm installation
echo "\n Installation complete for: $selected_option"
