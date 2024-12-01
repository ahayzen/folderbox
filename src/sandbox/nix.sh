# SPDX-FileCopyrightText: Andrew Hayzen <ahayzen@gmail.com>
#
# SPDX-License-Identifier: MPL-2.0

function sandbox_setup_nix() {
    # If /nix exists then mount it in as our /home config could have symlinks
    # into /nix folders and would fail otherwise
    #
    # We do not source any folders so the container environment is isolated
    if [ -d /nix ]; then
      CONTAINER_RUN_ARGS+=(--volume=/nix:/nix:ro)
    fi
}
