#!/usr/bin/env bash
#
# Copyright (c) 2023 Ruri Yoshinova (github.com/NotRuri)
# All Rights Reserved
#

# ------------------------------------------------
# >>>>>>>>>>>>>>>>> Variables <<<<<<<<<<<<<<<<<<<<
# ------------------------------------------------

MNT_PATH="/mnt/minecraft"
META_URL="https://piston-meta.mojang.com/mc/game/version_manifest_v2.json"
VERSION_URL=""
LATEST_VERSION=""

# ------------------------------------------------
# >>>>>>>>>>>>>>>>> Functions <<<<<<<<<<<<<<<<<<<<
# ------------------------------------------------

function getLatestVersion() {
    if [[ $LATEST_VERSION == "" ]]; then
        LATEST_VERSION=$(curl -s https://piston-meta.mojang.com/mc/game/version_manifest_v2.json \
        | jq -r '.latest.release')
    fi
}

function getVersionURL() {
    VERSION_URL=$(curl -s https://piston-meta.mojang.com/mc/game/version_manifest_v2.json \
      | jq -r ".versions[] | select(.id == \"$1\") | .url")
}

function getServerURL() {
    SERVER_URL=$(curl -s "$1" | jq -r '.downloads.server.url')
}

function downloadServer() {
    local cmd="wget -qO $2 $1"
    echo -e "[verb] $cmd\n"
    eval $cmd
    echo
}

# ------------------------------------------------
# >>>>>>>>>>>>>>>>> Entrypoint <<<<<<<<<<<<<<<<<<<
# ------------------------------------------------

echo "------------------------------------------"
echo "       Minecraft Server Installer         "
echo "             >> v1.0.0 <<                 "
echo "     maintainer: github.com/NotRuri"
echo "------------------------------------------"
echo

if [ "$(id -u)" -ne 0 ]; then
    echo "[err] running as non-root is not supported. exiting."
    exit -1
fi

if [[ $VERSION == "" ]] && [[ $SERVER_URL == "" ]]; then
    echo "[err] version not specified. downloading official latest."
    getLatestVersion
    VERSION=$LATEST_VERSION
fi

echo -e "[verb] pwd: $PWD\n"

if [[ $SERVER_URL == "" ]]; then
    echo -e "[info] getting metadata\n"
    getVersionURL $VERSION

    echo -e "[info] getting server URL\n"
    getServerURL $VERSION_URL
fi

echo -e "[info] downloading $VERSION server.jar\n"
downloadServer $SERVER_URL $PWD/server.jar

echo -e "[info] finalizing"
chmod +x $PWD/server.jar

echo
echo "------------------------------------------"
echo "        installation completed            "
echo
echo "   now run: docker compose up -d server   "
echo "------------------------------------------"
echo
