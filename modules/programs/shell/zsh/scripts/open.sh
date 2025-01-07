#!/usr/bin/env bash

ERROR="\e[38;2;191;97;106m"
RESET="\e[0m"

function usage()
{
    cat << EOF
USAGE:

    open <file>
        -> open the <file>
    open <folder>
        -> open the folder
    open <picture>
        -> open the picture
EOF
exit 0
}

if [[ $# -gt 0 ]]; then
    case $1 in
        -h|--help)
            usage
            ;;
    esac
else
    echo -e "${ERROR}✖ invalid argument !${RESET}"
    exit 84
fi

if [ ! -e "$1" ]; then
    echo -e "${ERROR}✖ path ${RESET} \"$1\"${ERROR} does not exists!${RESET}"
    exit 84
fi

if [ -d "$1" ]; then
    thunar "$1" &> /dev/null &

elif [[ "$1" =~ \.pdf$ ]]; then
    zathura "$1" &> /dev/null &

elif [[ "$1" =~ \.png$ ]]; then
    qimgv "$1" &> /dev/null &

else
    xdg-open "$1" &> /dev/null &
fi

