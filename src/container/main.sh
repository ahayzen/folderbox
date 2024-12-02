# SPDX-FileCopyrightText: Andrew Hayzen <ahayzen@gmail.com>
#
# SPDX-License-Identifier: MPL-2.0

function container_setup() {
    printf "\r(%s) Finding Podman ... " "$TAG_NAME"
    container_find_podman

    # Build the container image
    printf "\r(%s) Building image ... " "$TAG_NAME"
    container_setup_build

    # Determine if the container is already running or not
    if [ "$(container_setup_is_running)" == "running" ]; then
        # Load container id
        container_setup_running_load_id

        # Clear console
        printf "\r\033[0K"

        # Attach to existing container
        printf "\r(%s) Attaching to existing with: /bin/bash --login\n" "$TAG_NAME"
        container_setup_exec
    else
        # Create the container with the args, this could take a while the first time with userns=keep-id
        printf "\r(%s) Creating container (first time may take a while) ... " "$TAG_NAME"
        container_setup_create

        # Clear console
        printf "\r\033[0K"

        # Start the container
        printf "\r(%s) Starting container ... " "$TAG_NAME"
        container_setup_start

        # Clear console
        printf "\r\033[0K"

        # Attach to the container
        container_setup_attach
    fi
}
