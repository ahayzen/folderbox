# SPDX-FileCopyrightText: Andrew Hayzen <ahayzen@gmail.com>
#
# SPDX-License-Identifier: MPL-2.0

function sandbox_setup_x11() {
    if [ -z "${XAUTHORITY}" ]; then
        echo "No XAUTHORITY set"
        return
    else
        XAUTHORITY_PATH=$(realpath "$XAUTHORITY")
    fi

    CONTAINER_RUN_ARGS+=(--env=DISPLAY --volume=/tmp/.X11-unix:/tmp/.X11-unix:rw)
    CONTAINER_RUN_ARGS+=(--env=XAUTHORITY="$XAUTHORITY_PATH" --volume="$XAUTHORITY_PATH":"$XAUTHORITY_PATH":rw)
}
