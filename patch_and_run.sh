#!/bin/bash

# Installation directories
INSTALL_DIR="$HOME/.local/bin"
#INSTALL_DIR="/opt"
#INSTALL_DIR="/usr/local/bin"

function patch() {
    # Temporary working directory
    TEMP_DIR="/tmp/Discord"

    # Discord installer URL and channels
    UPDATE_URL="https://discord.com/api/updates/stable?platform=linux"
    DOWNLOAD_URL="https://discord.com/api/download"
    STABLE=$DOWNLOAD_URL"?platform=linux&format=tar.gz"
    #BETA=$DOWNLOAD_URL"/ptb?platform=linux&format=tar.gz"
    #CANARY=$DOWNLOAD_URL"/canary?platform=linux&format=tar.gz"

    SERVER_VER=$(curl -s $UPDATE_URL | jq -r .name)
    LOCAL_VER=$(cat $INSTALL_DIR/Discord/resources/build_info.json | jq -r .version)
    CHANNEL=$(cat $INSTALL_DIR/Discord/resources/build_info.json | jq -r .releaseChannel)

    # Errors if the version 
    if [[ $SERVER_VER == "" ]]
    then
        echo "The Discord servers are unavailable. Please try again later"
        return 1
    fi

    if [[ $LOCAL_VER == "" ]]
    then
        echo "A Discord installation doesn't seem to be installed at $INSTALL_DIR"
        echo "Please open this file and redirect the INSTALL_DIR variable to where it is installed"
        echo "If you need a new install, retry with the installer_stable script instead"
        return 1
    fi

    if [[ $SERVER_VER == $LOCAL_VER ]] 
    then
        echo "You have the latest $CHANNEL version installed ($LOCAL_VER). Nothing to do!"
        return 0
    else
        echo "Local version ($LOCAL_VER) does not match latest server version ($SERVER_VER)"
    fi

    #echo "Closing active Discord processes"
    #pkill Discord

    echo "Downloading Discord from $STABLE"
    notify-send --urgency=critical "Updating Discord..."
    curl -L -o "$TEMP_DIR/discord-stable.tar.gz" $STABLE --create-dirs

    echo "Updating Discord"
    tar -xzf $TEMP_DIR/discord-stable.tar.gz -C $INSTALL_DIR

    echo "Running post-install scripts"
    bash $INSTALL_DIR/Discord/postinst.sh

    echo "Done!"
    notify-send --urgency=critical "Discord updated successfully. Starting..."
}

patch
status=$?
if [[ $status == "0" ]];
then
    $INSTALL_DIR/Discord/Discord
else
    notify-send --urgency=critical "Error while updating Discord."
fi
