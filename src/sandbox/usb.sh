# SPDX-FileCopyrightText: Andrew Hayzen <ahayzen@gmail.com>
#
# SPDX-License-Identifier: MPL-2.0

function sandbox_setup_usb() {
    # Need to use volume mount otherwise devices don't work with adb
    CONTAINER_RUN_ARGS+=(--volume=/dev/bus/usb:/dev/bus/usb)
}
