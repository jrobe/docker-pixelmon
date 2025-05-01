#!/bin/bash

set -x

cd /data

if ! [[ "$EULA" = "false" ]]; then
	echo "eula=true" > eula.txt
else
	echo "You must accept the EULA to install."
	exit 99
fi

if ! [[ -f serverpack843.zip ]]; then
    rm -fr configs defaultconfigs kubejs libraries mods forge-*.jar server-setup-config.yaml server-start.* serverstarter-*.jar Enigmatica6Server-*.zip
	rm -fr config defaultconfigs global_data_packs global_resource_packs mods packmenu libraries
	curl -Lo serverpack843.zip 'https://edge.forgecdn.net/files/4348/486/serverpack843.zip' && unzip -u -o 'serverpack843.zip' -d /data
	if [[ -d serverpack ]]; then
	  mv -f serverpack/* /data/
	  rm -fr serverpack
  fi
	chmod u+x Install.sh
	./Install.sh
fi

if [[ -n "$MAX_RAM" ]]; then
	sed -i "s/maxRam:.*/maxRam: $MAX_RAM/" /data/server-setup-config.yaml
fi
if [[ -n "$MOTD" ]]; then
    sed -i "s/motd\s*=/ c motd=$MOTD" /data/server.properties
fi
if [[ -n "$OPS" ]]; then
    echo $OPS | awk -v RS=, '{print}' > ops.txt
fi

sed -i 's/server-port.*/server-port=25565/g' server.properties

. ./settings.sh

java -server ${JVM_OPTS} ${JAVA_PARAMETERS} -jar ${SERVER_JAR} nogui