#!/bin/bash
# Define the module\section name
modName="SPFX"
# Set the module section name
modSection="Gulp+Yeoman+MicrosoftGen+SpfxFastServe"
# Define the help messages
# shellcheck disable=SC2034
HELP_MESSAGE="Installs gulp-cli yo @microsoft/generator-sharepoint spfx-fast-serve" 
HELP_MESSAGE_LONG="This script is used to install gulp-cli yo @microsoft/generator-sharepoint spfx-fast-serve."

# Get the directory of the current script
SCRIPTS_CORE_ROOT_FOLDER="$(dirname "$0")"
# Source the core.sh script from the _core directory
# shellcheck disable=SC1091
source "$SCRIPTS_CORE_ROOT_FOLDER/../_core/core.sh"

# Print the help message
echo-print " $HELP_MESSAGE_LONG"
# Define a function to install gulp-cli, yo, @microsoft/generator-sharepoint, and spfx-fast-serve
install-gulp_yo_microsoftgen_spfxfastserve() {

    # Print a separator with the module name and section
    echo-print-separator "$modName"  "$modSection"

    echo-print " Start"
    echo-print "  Install ..."

    printf "\n\n"
    # Install the packages globally
    npm install gulp-cli yo @microsoft/generator-sharepoint  -g -force
    npm install spfx-fast-serve -g -force
    printf "\n\n"

    echo-print "  Installed!"
    echo-print " End"
}
install-gulp_yo_microsoftgen_spfxfastserve

