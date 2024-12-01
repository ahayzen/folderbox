# SPDX-FileCopyrightText: Andrew Hayzen <ahayzen@gmail.com>
#
# SPDX-License-Identifier: MPL-2.0

function sandbox_setup_input() {
    # Allow for access of input devices (eg gamepads, joysticks, keyboards, mice)
    #
    # Use volume mount for /dev/input as new devices might appear
    CONTAINER_RUN_ARGS+=(--volume=/dev/input:/dev/input --device=/dev/uinput:/dev/uinput)
}
