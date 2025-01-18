# SPDX-FileCopyrightText: Andrew Hayzen <ahayzen@gmail.com>
#
# SPDX-License-Identifier: MPL-2.0

function sandbox_setup_timezone() {
    if [ -e /etc/localtime ]; then
        CONTAINER_RUN_ARGS+=(--volume=/etc/localtime:/etc/localtime:ro)
    fi
}
