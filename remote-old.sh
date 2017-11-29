#!/usr/bin/bash
#set -e
set -x

[[ $1 = "--help" ]] && echo e.g.: ./upload.sh portNumber && exit 0
[[ $# -lt 1 ]] && echo "Please adhere to the command format: ./upload.sh portNumber [--upload] [--reset]" && exit 2

export dockerPartialName="$1"
export dockerInfo=`ssh root@augurs "docker ps | grep -i $dockerPartialName"`
export dockerID=`echo $dockerInfo | cut -f1 -d' '`
export dockerName=`echo $dockerInfo | awk '{print $NF}'`

function executeInDocker() {
   ssh root@augurs "docker exec -i $1 sh -c \"$2\""
}

export IP=$(ssh root@augurs "docker exec -i $dockerID hostname -I")

if [[ "$3" == "--reset" ]]; then
   #ssh root@augurs "docker exec -i $dockerID touch /root/.pgpass"
   executeInDocker $dockerID "touch /root/.pgpass"
   #ssh root@augurs "docker exec -i $dockerID bash -c 'echo 127.0.0.1:5432:prpc:clean_tom_post:tom_post > /root/.pgpass'"
   executeInDocker $dockerID  "echo 127.0.0.1:5432:prpc:clean_tom_post:tom_post > /root/.pgpass"
   #ssh root@augurs "docker exec -i $dockerID chmod 600 /root/.pgpass"
   executeInDocker $dockerID "chmod 600 /root/.pgpass"
   #ssh root@augurs "docker exec -i $dockerID psql -h 127.0.0.1 -p 5432 -U clean_tom_post prpc -c 'truncate pr_data_adm_factory'"
   executeInDocker $dockerID "psql -h 127.0.0.1 -p 5432 -U clean_tom_post prpc -c 'truncate pr_data_adm_factory'"
   #ssh root@augurs "docker exec -i $dockerID /tomcat/cassandra/bin/cqlsh -u dnode_ext -p dnode_ext $IP -e 'drop keyspace adm'"
   executeInDocker $dockerID "/tomcat/cassandra/bin/cqlsh -u dnode_ext -p dnode_ext $IP -e 'drop keyspace adm'"
fi

git diff > mypatch.patch

scp mypatch.patch root@augurs:/tmp
#ssh root@augurs "docker exec -i $dockerID sh -c 'cd /adm/adm && git clean -df && git reset --hard HEAD'"
executeInDocker $dockerID  "cd /adm/adm && git clean -df && git reset --hard HEAD"
ssh root@augurs "docker cp /tmp/mypatch.patch $dockerID:/adm/adm"
#ssh root@augurs "docker exec -i $dockerID sh -c 'cd /adm/adm && git apply mypatch.patch'"
executeInDocker $dockerID "cd /adm/adm && git apply mypatch.patch"

if [[ "$2" == "--upload" ]]; then
   #ssh root@augurs "docker exec -i $dockerID sh -c 'cd /adm/adm/ && /root/.sdkman/candidates/gradle/current/bin/gradle build -x test'"
   executeInDocker $dockerID "cd /adm/adm/ && /root/.sdkman/candidates/gradle/current/bin/gradle build -x test"
   #ssh root@augurs "docker exec -i $dockerID sh -c 'cd /adm/adm && /adm/prpc-git/prgit/build/dist/prgit.sh pushdb augurs_$dockerPartialName'"
   executeInDocker $dockerID "cd /adm/adm && /adm/prpc-git/prgit/build/dist/prgit.sh pushdb augurs_$dockerPartialName"
   #ssh root@augurs "docker exec -i $dockerID service tomcat7 restart"
   executeInDocker $dockerID "service tomcat7 restart"
fi

