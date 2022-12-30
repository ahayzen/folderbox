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
BIN_TARGET="$SCRIPTPATH/bin/devbox"
PROJECT_FILES=(
    "src/global.sh"
    "src/utils.sh"
    "src/container/build.sh"
    "src/container/exec.sh"
    "src/container/main.sh"
    "src/container/podman.sh"
    "src/folders/box.sh"
    "src/folders/persist.sh"
    "src/folders/main.sh"
    "src/sandbox/alsa.sh"
    "src/sandbox/custom.sh"
    "src/sandbox/gdb.sh"
    "src/sandbox/git.sh"
    "src/sandbox/gpu.sh"
    "src/sandbox/group.sh"
    "src/sandbox/kvm.sh"
    "src/sandbox/name.sh"
    "src/sandbox/pipewire.sh"
    "src/sandbox/pulseaudio.sh"
    "src/sandbox/selinux.sh"
    "src/sandbox/ssh.sh"
    "src/sandbox/usb.sh"
    "src/sandbox/user.sh"
    "src/sandbox/wayland.sh"
    "src/sandbox/workdir.sh"
    "src/sandbox/x11.sh"
    "src/sandbox/xdg.sh"
    "src/sandbox/main.sh"
    "src/main.sh"
)

echo "#!/usr/bin/env bash" > "$BIN_TARGET"

for FILE in "${PROJECT_FILES[@]}"; do
    echo "" >> "$BIN_TARGET"
    cat "${FILE}" >> "$BIN_TARGET"
done

{
    echo ""
    echo 'main "$@"'
} >> "$BIN_TARGET"
chmod +x "$BIN_TARGET"

# Symlink the binary
mkdir -p "$HOME/.local/bin"
if [ ! -L "$HOME/.local/bin/devbox" ] || [ ! -x "$HOME/.local/bin/devbox" ] || [ "$(realpath "$HOME/.local/bin/devbox")" != "$BIN_TARGET" ]; then
    ln -sf "$BIN_TARGET" "$HOME/.local/bin/devbox"
fi

# Install data
mkdir -p "$DATA_FOLDER"
cp -R "$SCRIPTPATH/data/." "$DATA_FOLDER"
