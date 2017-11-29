#!/bin/bash
set +x
export port="7272"
export item="iphone"

[[ $# < 1 ]] && echo "tomcatShowAllFactories.sh -p port" && exit 1

while getopts "p:" opt; do
    case "$opt" in
    p)  port="$OPTARG"
        ;;
    *)  echo "tomcatShowAllFactories.sh -p port"
       exit 1
       ;;
    esac
done

shift $((OPTIND-1))

item="$@"

#while read model; do echo "$model" ; factory.sh -h ${host} -p ${port} "$model" | jq -C '.analyzedData.predictorGroups.groups[].predictors ' ; echo "---------------------------" ; done < models| less

tomcatAllModels.sh | while read model 
do
   echo $model
   localFactory.sh -p 1${port} "${model}" | jq -C '.. | .predictorGroups?.groups[]?.predictors | select (length  > 1)' | grep -v null
   echo "--------------------------";
done | less
