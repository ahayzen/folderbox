# SPDX-FileCopyrightText: Andrew Hayzen <ahayzen@gmail.com>
#
# SPDX-License-Identifier: MPL-2.0

function sandbox_setup_network() {
    # Use host networking, this allows for opening ports and accessing other services
    CONTAINER_RUN_ARGS+=(--network=host)
}
