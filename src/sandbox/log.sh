# SPDX-FileCopyrightText: Andrew Hayzen <ahayzen@gmail.com>
#
# SPDX-License-Identifier: MPL-2.0

function sandbox_setup_log() {
    # Disable logging otherwise all terminal output appears in journald
    CONTAINER_RUN_ARGS+=(--log-driver=none)
}
