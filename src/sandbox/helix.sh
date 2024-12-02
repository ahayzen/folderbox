# SPDX-FileCopyrightText: Andrew Hayzen <ahayzen@gmail.com>
#
# SPDX-License-Identifier: MPL-2.0

function sandbox_setup_helix() {
    # If there is a helix config then mount it into the container
    if [ -d "$HOME/.config/helix" ]; then
        # Ensure parent of mounted helix folder exists
        # otherwise .config is root in the container
        mkdir -p "$PERSIST_FOLDER/home/.config/"

        CONTAINER_RUN_ARGS+=(--volume="$HOME/.config/helix":"$HOME/.config/helix":ro)
    fi
}

