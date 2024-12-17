# SPDX-FileCopyrightText: Andrew Hayzen <ahayzen@gmail.com>
#
# SPDX-License-Identifier: MPL-2.0

function sandbox_setup_starship() {
    # If there is a starship config then mount it into the container
    if [ -f "$HOME/.config/starship.toml" ]; then
        # Ensure parent of mounted starship folder exists
        # otherwise .config is root in the container
        mkdir -p "$PERSIST_FOLDER/home/.config/"

        CONTAINER_RUN_ARGS+=(--volume="$HOME/.config/starship.toml":"$HOME/.config/starship.toml":ro)
    fi
}
