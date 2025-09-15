#!/usr/bin/env bash
#
# Copyright (c) 2023 Ruri Yoshinova (github.com/NotRuri)
# All Rights Reserved
#

# ------------------------------------------------
# >>>>>>>>>>>>>>>>> Variables <<<<<<<<<<<<<<<<<<<<
# ------------------------------------------------

MNT_PATH="/mnt/terraria"
SERV_URL="https://terraria.org/api/download/pc-dedicated-server/terraria-server-1449.zip"
SERV_PATH="/tmp/terraria-server.zip"

# ------------------------------------------------
# >>>>>>>>>>>>>>>>> Functions <<<<<<<<<<<<<<<<<<<<
# ------------------------------------------------

function installDeps() {
    local cmd="apt-get update -qqy && apt-get install -qqy curl unzip"
    echo -e "[verb] $cmd\n"
    eval $cmd
    echo
}

function downloadServer() {
    local cmd="curl -L -o $SERV_PATH $SERV_URL"
    echo -e "[verb] $cmd\n"
    eval $cmd
    echo
}

function extractServer() {
    local cmd="mkdir -p /tmp/terraria-server && \
        unzip -n $SERV_PATH -d /tmp/terraria-server && \
        rm -rf $MNT_PATH/srv && \
        mv /tmp/terraria-server/1449/Linux $MNT_PATH/srv"
    echo -e "[verb] $cmd\n"
    eval $cmd
}

# ------------------------------------------------
# >>>>>>>>>>>>>>>>> Entrypoint <<<<<<<<<<<<<<<<<<<
# ------------------------------------------------

echo "------------------------------------------"
echo "        Terraria Server Installer         "
echo "             >> v1.0.0 <<                 "
echo "     maintainer: github.com/NotRuri"
echo "------------------------------------------"
echo

if [ "$(id -u)" -ne 0 ]; then
    echo "[err] running as non-root is not supported. exiting."
    exit 1
fi

echo -e "[verb] pwd: $PWD\n"

echo -e "[info] installing dependencies\n"
installDeps

echo -e "[info] downloading server files\n"
downloadServer

echo -e "[info] extracting files\n"
extractServer

echo
echo "------------------------------------------"
echo "        installation completed            "
echo
echo "   now run: docker compose up -d server   "
echo "------------------------------------------"
echo
