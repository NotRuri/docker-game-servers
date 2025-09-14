#!/usr/bin/env bash

echo "------------------------------------------"
echo "      Left 4 Dead 2 Dedicated Server      "
echo "------------------------------------------"
echo ""

export HOME=$PWD
echo -e "[verb] home dir: $HOME\n"

cmd="./srcds_run -console -port ${PORT:=27015} +map ${DEFAULT_MAP:=c1m2_streets} $CVARS $FLAGS"
echo -e "[verb] running $cmd\n"
exec $cmd
