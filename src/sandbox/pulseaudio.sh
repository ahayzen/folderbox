# SPDX-FileCopyrightText: Andrew Hayzen <ahayzen@gmail.com>
#
# SPDX-License-Identifier: MPL-2.0

function sandbox_setup_pulseaudio() {
    # Find the socket
    PULSEAUDIO_HOST_SOCKET="${XDG_RUNTIME_DIR}/pulse/native"
    PULSEAUDIO_CLIENT_SOCKET="${XDG_RUNTIME_DIR}/pulse/native"
    if [ ! -S "${PULSEAUDIO_HOST_SOCKET}" ]; then
        echo "No ${PULSEAUDIO_HOST_SOCKET} socket"
        exit 1
    fi

    # Setup config for the guest
    PULSEAUDIO_HOST_CONFIG="$PERSIST_FOLDER/pulseaudio.client.config"
    PULSEAUDIO_CLIENT_CONFIG="${XDG_RUNTIME_DIR}/pulse/client.config"
    echo "enable-shm = false" > "$PULSEAUDIO_HOST_CONFIG"

    CONTAINER_RUN_ARGS+=(--env=PULSE_SERVER="unix:${PULSEAUDIO_CLIENT_SOCKET}" --volume="${PULSEAUDIO_HOST_SOCKET}":"${PULSEAUDIO_CLIENT_SOCKET}":rw)
    CONTAINER_RUN_ARGS+=(--env=PULSE_CLIENTCONFIG="${PULSEAUDIO_CLIENT_CONFIG}" --volume="${PULSEAUDIO_HOST_CONFIG}":"${PULSEAUDIO_CLIENT_CONFIG}":ro)
}
