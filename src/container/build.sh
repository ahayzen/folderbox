# SPDX-FileCopyrightText: Andrew Hayzen <ahayzen@gmail.com>
#
# SPDX-License-Identifier: MPL-2.0

function container_setup_build() {
    if [ -z "$( $PODMAN_EXEC images -q "$TAG_NAME" )" ]; then
        # Find the container definition
        if [ -f "$CONTAINER_FOLDER/Containerfile.in.in" ]; then
            # Allow for custom FOLDERBOX_SNIPPETS_DIR argument to be resolved
            FOLDERBOX_SNIPPETS_DIR="$DATA_FOLDER/common/" envsubst "\$FOLDERBOX_SNIPPETS_DIR" < "$CONTAINER_FOLDER/Containerfile.in.in" > "$CONTAINER_FOLDER/Containerfile.in"
            
            CONTAINER_FILE="Containerfile.in"
        elif [ -f "$CONTAINER_FOLDER/Containerfile.in" ]; then
            CONTAINER_FILE="Containerfile.in"
        elif [ -f "$CONTAINER_FOLDER/Containerfile" ]; then
            CONTAINER_FILE="Containerfile"
        else
            CONTAINER_FILE=""
        fi

        # Build the resultant Container file
        if [ "$CONTAINER_FILE" != "" ]; then
            # cpp will exit non zero due to non C++ style comments etc
            cpp -fdirectives-only -E "$CONTAINER_FOLDER/$CONTAINER_FILE" 2> /dev/null 1> "$CONTAINER_FOLDER/Containerfile.result" || true
        fi

        # Build the image
        BUILD_OUTPUT=$($PODMAN_EXEC build \
            --file="$CONTAINER_FILE" \
            --tag="$TAG_NAME" \
            "$CONTAINER_FOLDER" 2>&1 || true)

        # Check if the image exists
        if [ -z "$( $PODMAN_EXEC images -q "$TAG_NAME" )" ]; then
            echo "$BUILD_OUTPUT"
            echo ""
            echo "Failed to build container"
            exit 1
        fi
    fi
}
