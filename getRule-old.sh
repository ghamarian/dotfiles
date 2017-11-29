#!/usr/bin/bash
set -e
set +x

[[ $1 = "--help" ]] && echo e.g.: ./getRule.sh portNumber searchTerm && exit 0
[[ $# -ne 2 ]] && echo Please adhere to the command format: ./getRule.sh portNumber searchTerm && exit 2

export dockerPartialName="$1"
export dockerInfo=`ssh root@augurs "docker ps | grep -i $dockerPartialName"`
export dockerID=`echo $dockerInfo | cut -f1 -d' '`
export dockerName=`echo $dockerInfo | awk '{print $NF}'`

export ruleName="*$2*"

export files=`ssh root@augurs "(docker exec -i $dockerID find /usr/share/tomcat7/work/Catalina/localhost/prweb -iname ${ruleName}java)"` 
export nrFiles=`echo $files | awk '{print NF}'`
export files=`echo $files| xargs`
export files=$(echo ${files} | sed 's/\$/\\\$/g')

echo "Getting $nrFiles rules $ruleName from $dockerName($dockerID)"

[[ $nrFiles -gt 50 ]] && echo too many files, make your search more refined! && exit 1

ssh root@augurs "docker exec -i $dockerID tar -cf rule.tar ${files} 2>/dev/null"
ssh root@augurs "docker cp $dockerID:rule.tar ."
scp root@augurs:rule.tar .
mkdir -p src
tar -xf rule.tar --strip-components=8 -C src/ 

#cleaning up
ssh root@augurs "docker exec -i $dockerID rm -rf rule.tar"
ssh root@augurs 'rm -rf rule.tar'
rm -rf rule.tar
