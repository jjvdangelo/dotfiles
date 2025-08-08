#!/bin/sh
# Link .zsh{rc,env,_history} files.
#
# This is temporary and just to get us moving forward.

# shellcheck source=../../lib/common.sh
. "${HOME}/.dotfiles/scripts/lib/common.sh"

if ! command -v zsh >/dev/null 2>&1; then
    prompt_and_validate install_zsh "zsh not found. Install it?" '[YyNn]' 'N'
    # shellcheck disable=SC2154 # set by prompt_and_validate
    case "${install_zsh}" in
        [Yy])
            install_packages zsh || err "zsh installation failed"
            ;;
        *)
            printf 'Skipping linking zsh dotfiles: zsh not installed.\n' >&2
            exit 0
            ;;
    esac
fi

printf 'Creating symlinks for all dotfiles directly under "~/.dotfiles" to "~/"'
find "${HOME}/.dotfiles" \( -type f -o -type l \) | while IFS= read -r file; do
    link_files "${file}"
done
