#!/bin/bash

# Installation directories
INSTALL_DIR="$HOME/.local/bin"
#INSTALL_DIR="/opt"
#INSTALL_DIR="/usr/local/bin"

# Start menu directory
MENU_DIR="$HOME/.local/share/applications/"

# Temporary working directory
TEMP_DIR="/tmp/Discord"

# Discord installer URL and channels
DOWNLOAD_URL="https://discord.com/api/download"
STABLE=$DOWNLOAD_URL"?platform=linux&format=tar.gz"
#BETA=$DOWNLOAD_URL"/ptb?platform=linux&format=tar.gz"
#CANARY=$DOWNLOAD_URL"/canary?platform=linux&format=tar.gz"


echo "Downloading Discord"
mkdir -p "$INSTALL_DIR"
curl -L -o "$TEMP_DIR/discord-stable.tar.gz" $STABLE --create-dirs

echo "Installing Discord to $INSTALL_DIR"
tar -xzf $TEMP_DIR/discord-stable.tar.gz -C $INSTALL_DIR

echo "Installing updater script"
cp "$(dirname $0)/patch_and_run.sh" "$INSTALL_DIR/Discord/"


# Modify the included .desktop file to where it is installed
cp $INSTALL_DIR/Discord/discord.desktop $INSTALL_DIR/Discord/discord.desktop.bkp
export INSTALL_DIR
perl -i -pe "s#(?<=(Exec=)).*#$INSTALL_DIR/Discord/patch_and_run.sh#gmi" $INSTALL_DIR/Discord/discord.desktop
perl -i -pe 's/(?<=(Icon=)).*/$ENV{INSTALL_DIR}\/Discord\/discord.png/gmi' $INSTALL_DIR/Discord/discord.desktop
perl -i -pe 's/(?<=(Path=)).*/$ENV{INSTALL_DIR}\/Discord/gmi' $INSTALL_DIR/Discord/discord.desktop

# Update the desktop shortcut
echo Updating the desktop shortcuts
mkdir -p "$MENU_DIR"
mv $INSTALL_DIR/Discord/discord.desktop "$MENU_DIR"
mv $INSTALL_DIR/Discord/discord.desktop.bkp $INSTALL_DIR/Discord/discord.desktop
cat $INSTALL_DIR/Discord/discord.desktop
xdg-desktop-menu forceupdate
