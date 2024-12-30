#!/bin/bash

# Define module name
# modName="Core"
# modSection=""

# Define echo functions
echo-initialize()
{
    # Define color codes
    # shellcheck disable=SC2034
    RED=$(tput setaf 1)
    # shellcheck disable=SC2034
    GREEN=$(tput setaf 2)
    YELLOW=$(tput setaf 11)
    BLUE=$(tput setaf 6)
    LIGHT_WHITE=$(tput setaf 255)
    # shellcheck disable=SC2034
    WHITE=$(tput setaf 7)
    RESET=$(tput sgr0)
}

echo-print-separator () {
    # Create a separator line with module name and section
    modName=$1
    modSection=$2
    original_string=$(printf "%-100s" "#"|tr ' ' '#')
    sentence="[$modName] ## -  ## ($modSection)"
    sentence_length=${#sentence}
    sentence=" [${BLUE}$modName${RESET}](${YELLOW}$modSection${RESET}) "
    start_position=2
    modified_string="${original_string:0:start_position}$sentence${original_string:start_position+sentence_length}"

    printf "\n%s\n" "$modified_string"
}

echo-print () {
    # Print a message with light white color
    echo -e "${LIGHT_WHITE}$1${RESET}"
}

echo-print-n () {
    # Print a message without a newline at the end
    echo -n -e "$1"
}

# Define prompt functions
inquire () {
    # Ask a yes/no question
    echo-print-n "\n${LIGHT_WHITE}$1 ${YELLOW}[y/n]${RESET}? "
    echo-print-n " "
    while true; do
        read -n 1 -p "" yn
        case $yn in
            [Yy]* ) return 1;;
            [Nn]* ) return 0;;
            * ) echo -n -e "\b \b";;
        esac
    done
}
# Define prompt functions
inquireWithOptions () {
    # Ask a question with dynamic options
    local question=$1
    local option1=$2
    local option2=$3

    echo -n -e "\n${LIGHT_WHITE}${question} ${YELLOW}[${option1}/${option2}]${RESET}? "
    while true; do
        read -n 1 -p "" yn
        case $yn in
            [${option1^}${option1}] ) return 1;;
            [${option2^}${option2}] ) return 0;;
            * ) echo -n -e "\b \b";;
        esac
    done
}
install-nvm() {
    # Install Node Version Manager
    modSection="NVM"
    if [ -z "$modName" ]
    then
      modName="Core"
    fi
    echo-print-separator "$modName"  "$modSection"
    curl -sS -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash #> /dev/null 2>&1
    # shellcheck disable=SC1090
    source ~/.nvm/nvm.sh #> /dev/null 2>&1
    printf "\n\n"
    echo-print " NVM Installed"
}

install-node10() {
    # Install Node.js version 10
    modSection="node v10"
    if [ -z "$modName" ]
    then
      modName="Core"
    fi
    echo-print-separator "$modName"  "$modSection"
    echo-print " Start"
    echo-print "   Check if it is installed"
    if nvm ls | grep -q "v10"; then
        echo-print "   is installed!"
    else
        echo-print "   $modSection is not installed."
        echo-print "    $modSection install ..."

        printf "\n\n"
        nvm install 10 --no-colors
        nvm use 10 --no-colors
        echo-print "   $modSection installed !"
    fi
    echo-print " End"
}

install-buildessential()
{

    # Install build-essential package
    modSection="Build Essential tool "
    if [ -z "$modName" ]
    then
      modName="Core"
    fi
    echo-print-separator
    sudo apt-get install build-essential
    sudo apt update
    sudo apt upgrade
}

install-wslu(){
    # Install WSLU tools
    modSection="Wslu tools "
    ## add an if
    if [ -z "$modName" ]
    then
      modName="Core"
    fi
    echo-print-separator "$modName"  "$modSection"
    sudo apt update
    sudo apt install wslu
    # Set the file path
    bashrc_file="$HOME/.bashrc"
    # Read the entire content of the file
    file_content=$(<"$bashrc_file")
    # Remove the line containing "export BROWSER=wslview"
    modified_content=$(echo "$file_content" | grep -v "export BROWSER=wslview")
    # Save the modified content back to the file
    echo "$modified_content" > "$bashrc_file"
    echo ""| sudo tee -a "$HOME/.bashrc"
    echo "export BROWSER=wslview" | sudo tee -a "$HOME/.bashrc"
}

find_superuser() {
    # Find the superuser
    # Set the path to the /etc/passwd file
    passwd_file="/etc/passwd"

    # Set the UID and GID to search for
    uid_to_search=1000
    gid_to_search=1000

    # Use awk to search and extract the user
    result=$(awk -F':' -v uid="$uid_to_search" -v gid="$gid_to_search" '$3 == uid && $4 == gid {print $1}' $passwd_file)

    # Return the result
    echo "$result"
}

install-superuser-lastadded() {
    # Install the last added superuser
    modSection="SuperUser"
    if [ -z "$modName" ]
    then
      modName="Core"
    fi
    echo-print-separator "$modName"  "$modSection"
    echo-print " Start"
    echo-print "  Modify the /etc/wsl.conf file adding setup user as default user"

    # Path to wall.conf file
    wsl_conf_path="/etc/wsl.conf"
    # Call the function
    setup_username=$(find_superuser)
    echo -e "\n   SetupUser:$setup_username"
    if grep -q "^default=$setup_username$" "$wsl_conf_path"; then
        echo "   User ($setup_username) already exists in wsl.conf."
    else
        # Add default user to wall.conf
        echo "[user]" | sudo tee -a /etc/wsl.conf  > /dev/null
        echo "default=$setup_username" | sudo tee -a /etc/wsl.conf  > /dev/null
    fi
    echo -e "\n# WSL.Conf File #########"
    cat /etc/wsl.conf
    echo -e "\n#########################\n"

    echo-print " End"
}

install-azurecli() {
    # Install Azure CLI
    echo-print "\n Start"
    printf "\n\n"
    curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash #> /dev/null 2>&1
    az extension add --name azure-devops
    echo-print "\n   $modSection installed !"
    echo-print "\n End"
}


initialize () {
    # Initialize the script
    modSection="Initialize"
    if [ -z "$modName" ]
    then
      modName="Core"
    fi
    echo-print-separator "$modName"  "$modSection"
    echo-print "Bash Core loading ..."
    #get the directory of the script being run:
    SCRIPTS_CORE_ROOT_FOLDER="$(dirname "$0")"
    # shellcheck disable=SC2034
    SCRIPTS_MODS_ROOT_FOLDER="$(dirname "$SCRIPTS_CORE_ROOT_FOLDER")"
    echo-print  " Core functions loading ..."
    echo-initialize
    echo-print " Core functions loaded!"
    echo-print  "Bash Core loaded!"
}

# Initialize echo functions
echo-initialize