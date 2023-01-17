# SPDX-FileCopyrightText: Andrew Hayzen <ahayzen@gmail.com>
#
# SPDX-License-Identifier: MPL-2.0

function sandbox_setup_xdg() {
    if [ -z "${XDG_RUNTIME_DIR}" ]; then
        echo "No XDG_RUNTIME_DIR set"
        exit 1
    fi

    # Ensure home and run folders exist in persistent folder
    mkdir -p "$PERSIST_FOLDER/home/"
    mkdir -p "$PERSIST_FOLDER/run/"

    # Ensure permissions are correct for XDG_RUNTIME_DIR
    chmod 0700 "$PERSIST_FOLDER/run/"

    # Ensure a .bashrc exists in the persistent home
    touch "$PERSIST_FOLDER/home/.bashrc"

    CONTAINER_RUN_ARGS+=(--env=HOME --volume="$PERSIST_FOLDER/home":"$HOME":rw)
    CONTAINER_RUN_ARGS+=(--env=XDG_RUNTIME_DIR --volume="$PERSIST_FOLDER/run":"$XDG_RUNTIME_DIR":rw)
}
