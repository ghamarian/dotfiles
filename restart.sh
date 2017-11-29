#!/bin/bash
set -e
set +x

export dockerPartialName="$1"
export dockerInfo=`ssh root@augurs "docker ps | grep -i $dockerPartialName"`
export dockerID=`echo $dockerInfo | cut -f1 -d' '`
export dockerName=`echo $dockerInfo | awk '{print $NF}'`

echo "restarting $dockerName"

ssh root@augurs "(docker exec -i $dockerID service tomcat7 restart)"
