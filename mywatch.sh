#!/bin/bash
while true; do
    (echo -en '\033[H'
        CMD="$@"
        bash -c "$CMD" | while read LINE; do 
            echo -n "$LINE"
            echo -e '\033[0K' 
        done
        echo -en '\033[J') | tac | tac 
    sleep 2 
done
