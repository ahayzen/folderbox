# SPDX-FileCopyrightText: Andrew Hayzen <ahayzen@gmail.com>
#
# SPDX-License-Identifier: MPL-2.0

function sandbox_setup_wayland() {
    if [ -z "${WAYLAND_DISPLAY}" ]; then
        echo "No WAYLAND_DISPLAY set"
        exit 1
    fi

    if [ ! -S "${XDG_RUNTIME_DIR}/${WAYLAND_DISPLAY}" ]; then
        echo "No ${XDG_RUNTIME_DIR}/${WAYLAND_DISPLAY} socket"
        exit 1
    fi

    CONTAINER_RUN_ARGS+=(--env=WAYLAND_DISPLAY --volume="$XDG_RUNTIME_DIR/$WAYLAND_DISPLAY":"$XDG_RUNTIME_DIR/$WAYLAND_DISPLAY":rw)
}
