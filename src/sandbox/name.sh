# SPDX-FileCopyrightText: Andrew Hayzen <ahayzen@gmail.com>
#
# SPDX-License-Identifier: MPL-2.0

function sandbox_setup_name() {
    CONTAINER_RUN_ARGS+=(--hostname="$BOX_NAME" --name="$TAG_NAME")
}
