#!/bin/bash

trap ctrl_c INT

function ctrl_c()
{
    echo -en "\033[?7h" #Enable line wrap
    echo -e "\033[?25h" #Enable cursor
    exit 0
}

function print_usage()
{
    echo
    echo '  Usage: cwatch [sleep time] "command"'
    echo '  Example: cwatch "ls -la"'
    echo
}

if [ $# -eq 0 ] || [ $# -gt 2 ]
then
    print_usage
    exit 1
fi

SLEEPTIME=1
if [ $# -eq 2 ]
then
    SLEEPTIME=${1}
    if [[ $SLEEPTIME = *[[:digit:]]* ]]
    then
        shift
    else
        print_usage
        exit 1
    fi
fi

CMD="${1}"
echo -en "\033[?7l" #Disable line wrap
echo -en "\033[?25l" #Disable cursor
while (true)
do

    (echo -en "\033[H" #Sets the cursor position where subsequent text will begin
    echo -e "Every ${SLEEPTIME},0s: '\033[1;36m${CMD}\033[0m'\033[0K"
    echo -e "\033[0K" #Erases from the current cursor position to the end of the current line
    BASH_ENV=~/.bashrc bash -O expand_aliases -c "${CMD}" | while IFS='' read -r LINE 
    do
        echo -n "${LINE}"
        echo -e "\033[0K" #Erases from the current cursor position to the end of the current line
    done
    #echo -en "\033[J") | tac | tac #Erases the screen from the current line down to the bottom of the screen
    echo -en "\033[J") #Erases the screen from the current line down to the bottom of the screen
    sleep ${SLEEPTIME}
done
