# SPDX-FileCopyrightText: Andrew Hayzen <ahayzen@gmail.com>
#
# SPDX-License-Identifier: MPL-2.0

function sandbox_setup_selinux() {
    CONTAINER_RUN_ARGS+=(--security-opt=label=type:container_runtime_t)
}
