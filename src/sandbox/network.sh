# SPDX-FileCopyrightText: Andrew Hayzen <ahayzen@gmail.com>
#
# SPDX-License-Identifier: MPL-2.0

function sandbox_setup_network() {
    # Use host networking, this allows for opening ports and accessing other services
    CONTAINER_RUN_ARGS+=(--network=host)

    # If the hostname is set passs this through
    # otherwise sudo can complain about unresolved host
    if [ -z "$HOSTNAME" ]; then
        CONTAINER_RUN_ARGS+=(--add-host="$HOSTNAME":127.0.0.1)
    fi
}
