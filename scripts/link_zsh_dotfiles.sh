#!/bin/sh
# Link .zsh{rc,env,_history} files.
#
# This is temporary and just to get us moving forward.

# shellcheck source=../../lib/common.sh
. "${HOME}/.dotfiles/scripts/lib/common.sh"

printf 'Creating symlinks for all dotfiles directly under "~/.dotfiles" to "~/"'
find "${HOME}/.dotfiles" \( -type f -o -type l \) | while IFS=read -r file; do
    link_files "${file}"
done
