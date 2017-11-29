#!/bin/bash
set +x
export host="augurs"
export port="17272"
export item="iphone"

[[ $# < 1 ]] && echo "factory.sh -h host -p port modelname" && exit 1

# A POSIX variable
OPTIND=1         # Reset in case getopts has been used previously in the shell.

# Initialize our own variables:
output_file=""
verbose=0

while getopts "h:p:" opt; do
    case "$opt" in
    h)  host="$OPTARG"
        ;;
    p)  port="$OPTARG"
        ;;
    *)  echo "factory.sh -h host -p port modelname"
       exit 1
       ;;
    esac
done

shift $((OPTIND-1))

export db="postgresql://clean_tom_post:tom_post@${host}:${port}/prpc"
item="$@"

sql2csv --db $db -H --query "select pyfactory from rules.pr_data_adm_factory where pymodelpartition like '%%${item}%%'" | sed 's/""/"/g' |  head -c -2 | tail -c +2
#sql2csv --db $db -H --query "select pyfactory from rules.pr_data_adm_factory where pymodelpartition like '%%${item}%%'" | sed 's/""/"/g' 
#sql2csv --db $db -H --query "select pyfactory from rules.pr_data_adm_factory where pymodelpartition like '%%${item}%%'" 

