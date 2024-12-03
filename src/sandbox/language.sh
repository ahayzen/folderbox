# SPDX-FileCopyrightText: Andrew Hayzen <ahayzen@gmail.com>
#
# SPDX-License-Identifier: MPL-2.0

function sandbox_setup_language() {  
    if [ -z "${LANG}" ]; then
        echo "No LANG set"
        return
    fi

    CONTAINERS_RUN_ARGS+=(--env=LANG)
}
