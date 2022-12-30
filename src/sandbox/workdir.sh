# SPDX-FileCopyrightText: Andrew Hayzen <ahayzen@gmail.com>
#
# SPDX-License-Identifier: MPL-2.0

function sandbox_setup_workdir() {
    if [ ! -d "$WORK_FOLDER" ]; then
        echo "Work folder does not exist"
        exit 1
    fi

    CONTAINER_RUN_ARGS+=(--volume="$WORK_FOLDER":"$WORK_FOLDER":rw --workdir="$WORK_FOLDER")
}
