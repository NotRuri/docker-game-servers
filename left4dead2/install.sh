#!/usr/bin/env bash

if [[ "$(whoami)" == "root" ]]; then
    echo "------------------------------------------"
    echo " Left 4 Dead 2 Dedicated Server Installer "
    echo "                v1.0.0"
    echo "     maintainer: github.com/NotRuri"
    echo "------------------------------------------"

    echo -e "[info] copying existing files\n"
    cpcmd="cp -nvR /mnt/l4d2-linux/left4dead2* . && \
           cp -nvR /mnt/l4d2-linux/left4dead2_dlc* ."
    echo -e "[verb] executing $cpcmd\n"
    eval $cpcmd

    echo -e "[info] fixing permissions & starting installation\n"
    chown -R 1000:1000 .
    exec su -c ./install.sh steam
    exit 0
fi

if [[ "${STEAM_USER}" == "" ]] || [[ "${STEAM_PASS}" == "" ]]; then
    echo -e "[warn] STEAM_USER is not set. using anonymous user.\n"
    STEAM_USER=anonymous
    STEAM_PASS=""
    STEAM_AUTH=""
else
    echo -e "[info] user set to $STEAM_USER\n"
fi

echo -e "[verb] installing app_id $SRCDS_APPID in $PWD\n"
echo -e "[verb] home dir: $HOME\n"

cmd="$HOME/steamcmd/steamcmd.sh +force_install_dir $PWD \
    +login $STEAM_USER $STEAM_PASS $STEAM_AUTH \
    +@sSteamCmdForcePlatformType windows \
    +app_update $SRCDS_APPID $INSTALL_FLAGS \
    +@sSteamCmdForcePlatformType linux \
    +app_update $SRCDS_APPID validate \
    +quit"

echo -e "[verb] executing command: \n$cmd\n"
eval $cmd

echo -e "[info] finalizing installation\n"

mkdir -p $PWD/.steam/sdk32
mkdir -p $PWD/.steam/sdk64
cp -v $HOME/steamcmd/linux32/steamclient.so $PWD/.steam/sdk32/steamclient.so
cp -v $HOME/steamcmd/linux64/steamclient.so $PWD/.steam/sdk64/steamclient.so

echo ""
echo "------------------------------------------"
echo "        installation completed."
echo "------------------------------------------"
