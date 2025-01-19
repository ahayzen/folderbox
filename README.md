<!--
SPDX-FileCopyrightText: Andrew Hayzen <ahayzen@gmail.com>

SPDX-License-Identifier: MPL-2.0
-->

Workspaces using containers which can be executed against a project folder.
Allowing the development environment to be separate from the host, while still providing sandbox escapes.

# Aims

  * Provide an isolated per project or topic developer environment from the host
  * Automatic integration with audio, permissions, sound, SSH, windowing etc
  * Works on any system with `pipewire`, `podman`, `ssh`, `wayland`, `x11` installed
  * Allow for development on immutable systems, such as Fedora Silverblue, and executing from inside [`distrobox`](https://github.com/89luca89/distrobox/)
  * Provide a container environment for IDEs (such as VSCode) to attach to

# Usage

Run the `install.sh` for an automated install, this creates the common and containers folders in `~/.local/share/com.ahayzen.folderbox` and symlinks the `folderbox` script into `~/.local/bin`.


```bash
# expects .folderbox folder with box definition
folderbox ~/path/to/project

# expects boxname in ~/.local/share/com.ahayzen.folderbox/containers
folderbox boxname ~/path/to/project
```

To rebuild or pull a container simply remove the container and run `folderbox` again, `podman rmi folderbox-boxname`.

See the [sandbox folder](./src/sandbox/) for supported sandbox escapes.

# Project Format

A folderbox is defined either in the `.folderbox` folder of the project or in the shared `~/.local/share/com.ahayzen.folderbox/containers` folder.

Inside the folder a `Containerfile.in` or `Containerfile` is expected, this should setup the environment - if it's a `.in` file then note you can use `#include "path/to/common/snippet"`.
Note that common snippets are installed into `~/.local/share/com.ahayzen.folderbox/common`.

See [data/containers/example-cpp](./data/containers/example-cpp) as an example of a container and [data/common](./data/containers) for snippets.

There also can be a `runargs` file, each line of this file are added as arguments to the `podman run` command. (eg `runargs` could container `--volume=/custom/path:/custom/path` which would then volume mount `/custom/path`).

```
my-project/
  .folderbox/
    Containerfile.in
    runargs
    ...other_context_items...
  src/

~/.local/share/com.ahayzen.folderbox/containers/my-env/
  Containerfile.in
  runargs
  ...other_context_items...
```

These would then be used with either `folderbox /path/to/my-project` or `folderbox my-env /path/to/project`, note that the `my-env` can be used with multiple projects.

# Persistence

The `$HOME` folder in the container is stored for each folderbox in `~/.local/share/com.ahayzen.folderbox/persist/<boxname>-<cksum of project>-<basename of project>`,
this allows for user installs, repositories, configuration, and bash history to be preserved between sessions.

Note that the container itself is removed once it is stopped, so if packages or changes to the root
of the container were made, these should be written into the `Containerfile` and the folderbox rebuilt.

If root folders do need to be persistent then mount them as volumes using the `runargs` file.

# VSCode

Visual Studio Code can attach to the folderbox container by using the [Remote Containers](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers) extension.

  * Install the extension `ms-vscode-remote.remote-containers`
  * Start the `folderbox` container
  * `View` -> `Command Palette...`
  * `> Dev Containers: Attach to Running Container...`
  * Pick your folderbox container

## Flatpak

With the flatpak of Visual Studio Code this works in a similar way, just the path to `podman` needs to be set so that it can reach the host.

Run the following commands to create a `podman-host` command in your `~/.local/bin`, this is the same as the [distrobox setup](https://github.com/89luca89/distrobox/blob/0e24aae53ae6e2fd6901db3556de9e6b261e7a6f/docs/posts/integrate_vscode_distrobox.md#third-step-podman-wrapper) for Visual Studio Code.

```bash
mkdir -p ~/.local/bin
sudo tee ~/.local/bin/podman-host <<EOF
#!/bin/bash
set -x
if [ "\$1" == "exec" ]; then
 # Remove 'exec' from \$@
 shift
 script='
     result_command="podman exec"
        for i in \$(printenv | grep "=" | grep -Ev " |\"" |
            grep -Ev "^(HOST|HOSTNAME|HOME|PATH|SHELL|USER|_)"); do

            result_command=\$result_command --env="\$i"
     done

        exec \${result_command} "\$@"
    '
 exec flatpak-spawn --host sh -c "\$script" - "\$@"
else
 exec flatpak-spawn --host podman "\$@"
fi
EOF

# ensure this file isn't writable, vscode has corrupted it before
sudo chmod 0500 ~/.local/bin/podman-host
sudo chown "$USER:$USER" ~/.local/bin/podman-host
```

Then in your Visual Studio Code settings set `podman-host` to the path.

`"dev.containers.dockerPath": "${HOME}/.local/bin/podman-host",`

# Other projects

There are other projects that are similar to folderbox but with different goals,
folderbox tries to keep your projects isolated while integrating with the host.

| Project | Sandbox | Custom Sandbox Control | Packaging System | Default Mapped Folders |
|---------|---------|------------------------|------------------|---|
| devbox |  None | - | Nix | All |
| distrobox | <details><summary>Weak</summary>Home is mutated and root can be reached</details> | Minimal | OCI | <details><summary>Home</summary>Root is mounted in `/run/host`</details> |
| folderbox | Partial | Raw | OCI | Directory |
| x11docker | Strong | Yes | OCI | None |

  * [devbox](https://github.com/jetpack-io/devbox) - "Instant, easy, and predictable development environments"
    * Uses Nix packaging to provide packages but doesn't isolate file access from the host, whereas folderbox is isolated to project folders
  * [distrobox](https://github.com/89luca89/distrobox/) - "Use any linux distribution inside your terminal. Enable both backward and forward compatibility with software and freedom to use whatever distribution you're more comfortable with."
    * Tries to create a terminal that has access to the whole of $HOME and feels like it is running as the host, whereas folderbox is isolated to project folders
  * [x11docker](https://github.com/mviereck/x11docker/) - "Run GUI applications and desktops in docker and podman containers. Focus on security."
    * Tries to isolate applications with opt-in confinement escapes, whereas folderbox enables all confinement escapes by default
