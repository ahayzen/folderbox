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

function container_setup_exec() {
    $PODMAN_EXEC exec \
        --interactive --tty \
        "$CONTAINER_ID" \
        /bin/bash --login
}

function container_setup_is_running() {
    $PODMAN_EXEC container inspect \
        --format '{{.State.Status}}' \
        "$TAG_NAME" \
        2>&1 || true
}

function container_setup_running_load_id() {
    CONTAINER_ID=$($PODMAN_EXEC container inspect --format '{{.Id}}' "$TAG_NAME")
}

function container_setup_start() {
    CONTAINER_ID=$($PODMAN_EXEC start "$CONTAINER_ID")
}
