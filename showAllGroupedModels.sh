#!/bin/bash
set +x
export host="aug"
export port="7272"
export item="iphone"

[[ $# < 1 ]] && echo "showAllFactories.sh -h host -p port" && exit 1

while getopts "h:p:" opt; do
    case "$opt" in
    h)  host="$OPTARG"
        ;;
    p)  port="$OPTARG"
        ;;
    *)  echo "showAllFactories.sh -h host -p port"
       exit 1
       ;;
    esac
done

shift $((OPTIND-1))

item="$@"

#while read model; do echo "$model" ; factory.sh -h ${host} -p ${port} "$model" | jq -C '.analyzedData.predictorGroups.groups[].predictors ' ; echo "---------------------------" ; done < models| less

allModels.sh -h ${host} -s ${port} | while read model 
do
   echo $model
   factory.sh -h ${host} -p 1${port} "${model}" | jq -C '.. | .predictorGroups?.groups[]?.predictors | select (length  > 1)' | grep -v null
   echo "--------------------------";
done | less

