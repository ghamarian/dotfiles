#!/bin/bash
set -e
set +x

export serverName="vamssuper10-01"
export port="7272"
export all=false

[[ $1 = "--help" ]] && echo "./getRule2.sh -h host -s stackName searchTerm (e.g. ./getRule2.sh -h vamssuper10-02 -s mystack pzgetadmclient)" && exit 0
#[[ $# -ne 3 ]] && echo Please adhere to the command format: ./getRule.sh portNumber searchTerm && exit 2

[[ $# < 1 ]] && echo "./getRule2.sh -h host -s stackName searchTerm " && exit 1

while getopts "h:s:a" opt; do
    case "$opt" in
    h)  serverName="$OPTARG"
        ;;
    s)  dockerPartialName="$OPTARG"
        ;;
    a)  all=true
        ;;
    *)  echo "./getRule2.sh -h host -s stackName [-a] searchTerm "
       exit 1
       ;;
    esac
done

shift $((OPTIND-1))

item="$@"

#export dockerPartialName="$1"
export dockerInfo=`ssh root@"${serverName}" "docker ps | grep -i $dockerPartialName" | grep -i db`
export dockerID=`echo $dockerInfo | cut -f1 -d' '`
export dockerName=`echo $dockerInfo | awk '{print $NF}'`
export genJavaDir="/usr/share/tomcat7/work/Catalina/localhost/prweb/PRGenJava/com"

#export ruleName="*$2*"
export ruleName="*$item*"

if [[ $all = true ]] ; then
   export files=`ssh root@"${serverName}" "(docker exec -i $dockerID find ${genJavaDir} -iname ${ruleName}java)"` 
else
   export files=`ssh root@"${serverName}" "(docker exec -i $dockerID find ${genJavaDir} -iname ${ruleName}java | docker exec -i $dockerID xargs ls -rt  | docker exec -i $dockerID tail -1)"` 
fi

export nrFiles=`echo $files | awk '{print NF}'`
export files=`echo $files| xargs`
export files=$(echo ${files} | sed 's/\$/\\\$/g')

echo "Getting $nrFiles rules $ruleName from $dockerName($dockerID)"
echo "Fetching ..."
for f in $files
do
   echo $f | awk -F'/' '{print $NF}'
done

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
