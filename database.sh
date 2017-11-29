sql2csv.exe --db $1 --query "select pzjar,pzclass from rules.pr_engineclasses where pzjar like '%%$2%%'" | grep -i "$3" | csvlook
