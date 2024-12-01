# SPDX-FileCopyrightText: Andrew Hayzen <ahayzen@gmail.com>
#
# SPDX-License-Identifier: MPL-2.0

function sandbox_setup() {
    printf "\r(%s) Finding ALSA ... " "$TAG_NAME"
    sandbox_setup_alsa
    printf "\r(%s) Finding gdb ... " "$TAG_NAME"
    sandbox_setup_gdb
    printf "\r(%s) Finding git ... " "$TAG_NAME"
    sandbox_setup_git
    printf "\r(%s) Finding GPU ... " "$TAG_NAME"
    sandbox_setup_gpu
    printf "\r(%s) Finding group ... " "$TAG_NAME"
    sandbox_setup_group
    printf "\r(%s) Finding input ..." "$TAG_NAME"
    sandbox_setup_input
    printf "\r(%s) Finding KVM ... " "$TAG_NAME"
    sandbox_setup_kvm
    printf "\r(%s) Finding Nix ..." "$TAG_NAME"
    sandbox_setup_nix
    printf "\r(%s) Finding pipewire ... " "$TAG_NAME"
    sandbox_setup_pipewire
    printf "\r(%s) Finding pulseaudio ... " "$TAG_NAME"
    sandbox_setup_pulseaudio
    printf "\r(%s) Finding selinux ... " "$TAG_NAME"
    sandbox_setup_selinux
    printf "\r(%s) Finding SSH ... " "$TAG_NAME"
    sandbox_setup_ssh
    printf "\r(%s) Finding term ..." "$TAG_NAME"
    sandbox_setup_term
    printf "\r(%s) Finding timezone ..." "$TAG_NAME"
    sandbox_setup_timezone
    printf "\r(%s) Finding USB ... " "$TAG_NAME"
    sandbox_setup_usb
    printf "\r(%s) Finding User ... " "$TAG_NAME"
    sandbox_setup_user
    printf "\r(%s) Finding Wayland ... " "$TAG_NAME"
    sandbox_setup_wayland
    printf "\r(%s) Finding XDG ... " "$TAG_NAME"
    sandbox_setup_xdg
    printf "\r(%s) Finding X11 ... " "$TAG_NAME"
    sandbox_setup_x11

    printf "\r(%s) Finding Container Name ... " "$TAG_NAME"
    sandbox_setup_name
    printf "\r(%s) Finding Work Directory ... " "$TAG_NAME"
    sandbox_setup_workdir

    printf "\r(%s) Finding Custom Args ... " "$TAG_NAME"
    sandbox_setup_custom

    printf "\r\033[0K"
}
