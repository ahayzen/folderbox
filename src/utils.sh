# SPDX-FileCopyrightText: Andrew Hayzen <ahayzen@gmail.com>
#
# SPDX-License-Identifier: MPL-2.0

function utils_find_exec_on_host() {
    if [ -n "$container" ]; then
        if [ "$container" == "podman" ]; then
            if [ -x "$(command -v distrobox-host-exec)" ]; then
                # Ensure host-exec is installed
                distrobox-host-exec --yes whoami &>/dev/null

                # Check if command -v is able to find the exec on the host
                if [ -n "$(distrobox-host-exec --yes command -v "$1")" ]; then
                    RET="distrobox-host-exec --yes $1"
                else
                    echo "Could not find $1 on the host from inside container"
                    exit 1
                fi
            else
                echo "Could not find route to $1 on the host from inside container"
                exit 1
            fi
        else
            echo "Unknown container variable set"
            exit 1
        fi
    elif [ -x "$(command -v "$1")" ]; then
        RET="$1"
    else
        echo "Could not find $1 on the host"
        exit 1
    fi
}
