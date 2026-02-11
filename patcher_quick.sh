#!/bin/bash

# Installation directories
INSTALL_DIR="$HOME/.local/bin"
#INSTALL_DIR="/opt"
#INSTALL_DIR="/usr/local/bin"

# Discord installer URL and channels
BRANCH="stable" #"stable", "ptb", "canary"
UPDATE_URL="https://discord.com/api/updates/$BRANCH?platform=linux"

SERVER_VER=$(curl -s $UPDATE_URL | jq -r .name)
LOCAL_VER=$(cat $INSTALL_DIR/Discord/resources/build_info.json | jq -r .version)
CHANNEL=$(cat $INSTALL_DIR/Discord/resources/build_info.json | jq -r .releaseChannel)

if [[ $SERVER_VER == "" ]]
then
    echo "The Discord servers are unavailable. Please try again later"
    exit 1
fi

if [[ $LOCAL_VER == "" ]]
then
    echo "A Discord installation doesn't seem to be installed at $INSTALL_DIR"
    echo "Please open this file and redirect the INSTALL_DIR variable to where it is installed"
    echo "If you need a new install, retry with the installer_stable script instead"
    exit 1
fi

if [[ $SERVER_VER == $LOCAL_VER ]] 
then
    echo "You have the latest $CHANNEL version installed ($LOCAL_VER). Nothing to do!"
    exit 0
else
    echo "Local version ($LOCAL_VER) does not match latest server version ($SERVER_VER)"
    cat $INSTALL_DIR/Discord/resources/build_info.json | 
    jq --arg SVER $SERVER_VER '.version = "\($SVER)"' > $INSTALL_DIR/Discord/resources/jqtmp | mv $INSTALL_DIR/Discord/resources/jqtmp $INSTALL_DIR/Discord/resources/build_info.json
fi

echo "Quick patcher complete"
