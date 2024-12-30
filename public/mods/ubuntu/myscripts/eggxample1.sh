#!/bin/bash
# Define the module\section name
modName="MyScripts" 
modSection="Eggxample1"
# Set the help message
# next line is shellcheck override to avoid SC2034 warning
# shellcheck disable=SC2034
HELP_MESSAGE="Eggxample1 is a script that installs linux x11 apps and shows a clock and a calc ."
# Set the long help message(message is formatted using markdown and then passed to the echo-print function to format it for the terminal. 
# Is also prepared to be a faithful markdown file to be used in the documentation)
HELP_MESSAGE_LONG="Installs  gedit linux app 

  Eggxample1 is a script that installs a linux app (gedit)  
  After execution take a peek at your Windows Start Menu, you should see a new entry for the app.  

  Purpose : show how to install a package and how to run linux apps in windows.  
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
## installs a package
echo-print "Installing linux gedit"
sudo apt-get install gedit -y
echo-print " Launcg gedit"

gedit & ## the & is used to run the app in the background

echo-print "\n\n"