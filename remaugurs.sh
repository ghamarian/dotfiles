#!/usr/bin/bash
#set -e
set -x

[[ $1 = "--help" ]] && echo "e.g.: ./upload.sh portNumber [--upload] [--reset]" && exit 0
[[ $# -lt 1 ]] && echo "Please adhere to the command format: ./upload.sh portNumber [--upload] [--reset]" && exit 2

export host=augurs
export roothost="root@$host"

export dockerPortNumber="$1"
export dockerInfo=`ssh "$roothost" "docker ps | grep -i $dockerPortNumber"`
export dockerID=`echo $dockerInfo | cut -f1 -d' '`
export dockerName=`echo $dockerInfo | awk '{print $NF}'`

function executeInDocker() {
   ssh "$roothost" "docker exec -i $dockerID sh -c \"$1\""
}

function truncateCassandraTable() {
   executeInDocker "/tomcat/cassandra/bin/cqlsh -u dnode_ext -p dnode_ext $IP -e \"truncate adm.$1\""
}

export IP=$(executeInDocker "hostname -I")

if [[ "$3" == "--reset" ]]; then
   executeInDocker "touch /root/.pgpass"
   executeInDocker "echo 127.0.0.1:5432:prpc:clean_tom_post:tom_post > /root/.pgpass"
   executeInDocker "chmod 600 /root/.pgpass"
   executeInDocker "psql -h 127.0.0.1 -p 5432 -U clean_tom_post prpc -c 'truncate pr_data_adm_factory'"
   executeInDocker "psql -h 127.0.0.1 -p 5432 -U clean_tom_post prpc -c 'truncate pr_data_adm_configuration'"
   executeInDocker "/tomcat/cassandra/bin/cqlsh -u dnode_ext -p dnode_ext $IP -e 'drop keyspace adm'"
   #executeInDocker "/tomcat/cassandra/bin/cqlsh -u dnode_ext -p dnode_ext $IP -e 'truncate adm.adm_'"
   #truncateCassandraTable "adm_active_nodes"
   #truncateCassandraTable "adm_response_commit_log"
   #truncateCassandraTable "adm_scoringmodel"
   #truncateCassandraTable "adm_factory_handled_responses"
   #truncateCassandraTable "adm_response_meta_info"
fi

git diff > mypatch.patch

scp mypatch.patch "$roothost":/tmp
executeInDocker "cd /adm/adm && git clean -df && git reset --hard HEAD"
ssh "$roothost" "docker cp /tmp/mypatch.patch $dockerID:/adm/adm"
executeInDocker "cd /adm/adm && git apply mypatch.patch"

if [[ "$2" == "--upload" ]]; then
   executeInDocker "cd /adm/adm/ && /root/.sdkman/candidates/gradle/current/bin/gradle build -x test"
   executeInDocker "cd /adm/adm && /adm/prpc-git/prgit/build/dist/prgit.sh pushdb "$host"_$dockerPortNumber"
   executeInDocker "service tomcat7 restart"
fi
