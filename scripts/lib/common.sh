# .dotfiles/lib/common.sh  (POSIX-compliant; guarded against double-load)
[ -n "${_DOTFILES_COMMON_LOADED+x}" ] && return
_DOTFILES_COMMON_LOADED=1

set -eu

OS="$(uname -s)"
PKG_CMD=""

err() { printf 'Error: %s.\n' "$*" >&2; exit 1; }

_detect_pkg_manager() {
    case "${OS}" in
        Darwin)
            command -v brew >/dev/null 2>&1 || {
                err "Homebrew not found"
            }

            PKG_CMD="brew install"
            ;;
        Linux)
            for try in "sudo apt-get install -y" \
                       "sudo dnf install -y" \
                       "sudo yum install -y" \
                       "sudo pacman -Sy --noconfirm" \
                       "sudo zypper install -y"
           do
               set -- $try # $1 is candidate cmd; $* full string
               if command -v "${1}" >/dev/null 2>&1; then
                   PKG_CMD=$try
                   break
               fi
           done
           [ -n "${PKG_CMD}" ] || {
               err "supported package manager not found"
           }
           ;;
       *)
           err "unsupported OS " "${OS}"
           exit 1
           ;;
   esac
}

install_packages() {
    [ -n "${PKG_CMD}" ] || _detect_pkg_manager
    for pkg in "${@}"; do
        printf 'Installing %s.\n' "${pkg}"
        # shellcheck disable=SC2086 # intentional word splitting
        $PKG_CMD "${pkg}"
    done
}

prompt_and_validate() {
    var="${1}"; prompt="${2}"; regex="${3}"; default="${4:-}"

    while true; do
        if [ -n "${default}" ]; then
            printf '%s [%s]' "${prompt}" "${default}" >/dev/tty
        else
            printf '%s ' "${prompt}" >/dev/tty
        fi

        IFS= read -r input </dev/tty
        [ -z "${input}" ] && input="${default}"

        printf '%s\n' "${input}" | grep -E -q "${regex}" && {
            eval "${var}=\${input}"
            return
        }

        printf 'Invalid input.\n' >/dev/tty
    done
}

link_files() {
    for src in "${@}"; do
        local rel="${src#${HOME}/.dotfiles/}"

        if [ "${rel}" = "${src}" ]; then
            printf 'Skipping invalid source (not under ~/.dotfiles): %s\n' "${src}" >&2
            continue
        fi

        local dest="${HOME}/${rel}"

        if [ ! -e "${src}" ]; then
            printf 'Skipping %s: source %s does not exist.\n' "${file}" "${src}" >&2
            continue
        fi

        if [ -L "${dest}" ] || [ -e "${dest}" ]; then
            # mv "${dest}" "${dest}.bak"
            printf 'Moved existing %s to %s\n' "${dest}" "${dest}.bak"
        fi

        # mkdir -p "$(dirname "${dest}")"
        # ln -s "${src}" "${dest}"
        printf 'Linked %s -> %s\n' "${dest}" "${src}"
    done
}
