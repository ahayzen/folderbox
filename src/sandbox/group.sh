# SPDX-FileCopyrightText: Andrew Hayzen <ahayzen@gmail.com>
#
# SPDX-License-Identifier: MPL-2.0

function sandbox_setup_group() {
    # Passthrough all groups from the host to container
    CONTAINER_RUN_ARGS+=("--group-add=keep-groups")
}
