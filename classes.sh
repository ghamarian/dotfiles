#!/bin/bash
set +x
export host="augurs"
export port="17272"
export item="iphone"

[[ $# < 1 ]] && echo "classes.sh -h host -p port -j jar [-c classes]" && exit 1

# A POSIX variable
OPTIND=1         # Reset in case getopts has been used previously in the shell.

# Initialize our own variables:
output_file=""
verbose=0

while getopts "h:p:j:c:" opt; do
    case "$opt" in
    h)  host="$OPTARG"
        ;;
    p)  port="$OPTARG"
        ;;
    c)  class="$OPTARG"
        ;;
    j)  jar="$OPTARG"
        ;;
    *)  echo "classes.sh -h host -p port -j jar [-c classes]"
       exit 1
       ;;
    esac
done

[[  -z $host ||  -z $port || -z $jar ]] && echo "please follow this: classes.sh -h host -p port -j jar [-c classes]" && exit 1

shift $((OPTIND-1))

export db="postgresql://clean_tom_post:tom_post@${host}:${port}/prpc"
item="$@"


if [[ ! -z "$class" ]]; then
   sql2csv --db $db --query "select pzjar,pzpackage,pzclass,pzpatchdate from rules.pr_engineclasses where pzjar like '%%"$jar"%%'" | grep -i "$class" | csvlook --no-inference
else
   sql2csv --db $db --query "select distinct pzjar,pzpatchdate, pzcodesetversion from rules.pr_engineclasses where pzjar like '%%"$jar"%%'" | csvlook --no-inference
fi

