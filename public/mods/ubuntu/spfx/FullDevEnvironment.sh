#!/bin/bash
# Set the module\section name
modName="SPFX"
modSection="Ready to go environment for SharePoint Framework Development"
# Set the help message
# shellcheck disable=SC2034
HELP_MESSAGE="Installs all needed assets for spfx dev (nvm;node;gulp;yeoman;microsoft yo gen,spfxfastserve,gitconfig,sshkeygen,devcert)"
# Set the long help message
HELP_MESSAGE_LONG=" This script will install all needed assets for SharePoint Framework Development environment following Microsoft guidance
  mentioned [here](https://learn.microsoft.com/en-us/sharepoint/dev/spfx/set-up-your-development-environment)

  1) It will install **nvm** , **node** (you can select the version), [gulp-cli](https://github.com/gulpjs/gulp-cli), [yeoman](https://yeoman.io/),
  [microsoft yeoman generator](https://www.npmjs.com/package/@microsoft/generator-sharepoint), and [spfxfastserve](https://github.com/s-KaiNet/spfx-fast-serve) 
  2) **Create the sfpx self-signed developer certificate**
  3) **Import** the certificate to your **windows local computer store**
  4) Will also **create the sshkey in wsl updating it to your windows host**
  5) **Import sshkey** into your Azure Devops instance
"
END_MESSAGE_LONG=" This script installed all needed assets for SharePoint Framework Development environment following Microsoft guidance
  mentioned [here](https://learn.microsoft.com/en-us/sharepoint/dev/spfx/set-up-your-development-environment)

  1) Installed nvm , node (selected version), gulp-cli, yeoman,microsoft yeoman generator and spfxfastserve
  2) Created the sfpx self-signed developer certificate
  3) Imported the certificate to your windows local computer store
  4) Created the sshkey in wsl updating it to your windows host
  5) Imported sshkey into your Azure Devops instance
"
# Set the root folder for the core scripts
SCRIPTS_CORE_ROOT_FOLDER="$(dirname "$0")"
# Source the core script
# shellcheck disable=SC1091
source "$SCRIPTS_CORE_ROOT_FOLDER/../_core/core.sh"
# Print a separator
echo-print-separator "$modName"  "$modSection"
# Print the help message
echo-print "\n $HELP_MESSAGE_LONG"
# Initialize is_valid_input as 0

install-buildessential # this script is inside _core
# Call the function to install node
# shellcheck disable=SC1091
source "$SCRIPTS_CORE_ROOT_FOLDER/../node/Install.sh"
# Call the install gulp_yo_microsoftgen_spfxfastserve function       
# shellcheck disable=SC1091
source "$SCRIPTS_CORE_ROOT_FOLDER/gulp-Yo-Mgen-Fs.sh"
# Call the git config function    
# shellcheck disable=SC1091
source "$SCRIPTS_CORE_ROOT_FOLDER/git-Config.sh"
# Call the install-gulp_yo_microsoftgen_spfxfastserve function
# shellcheck disable=SC1091
source "$SCRIPTS_CORE_ROOT_FOLDER/../sys/wsl-SSHKeyGenerate.sh"    
# shellcheck disable=SC1091
source "$SCRIPTS_CORE_ROOT_FOLDER/../az/SSHKeyAddToAzDevops.sh"
# shellcheck disable=SC1091
source "$SCRIPTS_CORE_ROOT_FOLDER/../spfx/gulp-TrustDevCert.sh" "noprompt"
# Print the end message
echo-print "\n $END_MESSAGE_LONG"
# Print two newlines
echo-print "\n\n"