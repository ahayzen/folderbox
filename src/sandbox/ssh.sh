# SPDX-FileCopyrightText: Andrew Hayzen <ahayzen@gmail.com>
#
# SPDX-License-Identifier: MPL-2.0

function sandbox_setup_ssh() {
    if [ -z "${SSH_AUTH_SOCK}" ]; then
        echo "No SSH_AUTH_SOCK set"
        return
    else
        SSH_AUTH_SOCK_PATH=$(realpath "$SSH_AUTH_SOCK")
    fi

    if [ ! -S "${SSH_AUTH_SOCK_PATH}" ]; then
        echo "No ${SSH_AUTH_SOCK_PATH} socket"
        return
    fi

    # Ensure ssh folder exists on the host
    mkdir -p "$HOME/.ssh"

    CONTAINER_RUN_ARGS+=(--env=SSH_AUTH_SOCK="$SSH_AUTH_SOCK_PATH" --volume="$(dirname "$SSH_AUTH_SOCK_PATH")":"$(dirname "$SSH_AUTH_SOCK_PATH")":rw)
    CONTAINER_RUN_ARGS+=(--volume="$HOME/.ssh":"$HOME/.ssh":rw)
}
