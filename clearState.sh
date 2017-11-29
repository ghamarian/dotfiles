set -x
export IP="$(hostname -I)"
/tomcat/cassandra/bin/cqlsh -u dnode_ext -p dnode_ext $IP -e 'truncate data.adm_responsecount'
/tomcat/cassandra/bin/cqlsh -u dnode_ext -p dnode_ext $IP -e 'truncate data.adm_response'
/tomcat/cassandra/bin/cqlsh -u dnode_ext -p dnode_ext $IP -e 'truncate data.adm_factory_handled_responses'
/tomcat/cassandra/bin/cqlsh -u dnode_ext -p dnode_ext $IP -e 'truncate data.adm_scoringmodel'
psql -h 127.0.0.1 -p 5432 -U clean_tom_post prpc -c 'truncate pr_data_adm_factory'
