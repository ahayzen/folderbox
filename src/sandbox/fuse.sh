# SPDX-FileCopyrightText: Andrew Hayzen <ahayzen@gmail.com>
#
# SPDX-License-Identifier: MPL-2.0

function sandbox_setup_fuse() {
    # Fuse needs SYS_ADMIN capability to mount
    CONTAINER_RUN_ARGS+=(--device=/dev/fuse:/dev/fuse --cap-add=SYS_ADMIN)
}
