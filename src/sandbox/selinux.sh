# SPDX-FileCopyrightText: Andrew Hayzen <ahayzen@gmail.com>
#
# SPDX-License-Identifier: MPL-2.0

function sandbox_setup_selinux() {
    # For now we disable SELinux within the container
    #
    # This could be label=type:container_runtime_t but then vscode code-server
    # fails to start via podman exec CONTAINER ~/.vscode-server/...
    #
    # It does however work inside bash with bash -c ~/.vscode-server/...
    # https://github.com/ahayzen/folderbox/issues/6
    #
    # As there are likely other cases which may cause issues lets disable for now.
    CONTAINER_RUN_ARGS+=(--security-opt=label=disable)
}
