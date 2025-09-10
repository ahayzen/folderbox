# SPDX-FileCopyrightText: Andrew Hayzen <ahayzen@gmail.com>
#
# SPDX-License-Identifier: MPL-2.0

function sandbox_setup_jujutsu() {
    # If there is a jujutsu config then mount it into the container
    if [ -d "$HOME/.config/jj" ]; then
        # Ensure parent of mounted jujutsu folder exists
        # otherwise .config is root in the container
        mkdir -p "$PERSIST_FOLDER/home/.config/"

        CONTAINER_RUN_ARGS+=(--volume="$HOME/.config/jj":"$HOME/.config/jj":ro)
    fi
}

