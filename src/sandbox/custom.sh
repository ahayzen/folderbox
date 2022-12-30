# SPDX-FileCopyrightText: Andrew Hayzen <ahayzen@gmail.com>
#
# SPDX-License-Identifier: MPL-2.0

function sandbox_setup_custom() {
    if [ -f "$CONTAINER_FOLDER/runargs" ]; then
        mapfile -t CUSTOM_RUN_ARGS < "$CONTAINER_FOLDER/runargs"
        CONTAINER_RUN_ARGS+=("${CUSTOM_RUN_ARGS[@]}")
    fi
}
