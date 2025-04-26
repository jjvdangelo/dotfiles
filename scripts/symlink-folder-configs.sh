#!/bin/sh
# symlink-nvim.sh - create a symlink from ~/.dotfiles/nvim to ~/.config/nvim
: "${SCRIPT_DIR:=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)}"

# shellcheck disable=SC1091 # SCRIPT_DIR is resolved at runtime.
. "${SCRIPT_DIR}/lib/common.sh"

# Required from `common.sh`:
#  - DF_BASE
#  - SCRIPT_DIR

link_configs nvim
