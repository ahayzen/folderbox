# SPDX-FileCopyrightText: Andrew Hayzen <ahayzen@gmail.com>
#
# SPDX-License-Identifier: MPL-2.0

function sandbox_setup_xdg() {
    # Setup HOME

    if [ -z "${HOME}" ]; then
        echo "No HOME set"
        return
    fi

    # Ensure home exists in persistent folder
    mkdir -p "$PERSIST_FOLDER/home/"

    # Ensure a .bashrc exists in the persistent home
    touch "$PERSIST_FOLDER/home/.bashrc"

    CONTAINER_RUN_ARGS+=(--env=HOME --volume="$PERSIST_FOLDER/home":"$HOME":rw)

    # Setup XDG_RUNTIME_DIR

    if [ -z "${XDG_RUNTIME_DIR}" ]; then
        echo "No XDG_RUNTIME_DIR set"
        return
    fi

    # Ensure run exists in persistent folder
    mkdir -p "$PERSIST_FOLDER/run/"

    # Ensure permissions are correct for XDG_RUNTIME_DIR
    chmod 0700 "$PERSIST_FOLDER/run/"

    CONTAINER_RUN_ARGS+=(--env=XDG_RUNTIME_DIR --volume="$PERSIST_FOLDER/run":"$XDG_RUNTIME_DIR":rw)
}
