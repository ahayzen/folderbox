#!/usr/bin/env bash
#
# SPDX-FileCopyrightText: Andrew Hayzen <ahayzen@gmail.com>
#
# SPDX-License-Identifier: MPL-2.0

set -e

SCRIPT=$(realpath "$0")
SCRIPTPATH=$(dirname "$SCRIPT")

# shellcheck source=src/global.sh
source "$SCRIPTPATH/src/global.sh"
BIN_TARGET="$SCRIPTPATH/bin/$NAME"

# Build the binary
"$SCRIPTPATH/build.sh"

# Symlink the binary
mkdir -p "$HOME/.local/bin"
if [ ! -L "$HOME/.local/bin/$NAME" ] || [ ! -x "$HOME/.local/bin/$NAME" ] || [ "$(realpath "$HOME/.local/bin/$NAME")" != "$BIN_TARGET" ]; then
    ln -sf "$BIN_TARGET" "$HOME/.local/bin/$NAME"
fi

# Install data
mkdir -p "$DATA_FOLDER"
cp -R "$SCRIPTPATH/data/." "$DATA_FOLDER"
