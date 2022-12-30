# SPDX-FileCopyrightText: Andrew Hayzen <ahayzen@gmail.com>
#
# SPDX-License-Identifier: MPL-2.0

function sandbox_setup_user() {
    USER="$(whoami)"

    # Use same ids inside the container as outside
    # Ensure that the passwd entry has the correct HOME ( https://github.com/containers/podman/issues/13185 )
    CONTAINER_RUN_ARGS+=(--passwd-entry="$USER:*:$UID:$UID:$USER:$HOME:/bin/bash" --env=USER --userns=keep-id)
}