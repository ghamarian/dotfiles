#!/bin/bash
set -x
export dockerName=$1
export port=$2

[[ $dockerName == "" ]] && dockerName=augur
[[ $port == ""  ]] && port=7272

#docker stop $dockerName (intentionally commented to avoid mistakes)
docker rm $dockerName
docker rmi $(docker images -q)
rm -rf /usr/local/Cellar/tomcat/8.5.16_1/libexec/work/Catalina/localhost/prweb
rm -rf /usr/local/Cellar/tomcat/8.5.16_1/libexec/logs/catalina.out
rm -rf /usr/local/Cellar/tomcat/8.5.16_1/libexec/logs/catalina*log

docker pull vamsregistry.rpega.com:5000/prpc_latest_dsm_postgresql9.3_tomcat7
#docker run -d -i --privileged=true -v /dev/urandom:/dev/random -v /opt/share:/opt/share:rw -p 27272:8000 -p 37272:7003 -p 17272:5432 -p 7272:8080 -p 29272:29272 -e JAVA_HOME=/usr/lib/jvm/default-java --name augur_7272 vamsregistry.rpega.com:5000/prpc_latest_dsm_postgresql9.3_tomcat7 bash

#below is the good one
#docker run -d -i --privileged=true -p 27272:8000 -p 37272:7003 -p 17272:5432 -p 7272:8080 -p 29272:29272 -e JAVA_HOME=/usr/lib/jvm/default-java --name $dockerName vamsregistry.rpega.com:5000/prpc_latest_dsm_postgresql9.3_tomcat7 bash

docker run -d -i --privileged=true -p 2$port:8000 -p 3$port:7003 -p 1$port:5432 -p $port:8080 -p 29272:29272 -e JAVA_HOME=/usr/lib/jvm/default-java --name $dockerName vamsregistry.rpega.com:5000/prpc_latest_dsm_postgresql9.3_tomcat7 bash
docker exec -it $dockerName  service postgresql start 
#docker exec -it $dockerName  service tomcat7 stop 

