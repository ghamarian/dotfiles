find /usr/local/Cellar/tomcat/8.5.16_1/libexec/work/Catalina/localhost/prweb/PRGenJava  -iname "*$1*" | xargs ls -rt1 | tail -1 | awk -F "/" '{print $NF}' | sed 's/\.java//g' | pbcopy
