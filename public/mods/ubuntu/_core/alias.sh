#!/bin/bash
get_candy_bash_aliases() {
    # # The directory to search
    folder=$1

    # Start of the alias block
    # echo "# PNPWSL2 CANDY ALIAS STARTS HERE"

    # # Find all .sh files in the directory and its subdirectories, excluding core.sh and init.sh
    find "$folder" -type f -name "*.sh" ! -name "core.sh" ! -name "init.sh" ! -name "alias.sh" | while read -r file; do
        # Extract the parent directory name, directory name, and file name without extension
        parent_dir=$(basename "$(dirname "$(dirname "$file")")" | cut -c1-2)
        dir=$(basename "$(dirname "$file")")
        filename=$(basename "$file" .sh)

        # # Construct the alias command
        alias_name="pnpwsl2-$parent_dir-$dir-$filename"

        alias_command="alias $alias_name='bash $file'"
        alias_command="$alias_name() { bash '$file';}; export -f $alias_name"
        # # Print the alias command
        echo "$alias_command"

    done
        find "$folder" -type f -name "alias.sh" | while read -r file; do

        # # Construct the alias command
        alias_name="pnpwsl2-SyncAlias"
        alias_command="$alias_name() { bash '$file';}; export -f $alias_name"
        # # Print the alias command
        echo "$alias_command"
    done
    # echo "# PNPWSL2 CANDY ALIAS ENDS HERE"

}


ChangeBashRcFile() {

    pnpwsl2bashAliasFile=~/.bash_aliases_pnpwsl2
    output="if [ -f /home/s/.bash_aliases_pnpwsl2 ]; then source /home/s/.bash_aliases_pnpwsl2; fi"

    # The file to modify
    file="$HOME/.bashrc"

    # Convert the output to an array
    IFS=$'\n' read -rd '' -a output_array <<<"$output"

    # Process each line of the output
    for line in "${output_array[@]}"; do
        # echo "->$line"
        # Remove the line if it already exists in the file
        grep -vF "$line" "$file" >temp && mv temp "$file"
        # Add the line to the file
        echo "$line" >>"$file"
    done

    if [ -f "$pnpwsl2bashAliasFile" ]; then
        rm "$pnpwsl2bashAliasFile"
    fi
    touch "$pnpwsl2bashAliasFile"

    output=$(get_candy_bash_aliases "$1")

    # The file to modify
    file="$pnpwsl2bashAliasFile"

    # Convert the output to an array
    IFS=$'\n' read -rd '' -a output_array <<<"$output"

    # Process each line of the output
    for line in "${output_array[@]}"; do
        # echo "->$line"
        # Remove the line if it already exists in the file
        grep -vF "$line" "$file" >temp && mv temp "$file"
        # Add the line to the file
        echo "$line" >>"$file"

    done
}
echo "PnPWsl2 Alias start sync ..."
SCRIPT_ROOT="$(realpath "$(dirname "$0")")"
path=$(readlink -f "$SCRIPT_ROOT/../..")

ChangeBashRcFile "$path"
echo " Refresh bash profile ..."
source ~/.bash_aliases_pnpwsl2
echo "PnPWsl2 Alias is synced !"