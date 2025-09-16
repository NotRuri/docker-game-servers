#!/usr/bin/env bash

echo
echo "------------------------------------------"
echo "        Terraria Dedicated Server         "
echo "------------------------------------------"
echo

if [[ $BIN == "" ]] || [[ ! $BIN =~ ^TerrariaServer* ]]; then
    BIN="TerrariaServer"
fi

if [[ ! -d "$PWD/srv" ]] || [[ ! -f "$PWD/srv/TerrariaServer"  ]]; then
    echo "[err] server files not found. please make sure to run installer first."
    exit -1
fi

echo -e "[verb] home: $HOME\n"
chmod +x $HOME/srv/TerrariaServer*
bin="$HOME/srv/$BIN"
echo -e "[verb] running '$bin' $PARAMS\n"
exec $bin $PARAMS
