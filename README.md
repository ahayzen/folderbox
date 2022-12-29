<!--
SPDX-FileCopyrightText: Andrew Hayzen <ahayzen@gmail.com>

SPDX-License-Identifier: MPL-2.0
-->

Developer containers which can be executed against a project folder, allowing the development environment to be separate from the host,
while still allowing using GUIs, sound, SSH etc.

# Usage

```bash
# expects .devbox folder with box definition
devbox ~/path/to/project

# expects boxname in ~/.local/share/com.ahayzen.devbox/containers
devbox boxname ~/path/to/project
```

# Installation

Run the `install.sh` for an automated install, this creates the common and containers folders in `~/.local/share/com.ahayzen.devbox` and symlinks the `devbox` script into `~/.local/bin`.

# Format

A devbox is defined either in the `.devbox` folder of the project or in the shared `containers` folder.

Inside the folder a `Containerfile.in` or `Containerfile` is expected, this should setup the environment - if it's a `.in` file then note you can use `#include "path/to/common/snippet"`.

There also can be a `runargs` file, each line of this file are added as arguments to the `podman run` command.

# Other projects

  * [distrobox](https://github.com/89luca89/distrobox/)
    * "Use any linux distribution inside your terminal. Enable both backward and forward compatibility with software and freedom to use whatever distribution you’re more comfortable with."
    * Tries to create a terminal that has access to the whole of $HOME, whereas devbox is isolated to project folders
  * [x11docker](https://github.com/mviereck/x11docker/)
    * Run GUI applications and desktops in docker and podman containers. Focus on security.
    * Tries to isolate applications with opt-in confinement escapes, whereas devbox bridges all confinement escapes
