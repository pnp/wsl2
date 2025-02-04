#!/bin/bash
# Define the module\section name
modName="MyScripts" 
modSection="Eggxample3"
# Set the help message
# next line is shellcheck override to avoid SC2034 warning
# shellcheck disable=SC2034
HELP_MESSAGE="Eggxample3 is a script that runs a PowerShell script that installs x11 apps ."
# Set the long help message(message is formatted using markdown and then passed to the echo-print function to format it for the terminal. 
# Is also prepared to be a faithful markdown file to be used in the documentation)
HELP_MESSAGE_LONG="Installs linux x11 apps and shows a clock and a calc 

  Eggxample1 is a script that installs X11 apps (linux), shows a linux clock and a linux calc.
  Purpose is to show how to install a package and run a process in linux.
"
# Set the root folder for the core scripts
SCRIPTS_CORE_ROOT_FOLDER="$(dirname "$0")"
# Source the core script
# next line is shellcheck override to avoid SC1091 warning
# shellcheck disable=SC1091 
source "$SCRIPTS_CORE_ROOT_FOLDER/../_core/core.sh"

# Print a separator with the module name and section
echo-print-separator "$modName"  "$modSection"
# Print the long help message
echo-print "\n $HELP_MESSAGE_LONG"

## script itself 
## installs a packge
echo-print "Installing x11-apps"
sudo apt install x11-apps -y


echo-print "Display a linux clock and a linux daunting calculator "
## display a linux clock 
xclock & xcalc 



echo-print "\n\n"