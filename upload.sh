#!/usr/bin/bash
#set -e
set -x

[[ $1 = "--help" ]] && echo e.g.: ./upload.sh portNumber && exit 0
[[ $# -ne 1 ]] && echo Please adhere to the command format: ./upload.sh portNumber && exit 2

export dockerPartialName="$1"
export dockerInfo=`ssh root@augurs "docker ps | grep -i $dockerPartialName"`
export dockerID=`echo $dockerInfo | cut -f1 -d' '`
export dockerName=`echo $dockerInfo | awk '{print $NF}'`

export IP=$(ssh root@augurs "docker exec -i $dockerID hostname -I")

ssh root@augurs "docker exec -i $dockerID touch /root/.pgpass"
ssh root@augurs "docker exec -i $dockerID bash -c 'echo 127.0.0.1:5432:prpc:clean_tom_post:tom_post > /root/.pgpass'"
ssh root@augurs "docker exec -i $dockerID chmod 600 /root/.pgpass"

ssh root@augurs "docker exec -i $dockerID psql -h 127.0.0.1 -p 5432 -U clean_tom_post prpc -c 'truncate pr_data_adm_factory'"
ssh root@augurs "docker exec -i $dockerID /tomcat/cassandra/bin/cqlsh -u dnode_ext -p dnode_ext $IP -e 'drop keyspace adm'"

#ssh root@augurs "docker exec -i $dockerID /tomcat/cassandra/bin/cqlsh -u dnode_ext -p dnode_ext $IP -e 'truncate adm.adm_responsecount'"
#ssh root@augurs "docker exec -i $dockerID /tomcat/cassandra/bin/cqlsh -u dnode_ext -p dnode_ext $IP -e 'truncate adm.adm_response'"
#ssh root@augurs "docker exec -i $dockerID /tomcat/cassandra/bin/cqlsh -u dnode_ext -p dnode_ext $IP -e 'truncate adm.adm_factory_handled_responses'"
#ssh root@augurs "docker exec -i $dockerID /tomcat/cassandra/bin/cqlsh -u dnode_ext -p dnode_ext $IP -e 'truncate adm.adm_scoringmodel'"

gradle build -x test

prgit.bat pushdb augurs_$dockerPartialName

ssh root@augurs "docker exec -i $dockerID service tomcat7 restart"
