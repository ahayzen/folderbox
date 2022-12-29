#!/usr/bin/env bash
#
# SPDX-FileCopyrightText: Andrew Hayzen <ahayzen@gmail.com>
#
# SPDX-License-Identifier: MPL-2.0

set -e

NAME="devbox"
DATA_FOLDER="$HOME/.local/share/com.ahayzen.$NAME"
SCRIPT=$(realpath "$0")
SCRIPTPATH=$(dirname "$SCRIPT")

# Build the binary
#
# For now this just copies the script, but later it could combine from multiple parts
mkdir -p "$SCRIPTPATH/bin"
cp "$SCRIPTPATH/src/devbox.sh" "$SCRIPTPATH/bin/devbox"
chmod +x "$SCRIPTPATH/bin/devbox"

# Symlink the binary
mkdir -p "$HOME/.local/bin"
if [ ! -L "$HOME/.local/bin/devbox" ] || [ ! -x "$HOME/.local/bin/devbox" ] || [ "$(realpath "$HOME/.local/bin/devbox")" != "$SCRIPTPATH/bin/devbox" ]; then
    ln -sf "$SCRIPTPATH/bin/devbox" "$HOME/.local/bin/devbox"
fi

# Install data
mkdir -p "$DATA_FOLDER"
cp -R "$SCRIPTPATH/data/." "$DATA_FOLDER"
