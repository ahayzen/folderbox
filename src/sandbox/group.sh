# SPDX-FileCopyrightText: Andrew Hayzen <ahayzen@gmail.com>
#
# SPDX-License-Identifier: MPL-2.0

function sandbox_setup_group() {
    utils_find_exec_on_host groups
    GROUP_ITEMS="$($RET)"

    # Passthrough certain groups from the host into the container that might be useful
    for item in $GROUP_ITEMS
    do
        if [ "$item" == "dialout" ] || [ "$item" == "kvm" ] || [ "$item" == "video" ]; then
            CONTAINER_RUN_ARGS+=("--group-add=$item")
        fi
    done
}
