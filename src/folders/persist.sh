# SPDX-FileCopyrightText: Andrew Hayzen <ahayzen@gmail.com>
#
# SPDX-License-Identifier: MPL-2.0

function folders_setup_persist() {
    # Build a serialised name for the persist folder
    # this is a combination of the box name and work folder name
    local base_name
    local serialised
    base_name=$(basename "$WORK_FOLDER")
    serialised=$(echo "$WORK_FOLDER" | cksum | cut -d' ' -f1)

    PERSIST_FOLDER="$DATA_FOLDER/persist/${BOX_NAME}-${serialised}-${base_name}"
}
