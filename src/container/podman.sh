# SPDX-FileCopyrightText: Andrew Hayzen <ahayzen@gmail.com>
#
# SPDX-License-Identifier: MPL-2.0

function container_find_podman() {
    utils_find_exec_on_host podman

    # No podman is fatal
    if [ -z "$RET" ]; then
        exit 1
    fi

    PODMAN_EXEC="$RET"
}
