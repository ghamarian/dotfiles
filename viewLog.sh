#!/bin/bash
set -e
set +x

export dockerPartialName="$1"
export dockerInfo=`ssh root@augurs "docker ps | grep -i $dockerPartialName"`
export dockerID=`echo $dockerInfo | cut -f1 -d' '`
export dockerName=`echo $dockerInfo | awk '{print $NF}'`

echo "Tailing the logs of $dockerName"
shift
export terms="$@"
#export words=$(echo $terms|sed 's/ /\\\|/g')
#ssh root@augurs "(docker exec -i $dockerID tail -f /usr/share/tomcat7/logs/catalina.out)" | ack.cmd --passthru --smart-case -R "$terms"
#ssh root@augurs "(docker exec -i $dockerID tail -f /usr/share/tomcat7/logs/catalina.out)" | viewer.py $terms
ssh root@augurs "(docker exec -i $dockerID tail -f /usr/share/tomcat7/logs/catalina.out)" 
