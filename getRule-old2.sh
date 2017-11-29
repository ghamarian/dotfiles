#!/bin/bash
set -e
set -x

export serverName="augurs"

[[ $1 = "--help" ]] && echo e.g.: ./getRule.sh portNumber searchTerm [-a] && exit 0
#[[ $# -ne 3 ]] && echo Please adhere to the command format: ./getRule.sh portNumber searchTerm && exit 2

export dockerPartialName="$1"
export dockerInfo=`ssh root@"${serverName}" "docker ps | grep -i $dockerPartialName"`
export dockerID=`echo $dockerInfo | cut -f1 -d' '`
export dockerName=`echo $dockerInfo | awk '{print $NF}'`
export genJavaDir="/usr/share/tomcat7/work/Catalina/localhost/prweb/PRGenJava/com"

export ruleName="*$2*"

if [[ $3 = "-a" ]] ; then
   export files=`ssh root@"${serverName}" "(docker exec -i $dockerID find ${genJavaDir} -iname ${ruleName}java)"` 
else
   export files=`ssh root@"${serverName}" "(docker exec -i $dockerID find ${genJavaDir} -iname ${ruleName}java | docker exec -i $dockerID xargs ls -rt  | docker exec -i $dockerID tail -1)"` 
fi

export nrFiles=`echo $files | awk '{print NF}'`
export files=`echo $files| xargs`
export files=$(echo ${files} | sed 's/\$/\\\$/g')

echo "Getting $nrFiles rules $ruleName from $dockerName($dockerID)"

[[ $nrFiles -gt 50 ]] && echo too many files, make your search more refined! && exit 1

ssh root@"${serverName}" "docker exec -i $dockerID tar -cf rule.tar ${files} 2>/dev/null"
ssh root@"${serverName}" "docker cp $dockerID:rule.tar ."
scp root@"${serverName}":rule.tar .
mkdir -p src
tar -xf rule.tar --strip-components=8 -C src/ 

#cleaning up
ssh root@"${serverName}" "docker exec -i $dockerID rm -rf rule.tar"
ssh root@"${serverName}" 'rm -rf rule.tar'
rm -rf rule.tar
