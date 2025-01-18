# SPDX-FileCopyrightText: Andrew Hayzen <ahayzen@gmail.com>
#
# SPDX-License-Identifier: MPL-2.0

function sandbox_setup_ping() {
    # Ping needs NET_RAW to send ICMP requests
    CONTAINER_RUN_ARGS+=(--cap-add=NET_RAW)
}
