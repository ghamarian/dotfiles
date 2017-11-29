#!/usr/bin/bash
set -e
set -x

#[[ $1 = "--help" ]] && echo e.g.: ./getImage.sh portNumber  && exit 0
#[[ $# -ne 1 ]] && echo Please adhere to the command format: ./getImage.sh portNumber  && exit 2

#export dockerPartialName="$1"
#export dockerInfo=`ssh root@augurs "docker ps | grep -i $dockerPartialName"`
#export imageID=`echo $dockerInfo | cut -f2 -d' '`
#export dockerName=`echo $dockerInfo | awk '{print $NF}'`

#ssh root@augurs "docker save -o image_$dockerPartialName $imageID"
#scp root@augurs:image_$dockerPartialName .
#docker load -i image_$dockerPartialName
docker pull vamsregistry.rpega.com:5000/prpc_latest_dsm_postgresql9.3_tomcat7

mkdir -p logs
docker run -it -d --name $dockerName -v /logs:/usr/share/tomcat7/logs/ -p $dockerPartialName:8080 -p 1$dockerPartialName:5432 image_$dockerPartialName bash
docker exec -it $dockerName service postgresql start
docker exec -it $dockerName service tomcat7 start
docker exec -it $dockerName bash


