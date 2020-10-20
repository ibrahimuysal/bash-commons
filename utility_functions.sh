#!/bin/bash
# This file contains utility helper functions
# @author ibrahim Uysal

# Sets bash options to environment
function set_sh_options {
    set -o nounset   # if uninitialised variable used, then exit
    set -o errexit   # if any command fails, then exit
    set -o pipefail  # if any subcommand fail in pipe "|" entire pipeline commands fail
}

# Checks the current user is root or not. 
function check_is_root {
    if [ "$EUID" -ne "0" ]; then
        echo "This script must be run as root"
    fi
}

# Enable debug after this function called at particular line
function enable_debug {
    set -x
}

# Disable debug after this function called at particular line
function disable_debug {
    set +x
}

# Enables trap for exit. Disables ctrl+C/Z/... to exit
function enable_exit_trap {
    trap 'echo " - Press Q to Exit..."' SIGINT SIGTERM SIGTSTP
}

# Trim string
function trim {
    local var="$*"
    var="${var#"${var%%[![:space:]]*}"}"  # remove leading whitespace characters
    var="${var%"${var##*[![:space:]]}"}"  # remove trailing whitespace characters  
    echo "$var"
}

# Convert all string values to lowercase
function to_lower {
    echo "$*" | tr '[:upper:]' '[:lower:]' # POSIX standart conversion
}

# Convert all string values to uppercase
function to_upper {
    echo "$*" | tr '[:lower:]' '[:upper:]' # POSIX standart conversion
}

# Capitalize first character of given string
function to_capitalize {
  local tmp=$*
  local str=""
  for index in ${tmp[@]}; do
    str="$str `echo $index | awk '{print toupper(substr($0,0,1))tolower(substr($0,2))}'`"
  done
  echo "$str"
}

# Check is the given string is null or empty
function is_null_or_empty {
    if [[ -z "$1" || "$1" == "null" ]]; then
        return 1
    else
        return 0
    fi
}

# Check string contains substring.Args: command $string $substring
function is_contains {
    if [[ "$1" == *"$2"* ]]; then
        return 0
    else
        return 1
    fi
}

# Check is command exist/installed on OS
function is_command_exist {
    if [ $(type -P $1) ]; then
        return 0
    else
        return 1
    fi
}

# Check is file exist at specified path. Ex:
#   if [ $(is_file_exist "test.txt") =="0" ]; then
#        append_to_file "test.txt" "test string to apped"
#   fi
function is_file_exist {
    if [ -f "$1" ]; then
        return 0
    else
        return 1
    fi
}

# Append text to given file. Args: command $file $text
function append_to_file {
    echo -e "$2" | tee -a "$1" >>/dev/null
}

# Check file contains given text. Args: command $file $text
function is_file_contains_text {
    grep -q "$1" "$2"
}

# Colorize and echo error RED
function colorize_error {
    echo  -e "\033[0;31m${1}\033[0m"
}

# Colorize and echo warnings  yellow
function colorize_warning {
    echo -e "\033[0;33m${1}\033[0m"
}

# Colorize and echo info cyan
function colorize_info {
    echo -e "\033[0;36m${1}\033[0m"
}

# Colorize and echo success green
function colorize_success {
    echo -e "\033[0;32m${1}\033[0m"
}

# Ask user to continue or not
function ask_to_continue {
        while :
        do
            read -p 'Do you want to Continue (yes/no?): ' answer
            case "${answer}" in
                [yY]|[yY][eE][sS]) return 0 ;;
                [nN]|[nN][oO]) return 1 ;;
            esac
        done
}

# generate alphanumeric string
function get_random {
    echo `openssl rand -base64 12`
}
