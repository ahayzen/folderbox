# SPDX-FileCopyrightText: Andrew Hayzen <ahayzen@gmail.com>
#
# SPDX-License-Identifier: MPL-2.0

function sandbox_setup_gdb() {
    CONTAINER_RUN_ARGS+=(--cap-add=SYS_PTRACE --security-opt=seccomp=unconfined)
}
