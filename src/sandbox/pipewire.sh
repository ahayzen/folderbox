# SPDX-FileCopyrightText: Andrew Hayzen <ahayzen@gmail.com>
#
# SPDX-License-Identifier: MPL-2.0

function sandbox_setup_pipewire() {
    if [ -z "${PIPEWIRE_REMOTE}" ]; then
        PIPEWIRE_REMOTE="pipewire-0"
    fi

    if [ ! -S "${XDG_RUNTIME_DIR}/${PIPEWIRE_REMOTE}" ]; then
        echo "No ${XDG_RUNTIME_DIR}/${PIPEWIRE_REMOTE} socket"
        return
    fi

    CONTAINER_RUN_ARGS+=(--env=PIPEWIRE_REMOTE="${PIPEWIRE_REMOTE}" --volume="${XDG_RUNTIME_DIR}/${PIPEWIRE_REMOTE}":"${XDG_RUNTIME_DIR}/${PIPEWIRE_REMOTE}":rw)
}
