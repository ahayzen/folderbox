# SPDX-FileCopyrightText: Andrew Hayzen <ahayzen@gmail.com>
#
# SPDX-License-Identifier: MPL-2.0

function container_setup() {
    printf "(%s) Finding Podman ... " "$TAG_NAME"
    container_find_podman

    # Build the container image
    printf "(%s) Building ... " "$TAG_NAME"
    container_setup_build
    printf "\r\033[0K"

    # Create the container with the args, this could take a while the first time with userns=keep-id
    printf "(%s) Creating (first time may take a while) ... " "$TAG_NAME"
    container_setup_create
    printf "\r\033[0K"

    # Start the container
    printf "(%s) Starting ... " "$TAG_NAME"
    container_setup_start
    printf "\r\033[0K"

    # Attach to the container
    container_setup_attach
}
