# SPDX-FileCopyrightText: Andrew Hayzen <ahayzen@gmail.com>
#
# SPDX-License-Identifier: MPL-2.0

function folders_setup_box() {
    if [ -d "$1/.$NAME" ]; then
        if [ -n "$2" ]; then
            echo "Unexpected argument after folder"
            exit 1
        fi

        BOX_NAME="$(basename "$(realpath "$1")")"
        CONTAINER_FOLDER="$(realpath "$1/.$NAME")"
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
        echo "Could not find $NAME for '$1'"
        exit 1
    fi

    # Don't allow HOME as the work folder as we use HOME for persistence with custom mounting
    if [ "$WORK_FOLDER" == "$(realpath "$HOME")" ]; then
        echo "Work folder cannot be \$HOME, consider using distrobox instead."
        exit 1
    fi

    TAG_NAME="$NAME-$BOX_NAME"
}
