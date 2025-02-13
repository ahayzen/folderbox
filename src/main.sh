# SPDX-FileCopyrightText: Andrew Hayzen <ahayzen@gmail.com>
#
# SPDX-License-Identifier: MPL-2.0

function help_echo() {
    echo "Usage:"
    echo "# expects .$NAME folder with box definition"
    echo "$NAME ~/path/to/project"
    echo ""
    echo "# expects boxname in $DATA_FOLDER/containers"
    echo "$NAME boxname ~/path/to/project"
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

        # Copy any templates
        templates_setup

        # Build and launch the container
        container_setup
    fi
}
