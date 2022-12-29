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

# Symlink the binary
mkdir -p "$HOME/.local/bin"
if [ ! -x "$HOME/.local/bin/devbox" ]; then
    ln -s "$SCRIPTPATH/bin/devbox.sh" "$HOME/.local/bin/devbox"
fi

# Install common parts
mkdir -p "$DATA_FOLDER/common"
cp -R "$SCRIPTPATH/common" "$DATA_FOLDER/common"

# Install example container
mkdir -p "$DATA_FOLDER/containers"
cp -R "$SCRIPTPATH/containers" "$DATA_FOLDER/containers"
