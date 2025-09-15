#!/usr/bin/env bash
#
# Copyright (c) 2023 Ruri Yoshinova (github.com/NotRuri)
# All Rights Reserved
#

# ------------------------------------------------
# >>>>>>>>>>>>>>>>> Functions <<<<<<<<<<<<<<<<<<<<
# ------------------------------------------------

function copyExistingFiles() {
    echo -e "[info] copying existing files.\n"
    cpcmd="cp -nR /mnt/l4d2-linux/left4dead2* . && \
           cp -nR /mnt/l4d2-linux/left4dead2_dlc* ."
    echo -e "[verb] executing $cpcmd\n"
    eval $cpcmd
}

function validateCredentials() {
    if [[ "${STEAM_USER}" == "" ]] || [[ "${STEAM_PASS}" == "" ]]; then
        echo -e "[warn] STEAM_USER is not set. using anonymous user.\n"
        STEAM_USER=anonymous
        STEAM_PASS=""
        STEAM_AUTH=""
    else
        echo -e "[info] user set to $STEAM_USER\n"
    fi
}

function validateFiles() {
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
}

function fixSteamClient() {
    if [ ! -d "$PWD/.steam" ]; then
        mkdir -p $PWD/.steam/sdk32
        mkdir -p $PWD/.steam/sdk64
        cp -v $HOME/steamcmd/linux32/steamclient.so $PWD/.steam/sdk32/steamclient.so
        cp -v $HOME/steamcmd/linux64/steamclient.so $PWD/.steam/sdk64/steamclient.so
    fi
}

# ------------------------------------------------
# >>>>>>>>>>>>>>>>> Entrypoint <<<<<<<<<<<<<<<<<<<
# ------------------------------------------------

echo "------------------------------------------"
echo " Left 4 Dead 2 Dedicated Server Installer "
echo "             >> v1.0.0 <<                 "
echo "     maintainer: github.com/NotRuri"
echo "------------------------------------------"
echo

if [ "$(whoami)" == "root" ]; then
    echo -e "[info] checking for existing files\n"
    if [ -d "/mnt/l4d2-linux" ]; then
        copyExistingFiles
    fi

    echo -e "[info] fixing permissions\n"
    chown -R 1000:1000 .

    exec su -c ./install.sh steam
else
    echo -e "[info] checking credentials\n"
    validateCredentials

    echo -e "[info] validating files\n"
    validateFiles

    echo -e "\n[info] finalizing installation\n"
    fixSteamClient

    echo "------------------------------------------"
    echo "        installation completed."
    echo "------------------------------------------"
    echo
fi
