# SPDX-FileCopyrightText: Andrew Hayzen <ahayzen@gmail.com>
#
# SPDX-License-Identifier: MPL-2.0

function help_echo() {
    echo "Usage:"
    echo "# expects .devbox folder with box definition"
    echo "devbox ~/path/to/project"
    echo ""
    echo "# expects boxname in $DATA_FOLDER/containers"
    echo "devbox boxname ~/path/to/project"
    exit 0
}

function main() {
    # No args so show help
    if [ -z "$1" ]; then
        help_echo
    else
        # Determine folders
        folders_setup "$@"

        # Find sandbox escapes and setup run args
        sandbox_setup

        # Build and launch the container
        container_setup
    fi
}
