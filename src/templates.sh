# SPDX-FileCopyrightText: Andrew Hayzen <ahayzen@gmail.com>
#
# SPDX-License-Identifier: MPL-2.0

function templates_setup() {
    # Under a Nix flake install we will have templates to copy from a sibling
    SCRIPT=$(realpath "$0")
    SCRIPTPATH=$(dirname "$SCRIPT")
    TEMPLATES_FOLDER="$SCRIPTPATH/../share/templates"
    if [ -d "$TEMPLATES_FOLDER" ]; then
        # Copy into the expected data folder
        mkdir -p "$DATA_FOLDER/common/"
        cp -f -R "$TEMPLATES_FOLDER/." "$DATA_FOLDER/common/"
    fi
}
