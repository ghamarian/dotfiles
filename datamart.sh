sql2csv.exe --db $db -H --query "select pyfactory from rules.pr_data_adm_factory where pymodelpartition like '%%$1%%'" | sed 's/""/"/g' |  head -c -2 | tail -c +2
