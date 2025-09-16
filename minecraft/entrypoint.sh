#!/usr/bin/env bash

echo
echo "------------------------------------------"
echo "       Minecraft Dedicated Server         "
echo "------------------------------------------"
echo

if [[ $EULA != "true" ]]; then
    echo -e "[error] please accept the EULA by setting EULA=true in the environment"
    exit -1
fi

echo "eula=true" > $HOME/eula.txt
chmod +x "$HOME/server.jar"
CMD="java -version"
echo -e "[verb] running $CMD\n"
eval $CMD
echo

ARGS="$JVM_ARGS -jar server.jar nogui"
echo -e "[verb] running 'java $ARGS'\n"
exec java $ARGS
