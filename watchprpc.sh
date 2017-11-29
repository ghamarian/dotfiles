 watch sh -c 'jps | grep -i bootstrap | cut -f1 -d" "  | xargs jstack | grep decision | grep junit | tail -n 1 | cut -d" "  -f2'
