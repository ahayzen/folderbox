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

      # If there is a ~/.nix-profile then mount it into the container
      if [ -d "$HOME/.nix-profile" ]; then
        CONTAINER_RUN_ARGS+=(--volume="$HOME/.nix-profile":"$HOME/.nix-profile":ro)
      fi

      # If there is a ~/.local/state/nix then mount it into the container
      if [ -d "$HOME/.local/state/nix" ]; then
        CONTAINER_RUN_ARGS+=(--volume="$HOME/.local/state/nix":"$HOME/.local/state/nix":ro)
      fi

      # If there is a /run/current-system then mount it into the container
      if [ -d "/run/current-system" ]; then
        CONTAINER_RUN_ARGS+=(--volume="/run/current-system":"/run/current-system":ro)
      fi

      # Inject script that allows for calling Nix
      mkdir -p "$PERSIST_FOLDER/home/.local/bin"
      echo "#!/usr/bin/env bash
export PATH=\"\$HOME/.nix-profile/bin:/nix/profile/bin:\$HOME/.local/state/nix/profile/bin:/run/current-system/etc/profiles/per-user/\$USER/bin:/nix/var/nix/profiles/default/bin:/run/current-system-sw/bin:\$PATH\"
exec \"\$@\"" > "$PERSIST_FOLDER/home/.local/bin/host-nix"
      chmod +x "$PERSIST_FOLDER/home/.local/bin/host-nix"
    fi
}
