#!/bin/bash
# Define the module\section name
modName="SPFX"
modSection="SPFX DevCert"
# Define the help messages
# shellcheck disable=SC2034
HELP_MESSAGE="Installs SharePoint Framework Development Certificate"
HELP_MESSAGE_LONG="This script is will install the SharePoint Framework Development Certificate."

# Get the directory of the current script
SCRIPTS_CORE_ROOT_FOLDER="$(dirname "$0")"

# Source the core.sh script from the _core directory
# shellcheck disable=SC1091
source "$SCRIPTS_CORE_ROOT_FOLDER/../_core/core.sh"

# Define a function to install gulp-cli, yo, @microsoft/generator-sharepoint, and spfx-fast-serve
# Define a function to set git config
installdevcert() {
    # Print a separator with the module name and section
    echo-print-separator "$modName" "$modSection"
    # Print the help message
    echo-print "\n $HELP_MESSAGE_LONG"

    echo-print " Start"
    echo-print "  Create Dummy Spfx project ...\n"
    
    prompt="$1"

    if [[ $prompt == '' ]]; then
        # Initialize is_valid_input as 0
        is_valid_input=0
        # While loop that keeps asking for input until a valid number is entered
        while [[ $is_valid_input == 0 ]]; do
            # Prompt the user for input
            echo-print-n "${LIGHT_WHITE}  Select current Node.js version number (format V.X.Y.Z) ?${RESET} "
            # shellcheck disable=SC2162
            read input
            # Check if the input matches the pattern X.Y.Z where X, Y, and Z are numbers, and store the result in a variable
            is_valid_input=$(if [[ $input =~ ^[0-9]+(\.[0-9]+){0,2}$ ]]; then echo 1; else echo 0; fi)
            if [[ $is_valid_input == 0 ]]; then
                echo-print-n "  ${RED}Invalid input (format V.X.Y.Z) !${RESET}\n"
            fi
        done

        echo-print "  Activating nvm ...\n"
        export NVM_DIR="$HOME/.nvm"
        # shellcheck disable=SC1091
        [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"                   # This loads nvm
        # shellcheck disable=SC1091
        [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion
        
        nvm alias default "$input"
        nvm use "$input"
    fi
    cd ~ || exit
    ls
    echo-print "  Generating Dummy SPFx project ...\n"
    rndContent="dummyContent$RANDOM"
    yo @microsoft/sharepoint --solutionName $rndContent --framework "none" --componentType "webpart" --componentName $rndContent --componentDescription $rndNumber

    echo-print "\n  Generating Dev Certificate...\n"
    cd $rndContent|| exit
    gulp trust-dev-cert

    echo-print "\n  Install Dev Certificate in your Host machine ..."

    cd ~/.rushstack/|| exit
    
    windows_temp=$(wslpath "$(wslvar TEMP)")
    # shellcheck disable=SC2086
    windows_path=$(echo $SCRIPTS_CORE_ROOT_FOLDER | sed -e 's|/mnt/\(.\)|\1:|' -e 's|/|\\|g')
    # Change directory to the Windows temps directory
    # shellcheck disable=SC2164
    cd "$windows_temp" || exit
    file="$windows_temp/rushstack-serve.pem"
    # Copy file to temp directory
    cp ~/.rushstack/rushstack-serve.pem ./rushstack-serve.cer    
    cp ~/.rushstack/rushstack-serve.pem ./rushstack-serve.pem    
    # Convert the file path to Windows format
    fileTemp=$(echo "$file" | sed -e 's|/mnt/\(.\)|\1:|' -e 's|/|\\|g')
    # run the powershell script
    pwsh.exe -File "$windows_path\\..\\spfx\\TrustDevCert\\Start-Process.ps1"  -certPath "$fileTemp" 
    
    echo-print "\n  Dev Certificate is installed ! ..."
    
    echo-print "  Removing SPfx Project ..."
    cd ~ || exit
    #rm -r $rndContent
    echo-print "  Dummy SPfx Project removed !"
    printf "\n"
    echo-print " End"
}
installdevcert "$1"
