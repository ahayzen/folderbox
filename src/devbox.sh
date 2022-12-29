#!/usr/bin/env bash
#
# SPDX-FileCopyrightText: Andrew Hayzen <ahayzen@gmail.com>
#
# SPDX-License-Identifier: MPL-2.0

set -e

function find_exec_on_host()
{
    if [ -n "$container" ]; then
        if [ "$container" == "podman" ]; then
            if [ -x "$(command -v distrobox-host-exec)" ]; then
                # Ensure host-exec is installed
                distrobox-host-exec --yes whoami &>/dev/null

                # Check if command -v is able to find the exec on the host
                if [ -n "$(distrobox-host-exec --yes command -v "$1")" ]; then
                    RET="distrobox-host-exec --yes $1"
                else
                    echo "Could not find $1 on the host from inside container"
                    exit 1
                fi
            else
                echo "Could not find route to $1 on the host from inside container"
                exit 1
            fi
        else
            echo "Unknown container variable set"
            exit 1
        fi
    elif [ -x "$(command -v "$1")" ]; then
        RET="$1"
    else
        echo "Could not find $1 on the host"
        exit 1
    fi
}

#
# Prepare common variables and check state
#
NAME="devbox"
USER="$(whoami)"
DATA_FOLDER="$HOME/.local/share/com.ahayzen.$NAME"

# No args so show help
if [ -z "$1" ]; then
    echo "Usage:"
    echo "# expects .devbox folder with box definition"
    echo "devbox ~/path/to/project"
    echo ""
    echo "# expects boxname in $DATA_FOLDER/containers"
    echo "devbox boxname ~/path/to/project"
    exit 0
fi

# Determine folders
if [ -d "$1/.devbox" ]; then
    if [ -n "$2" ]; then
        echo "Unexpected argument after folder"
        exit 1
    fi

    BOX_NAME="$(basename "$(realpath "$1")")"
    CONTAINER_FOLDER="$(realpath "$1/.devbox")"
    WORK_FOLDER="$(realpath "$1")"
elif [ -d "$DATA_FOLDER/containers/$1" ]; then
    if [ -z "$2" ]; then
        echo "Expected folder after container name"
        exit 1
    fi

    BOX_NAME="$1"
    CONTAINER_FOLDER="$DATA_FOLDER/containers/$1"
    WORK_FOLDER="$(realpath "$2")"
else
    echo "Could not find devbox for '$1'"
    exit 1
fi

if [ ! -d "$WORK_FOLDER" ]; then
    echo "Work folder does not exist"
    exit 1
fi

PERSIST_FOLDER="$DATA_FOLDER/persist/$BOX_NAME"
TAG_NAME="$NAME-$BOX_NAME"

# Ensure all volume mounts exists
mkdir -p "$PERSIST_FOLDER/home/"
mkdir -p "$PERSIST_FOLDER/home/.config/"
touch "$PERSIST_FOLDER/home/.bashrc"
mkdir -p "$PERSIST_FOLDER/run/"

mkdir -p "$HOME/.config/git"
mkdir -p "$HOME/.ssh"

#
# Find execs and env vars we assume exist
#
printf "(%s) Finding Podman ... " "$TAG_NAME"
find_exec_on_host podman
PODMAN_EXEC="$RET"

printf "\r(%s) Finding groups ... " "$TAG_NAME"
find_exec_on_host groups
GROUP_ITEMS="$($RET)"

printf "\r(%s) Finding SSH ... " "$TAG_NAME"
if [ -z "${SSH_AUTH_SOCK}" ]; then
    echo "No SSH_AUTH_SOCK set"
    exit 1
else
    SSH_AUTH_SOCK_PATH=$(realpath "$SSH_AUTH_SOCK")
fi

if [ ! -S "${SSH_AUTH_SOCK_PATH}" ]; then
    echo "No ${SSH_AUTH_SOCK_PATH} socket"
    exit 1
fi

printf "\r(%s) Finding X11 ... " "$TAG_NAME"
if [ -z "${XAUTHORITY}" ]; then
    echo "No XAUTHORITY set"
    exit 1
else
    XAUTHORITY_PATH=$(realpath "$XAUTHORITY")
fi

printf "\r(%s) Finding XDG ... " "$TAG_NAME"
if [ -z "${XDG_RUNTIME_DIR}" ]; then
    echo "No XDG_RUNTIME_DIR set"
    exit 1
fi

printf "\r(%s) Finding Wayland ... " "$TAG_NAME"
if [ -z "${WAYLAND_DISPLAY}" ]; then
    echo "No WAYLAND_DISPLAY set"
    exit 1
fi

if [ ! -S "${XDG_RUNTIME_DIR}/${WAYLAND_DISPLAY}" ]; then
    echo "No ${XDG_RUNTIME_DIR}/${WAYLAND_DISPLAY} socket"
    exit 1
fi

printf "\r(%s) Finding Pipewire ... " "$TAG_NAME"
if [ -z "${PIPEWIRE_REMOTE}" ]; then
    PIPEWIRE_REMOTE="pipewire-0"
fi

if [ ! -S "${XDG_RUNTIME_DIR}/${PIPEWIRE_REMOTE}" ]; then
    echo "No ${XDG_RUNTIME_DIR}/${PIPEWIRE_REMOTE} socket"
    exit 1
fi

printf "\r(%s) Finding Pulseaudio ... " "$TAG_NAME"

# Find the socket
PULSEAUDIO_HOST_SOCKET="${XDG_RUNTIME_DIR}/pulse/native"
PULSEAUDIO_CLIENT_SOCKET="${XDG_RUNTIME_DIR}/pulse/native"
if [ ! -S "${PULSEAUDIO_HOST_SOCKET}" ]; then
    echo "No ${PULSEAUDIO_HOST_SOCKET} socket"
    exit 1
fi

# Setup config for the guest
PULSEAUDIO_HOST_CONFIG="$PERSIST_FOLDER/pulseaudio.client.config"
PULSEAUDIO_CLIENT_CONFIG="${XDG_RUNTIME_DIR}/pulse/client.config"
echo "enable-shm = false" > "$PULSEAUDIO_HOST_CONFIG"

printf "\r\033[0K"

#
# Build the container image
#
printf "(%s) Building ... " "$TAG_NAME"
if [ -z "$( $PODMAN_EXEC images -q "$TAG_NAME" )" ]; then
    # Find the container definition
    if [ -f "$CONTAINER_FOLDER/Containerfile.in" ]; then
        CONTAINER_FILE="Containerfile.in"
    elif [ -f "$CONTAINER_FOLDER/Containerfile" ]; then
        CONTAINER_FILE="Containerfile"
    else
        CONTAINER_FILE=""
    fi

    # Build the image
    BUILD_OUTPUT=$($PODMAN_EXEC build \
        --file="$CONTAINER_FILE" \
        --tag="$TAG_NAME" \
        "$CONTAINER_FOLDER" 2>&1 || true)

    # Check if the image exists
    if [ -z "$( $PODMAN_EXEC images -q "$TAG_NAME" )" ]; then
        echo "$BUILD_OUTPUT"
        echo ""
        echo "Failed to build container"
        exit 1
    fi
fi
printf "\r\033[0K"

#
# Prepare permissions and run args
#

ALSA_PERMISSIONS=(--device=/dev/snd:/dev/snd)
GDB_PERMISSIONS=(--cap-add=SYS_PTRACE --security-opt=seccomp=unconfined)
GIT_PERMISSIONS=(--volume="$HOME/.config/git":"$HOME/.config/git":rw)
# Passthrough certain groups from the host into the container that might be useful
GROUP_PERMISSIONS=()
for item in $GROUP_ITEMS
do
    if [ "$item" == "dialout" ] || [ "$item" == "kvm" ] || [ "$item" == "video" ]; then
        GROUP_PERMISSIONS+=("--group-add=$item")
    fi
done
KVM_PERMISSIONS=(--device=/dev/kvm:/dev/kvm)
PIPEWIRE_PERMISSIONS=(--env=PIPEWIRE_REMOTE="${PIPEWIRE_REMOTE}" --volume="${XDG_RUNTIME_DIR}/${PIPEWIRE_REMOTE}":"${XDG_RUNTIME_DIR}/${PIPEWIRE_REMOTE}":rw)
PULSEAUDIO_PERMISSIONS=(--env=PULSE_SERVER="unix:${PULSEAUDIO_CLIENT_SOCKET}" --volume="${PULSEAUDIO_HOST_SOCKET}":"${PULSEAUDIO_CLIENT_SOCKET}":rw --env=PULSE_CLIENTCONFIG="${PULSEAUDIO_CLIENT_CONFIG}" --volume="${PULSEAUDIO_HOST_CONFIG}":"${PULSEAUDIO_CLIENT_CONFIG}":ro)
SELINUX_PERMISSIONS=(--security-opt=label=type:container_runtime_t)
SSH_PERMISSIONS=(--env=SSH_AUTH_SOCK="$SSH_AUTH_SOCK_PATH" --volume="$(dirname "$SSH_AUTH_SOCK_PATH")":"$(dirname "$SSH_AUTH_SOCK_PATH")":rw --volume="$HOME/.ssh":"$HOME/.ssh":rw)
# Need to use volume mount otherwise devices don't work with adb
USB_PERMISSIONS=(--volume=/dev/bus/usb:/dev/bus/usb)
# Use same ids inside the container as outside
# Ensure that the passwd entry has the correct HOME ( https://github.com/containers/podman/issues/13185 )
USER_PERMISSIONS=(--passwd-entry="$USER:*:$UID:$UID:$USER:$HOME:/bin/bash" --env=USER --userns=keep-id)
WAYLAND_PERMISSIONS=(--env=WAYLAND_DISPLAY --volume="$XDG_RUNTIME_DIR/$WAYLAND_DISPLAY":"$XDG_RUNTIME_DIR/$WAYLAND_DISPLAY":rw)
XDG_PERMISSIONS=(--env=HOME --volume="$PERSIST_FOLDER/home":"$HOME":rw --env=XDG_RUNTIME_DIR --volume="$PERSIST_FOLDER/run":"$XDG_RUNTIME_DIR":rw)
X11_PERMISSIONS=(--device=/dev/dri:/dev/dri --env=DISPLAY --volume=/tmp/.X11-unix:/tmp/.X11-unix:rw --env=XAUTHORITY="$XAUTHORITY_PATH" --volume="$XAUTHORITY_PATH":"$XAUTHORITY_PATH":rw)

CONTAINER_NAME=(--hostname="$BOX_NAME" --name="$BOX_NAME")
TARGET_FOLDER_MOUNT=(--volume="$WORK_FOLDER":"$WORK_FOLDER":rw --workdir="$WORK_FOLDER")

if [ -f "$CONTAINER_FOLDER/runargs" ]; then
    mapfile -t CUSTOM_RUN_ARGS < "$CONTAINER_FOLDER/runargs"
else
    CUSTOM_RUN_ARGS=()
fi

#
# Run a container

# Create the container with the args, this could take a while the first time with userns=keep-id
printf "(%s) Creating (first time may take a while) ... " "$TAG_NAME"
CONTAINER_ID=$($PODMAN_EXEC create \
    --rm \
    --interactive --tty \
    "${ALSA_PERMISSIONS[@]}" \
    "${GDB_PERMISSIONS[@]}" \
    "${GIT_PERMISSIONS[@]}" \
    "${GROUP_PERMISSIONS[@]}" \
    "${KVM_PERMISSIONS[@]}" \
    "${PIPEWIRE_PERMISSIONS[@]}" \
    "${PULSEAUDIO_PERMISSIONS[@]}" \
    "${SELINUX_PERMISSIONS[@]}" \
    "${SSH_PERMISSIONS[@]}" \
    "${USB_PERMISSIONS[@]}" \
    "${USER_PERMISSIONS[@]}" \
    "${WAYLAND_PERMISSIONS[@]}" \
    "${XDG_PERMISSIONS[@]}" \
    "${X11_PERMISSIONS[@]}" \
    "${CONTAINER_NAME[@]}" \
    "${TARGET_FOLDER_MOUNT[@]}" \
    "${CUSTOM_RUN_ARGS[@]}" \
    "$TAG_NAME"
)
printf "\r\033[0K"

# Start the container
printf "(%s) Starting ... " "$TAG_NAME"
CONTAINER_ID=$($PODMAN_EXEC start "$CONTAINER_ID")
printf "\r\033[0K"

# Attach to the container
$PODMAN_EXEC attach "$CONTAINER_ID"
