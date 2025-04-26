#!/bin/sh
# install_and_configure_zsh.sh
# Installs and configures ZSH for meh.
if [ -z "${SCRIPT_DIR+x}" ]; then
    SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "${0}")" && pwd)
fi
. "${SCRIPT_DIR}/lib/common.sh"

if [ ! command -v zsh >/dev/null 2>&1 ]; then
    printf 'Attempting to install zsh.\n'
    install_packages zsh
else
    printf 'zsh is already installed.\n'
fi
