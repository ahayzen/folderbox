<!--
SPDX-FileCopyrightText: Andrew Hayzen <ahayzen@gmail.com>

SPDX-License-Identifier: MPL-2.0
-->

Developer containers which can be executed against a project folder, allowing the development environment to be separate from the host, while still allowing integratation with the host.

# Aims

  * Provide an isolated per project or topic developer environment from the host
  * Automatic integration with audio, permissions, sound, SSH, windowing etc
  * Works on any system with `pipewire`, `podman`, `ssh`, `wayland`, `x11` installed
  * Allow for development on immutable systems, such as Fedora Silverblue, and executing from inside [`distrobox`](https://github.com/89luca89/distrobox/)
  * Provide a container environment for IDEs (such as VSCode) to attach to

# Usage

Run the `install.sh` for an automated install, this creates the common and containers folders in `~/.local/share/com.ahayzen.devbox` and symlinks the `devbox` script into `~/.local/bin`.


```bash
# expects .devbox folder with box definition
devbox ~/path/to/project

# expects boxname in ~/.local/share/com.ahayzen.devbox/containers
devbox boxname ~/path/to/project
```

To rebuild or pull a container simply remove the container and run `devbox` again, `podman rmi devbox-boxname`.

See the [sandbox folder](./src/sandbox/) for supported sandbox escapes.

# Project Format

A devbox is defined either in the `.devbox` folder of the project or in the shared `~/.local/share/com.ahayzen.devbox/containers` folder.

Inside the folder a `Containerfile.in` or `Containerfile` is expected, this should setup the environment - if it's a `.in` file then note you can use `#include "path/to/common/snippet"`.
Note that common snippets are installed into `~/.local/share/com.ahayzen.devbox/common`.

There also can be a `runargs` file, each line of this file are added as arguments to the `podman run` command.

```
my-project/
  .devbox/
    Containerfile.in
    runargs
    ...other_context_items...
  src/

~/.local/share/com.ahayzen.devbox/containers/dev-env/
  Containerfile.in
  runargs
  ...other_context_items...
```

These would then be used with either `devbox /path/to/my-project` or `devbox dev-env /path/to/project`, note that the `dev-env` can be used with multiple projects.

# Persistence

The `$HOME` folder in the container is stored for each devbox in `~/.local/share/com.ahayzen.dev/persist/<boxname>`,
this allows for user installs, repositories, configuration, and bash history to be preserved between sessions.

Note that the container itself is removed once it is stopped, so if packages or changes to the root
of the container were made, these should be written into the `Containerfile` and the devbox rebuilt.

If root folders do need to be persistent then mount them as volumes using the `runargs` file.

# Other projects

There are other projects that are similar to devbox but with different goals,
devbox tries to keeps your projects isolated while integrating with the host.
Whereas others either try to integrate all of a users HOME or totally isolate
an application from the host with opt-in escapes.

| Project | Declarative | Isolation | Sandbox Control |
|---------|-------------|-----------|---------|
| devbox | Yes | Partial | No |
| distrobox | No | Weak | Minimal |
| x11docker | Yes | Strong | Yes |

  * [distrobox](https://github.com/89luca89/distrobox/) -  "Use any linux distribution inside your terminal. Enable both backward and forward compatibility with software and freedom to use whatever distribution you’re more comfortable with."
    * Tries to create a terminal that has access to the whole of $HOME and feels like it is running as the host, whereas devbox is isolated to project folders
  * [x11docker](https://github.com/mviereck/x11docker/) - "Run GUI applications and desktops in docker and podman containers. Focus on security."
    * Tries to isolate applications with opt-in confinement escapes, whereas devbox enables all confinement escapes by default
