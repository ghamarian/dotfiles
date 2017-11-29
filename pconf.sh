export newConf="/Users/ghama/pega/prpc-git/prgit/build/dist/configuration/augurs_${1}.properties"
cp /Users/ghama/pega/prpc-git/prgit/build/dist/configuration/augurs_7171.properties /Users/ghama/pega/prpc-git/prgit/build/dist/configuration/augurs_${1}.properties
sed -i "s/7171/${1}/g" $newConf
