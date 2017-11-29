#!/bin/bash
set -x

export serverName
export dockerPartialName

while getopts "s:" opt; do
    case "$opt" in
    s)  dockerPartialName="$OPTARG"
        ;;
    *)  echo "./localAllModels -s stackName "
       exit 1
       ;;
    esac
done

shift $((OPTIND-1))

item="$@"

export dockerInfo=`docker ps | grep -i $dockerPartialName`
export dockerID=`echo $dockerInfo | cut -f1 -d' '`
export dockerName=`echo $dockerInfo | awk '{print $NF}'`

export IP="$(lsof -i -n -P | grep -i listen | grep 9160 | awk '{print $(NF-1)}' | cut -d: -f1)"
#export IP="$(docker exec -i $dockerID hostname -I)"
#export IP=$(docker inspect $dockerID | jq '.. | .Networks?.cloudbase.IPAddress ' | grep -v null)
#if [[ $IP == "" ]]
#then
 #export IP=$(docker inspect $dockerID | jq '.. | .Networks?.bridge.IPAddress' | grep -v null )
#fi

docker exec -i $dockerID /tomcat/cassandra/bin/cqlsh -u dnode_ext -p dnode_ext $IP -e 'select fk from adm.adm_scoringmodel' | tail -n +4  | jq '..| .pyName?'  | grep -v null

#/usr/local/Cellar/tomcat/8.5.16_1/libexec/cassandra/bin/cqlsh -u dnode_ext -p dnode_ext $IP -e 'select fk from adm.adm_scoringmodel' | tail -n +4  | jq '..| .pyName?'  | grep -v null

