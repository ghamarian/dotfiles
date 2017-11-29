#!/bin/bash
set +x

export IP="$(lsof -i -n -P | grep -i listen | grep 9160 | awk '{print $(NF-1)}' | cut -d: -f1)"

/usr/local/Cellar/tomcat/8.5.16_1/libexec/cassandra/bin/cqlsh --request-timeout=3600 -u dnode_ext -p dnode_ext $IP 

