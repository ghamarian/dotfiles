#!/bin/bash
set -x

export serverName
export dockerPartialName

while getopts "h:s:" opt; do
    case "$opt" in
    h)  serverName="root@$OPTARG"
        ;;
    s)  dockerPartialName="$OPTARG"
        ;;
    a)  all=true
        ;;
    *)  echo "./allModels -h host -s stackName "
       exit 1
       ;;
    esac
done

shift $((OPTIND-1))

item="$@"

#export dockerInfo=`ssh root@augurs "docker ps | grep -i $dockerPartialName"`
export dockerInfo=`ssh $serverName "docker ps | grep -i $dockerPartialName"`
export dockerID=`echo $dockerInfo | cut -f1 -d' '`
export dockerName=`echo $dockerInfo | awk '{print $NF}'`

#export IP=$(ssh root@augurs "docker exec -i $dockerID hostname -I")
export IP=$(ssh $serverName "docker inspect $dockerID" | jq '.. | .Networks?.cloudbase.IPAddress ' | grep -v null)
if [[ $IP == "" ]]
then
 export IP=$(ssh  $serverName "docker inspect $dockerID" | jq '.. | .Networks?.bridge.IPAddress' | grep -v null )
fi

#ssh root@augurs "docker exec -i $dockerID /tomcat/cassandra/bin/cqlsh -u dnode_ext -p dnode_ext $IP -e 'select fk from adm.adm_scoringmodel'" | tail -n +4 | jq -C '.modelPartition.partition.pyName' | grep -v null

#ssh root@augurs "docker exec -i $dockerID /tomcat/cassandra/bin/cqlsh -u dnode_ext -p dnode_ext $IP -e 'select fk from adm.adm_scoringmodel'" | tail -n +4  | jq '..| .pyName?'  | grep -v null
ssh $serverName "docker exec -i $dockerID /tomcat/cassandra/bin/cqlsh -u dnode_ext -p dnode_ext $IP -e 'select fk from adm.adm_scoringmodel'" | tail -n +4  | jq '..| .pyName?'  | grep -v null
