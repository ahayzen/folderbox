# SPDX-FileCopyrightText: Andrew Hayzen <ahayzen@gmail.com>
#
# SPDX-License-Identifier: MPL-2.0

function sandbox_setup_git() {
    # Ensure git config folder exists on the host
    mkdir -p "$HOME/.config/git"

    # Ensure parent of mounted git folder exists
    # otherwise .config is root in the container
    mkdir -p "$PERSIST_FOLDER/home/.config/"

    CONTAINER_RUN_ARGS+=(--volume="$HOME/.config/git":"$HOME/.config/git":rw)
}
