# SPDX-FileCopyrightText: Andrew Hayzen <ahayzen@gmail.com>
#
# SPDX-License-Identifier: MPL-2.0

function sandbox_setup_opencode() {
    # If there is an opencode config then mount it into the container
    #
    # NOTE: older versions of opencode use config.json
    if [ -f "$HOME/.config/opencode/config.json" ]; then
        # Ensure parent of mounted opencode folder exists
        # otherwise .config is root in the container
        mkdir -p "$PERSIST_FOLDER/home/.config/opencode"

        CONTAINER_RUN_ARGS+=(--volume="$HOME/.config/opencode/config.json":"$HOME/.config/opencode/config.json":ro)
    fi

    # If there is an opencode config then mount it into the container
    if [ -f "$HOME/.config/opencode/opencode.json" ]; then
        # Ensure parent of mounted opencode folder exists
        # otherwise .config is root in the container
        mkdir -p "$PERSIST_FOLDER/home/.config/opencode"

        CONTAINER_RUN_ARGS+=(--volume="$HOME/.config/opencode/opencode.json":"$HOME/.config/opencode/opencode.json":ro)
    fi

    # If there is an opencode tui config then mount it into the container
    if [ -f "$HOME/.config/opencode/tui.json" ]; then
        # Ensure parent of mounted opencode folder exists
        # otherwise .config is root in the container
        mkdir -p "$PERSIST_FOLDER/home/.config/opencode"

        CONTAINER_RUN_ARGS+=(--volume="$HOME/.config/opencode/tui.json":"$HOME/.config/opencode/tui.json":ro)
    fi
}

