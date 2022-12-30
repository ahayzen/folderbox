# SPDX-FileCopyrightText: Andrew Hayzen <ahayzen@gmail.com>
#
# SPDX-License-Identifier: MPL-2.0

function container_setup_attach() {
    $PODMAN_EXEC attach "$CONTAINER_ID"
}

function container_setup_create() {
    CONTAINER_ID=$($PODMAN_EXEC create \
        --rm \
        --interactive --tty \
        "${CONTAINER_RUN_ARGS[@]}" \
        "$TAG_NAME"
    )
}

function container_setup_start() {
    CONTAINER_ID=$($PODMAN_EXEC start "$CONTAINER_ID")
}
