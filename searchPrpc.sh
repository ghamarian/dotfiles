#!/usr/bin/bash
set -e
set +x

export dockerPartialName="$1"
export dockerInfo=`ssh root@augurs "docker ps | grep -i $dockerPartialName"`
export dockerID=`echo $dockerInfo | cut -f1 -d' '`
export dockerName=`echo $dockerInfo | awk '{print $NF}'`

export searchTerm="\"$2\""

echo "searching $dockerName for $searchTerm"
export command="ack-grep --smart-case --java $searchTerm /usr/share/tomcat7/work/Catalina/localhost/prweb/PRGenJava/com/pegarules/generated"

#ssh root@augurs "docker exec -i $dockerID find /usr/share/tomcat7/work/Catalina/localhost/prweb -name *.java | docker exec -i $dockerID xargs grep -il $searchTerm | docker exec -i $dockerID xargs -i basename {}  \;"
#ssh root@augurs "docker exec -i $dockerID find /usr/share/tomcat7/work/Catalina/localhost/prweb -name *.java | docker exec -i $dockerID xargs grep -i $searchTerm | docker exec -i $dockerID sed '/generated/!d' | docker exec -i $dockerID sed 's/.usr.*generated.//g'"
ssh root@augurs "docker exec -i $dockerID find /usr/share/tomcat7/work/Catalina/localhost/prweb/PRGenJava/com/pegarules/generated -name *.java | docker exec -i $dockerID xargs ack-grep -i $searchTerm | docker exec -i $dockerID sed '/generated/!d' | docker exec -i $dockerID sed 's/.usr.*generated.//g'"
#ssh root@augurs "docker exec -i $dockerID $command"
#ssh root@augurs "docker exec -i $dockerID find /usr/share/tomcat7/work/Catalina/localhost/prweb/PRGenJava/com/pegarules/generated -name *.java | docker exec -i $dockerID xargs ack-grep -i $searchTerm "
#ssh root@augurs "docker exec -i $dockerID ack-grep --smart-case --java $searchTerm /usr/share/tomcat7/work/Catalina/localhost/prweb/PRGenJava/com/pegarules/generated"
