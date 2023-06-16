# SPDX-FileCopyrightText: Andrew Hayzen <ahayzen@gmail.com>
#
# SPDX-License-Identifier: MPL-2.0

function sandbox_setup_term() {
    CONTAINER_RUN_ARGS+=(--env=COLORTERM --env=TERM)
}
