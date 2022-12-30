# SPDX-FileCopyrightText: Andrew Hayzen <ahayzen@gmail.com>
#
# SPDX-License-Identifier: MPL-2.0

function sandbox_setup_kvm() {
    CONTAINER_RUN_ARGS+=(--device=/dev/kvm:/dev/kvm)
}
