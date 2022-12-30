#!/usr/bin/env bash
#
# SPDX-FileCopyrightText: Andrew Hayzen <ahayzen@gmail.com>
#
# SPDX-License-Identifier: MPL-2.0

set -e

SCRIPT=$(realpath "$0")
SCRIPTPATH=$(dirname "$SCRIPT")

BIN_TARGET="$SCRIPTPATH/bin/devbox"
NAME="devbox"
DATA_FOLDER="$HOME/.local/share/com.ahayzen.$NAME"

# Build the binary
"$SCRIPTPATH/build.sh"

# Symlink the binary
mkdir -p "$HOME/.local/bin"
if [ ! -L "$HOME/.local/bin/devbox" ] || [ ! -x "$HOME/.local/bin/devbox" ] || [ "$(realpath "$HOME/.local/bin/devbox")" != "$BIN_TARGET" ]; then
    ln -sf "$BIN_TARGET" "$HOME/.local/bin/devbox"
fi

# Install data
mkdir -p "$DATA_FOLDER"
cp -R "$SCRIPTPATH/data/." "$DATA_FOLDER"
