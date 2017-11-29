#!/usr/bin/bash
set -e
set -x

[[ $1 = "--help" ]] && echo e.g.: ./getRule.sh portNumber searchTerm && exit 0
[[ $# -ne 2 ]] && echo Please adhere to the command format: ./getRule.sh portNumber searchTerm && exit 2

export dockerPartialName="$1"
export dockerInfo=`ssh root@augurs "docker ps | grep -i $dockerPartialName"`
export dockerID=`echo $dockerInfo | cut -f1 -d' '`
export dockerName=`echo $dockerInfo | awk '{print $NF}'`

export phrase="*$2*"

export IP=$(ssh root@augurs "docker exec -i $dockerID hostname -I")

#export WATCH="jps | grep -i bootstrap | cut -f1 -d\" \" | xargs jstack | grep \"decision.adm\""
export WATCH="sh -c 'jps | grep -i bootstrap | cut -f1 -d\" \" | xargs jstack | grep $pharse'"
#ssh root@augurs "docker exec -i $dockerID /usr/bin/watch $WATCH"
ssh root@augurs "docker exec -i $dockerID export TERM=xterm"
ssh root@augurs "docker exec -i $dockerID export DISPLAY=10.31.100.47:0"
ssh root@augurs "docker exec -i $dockerID sh -c '/usr/bin/watch ls'"
