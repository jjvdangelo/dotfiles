# .dotfiles/lib/common.sh  (POSIX-compliant; guarded against double-load)
# shellcheck shell=sh disable=SC3043 # 'local' supported in target shells
[ -n "${_DOTFILES_COMMON_LOADED+x}" ] && return
_DOTFILES_COMMON_LOADED=1

set -eu

DF_BASE="${HOME}/.dotfiles"

OS="$(uname -s)"
PKG_CMD=""

err() { printf "Error: %s.\n" "$*" >&2; exit 1; }

_detect_pkg_manager() {
    case "${OS}" in
        Darwin)
            command -v brew >/dev/null 2>&1 || {
                err "Homebrew not found"
            }

            PKG_CMD="brew install"
            ;;
        Linux)
            sudo_prefix=""
            [ "$(id -u)" -eq 0 ] || sudo_prefix="sudo "

            for try in "apt-get install -y" \
                       "dnf install -y" \
                       "yum install -y" \
                       "pacman -Sy --noconfirm" \
                       "zypper install -y"
            do
                candidate=${try%% *}
                if command -v "${candidate}" >/dev/null 2>&1; then
                    PKG_CMD="${sudo_prefix}${try}"
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
        printf "Installing %s.\n" "${pkg}"
        # shellcheck disable=SC2086 # intentional word splitting
        $PKG_CMD "${pkg}"
    done
}

prompt_and_validate() {
    var="${1}"; prompt="${2}"; regex="${3}"; default="${4:-}"

    while true; do
        if [ -n "${default}" ]; then
            printf "%s [%s]" "${prompt}" "${default}" >/dev/tty
        else
            printf "%s " "${prompt}" >/dev/tty
        fi

        IFS= read -r input </dev/tty
        [ -z "${input}" ] && input="${default}"

        printf "%s\n" "${input}" | grep -E -q "${regex}" && {
            eval "${var}=\${input}"
            return
        }

        printf "Invalid input.\n" >/dev/tty
    done
}

link_files() {
    for src in "${@}"; do
        local rel="${src#"${HOME}"/.dotfiles/}"

        if [ "${rel}" = "${src}" ]; then
            printf "Skipping invalid source (not under ~/.dotfiles): %s\n" "${src}" >&2
            continue
        fi

        local dest="${HOME}/${rel}"

        if [ ! -e "${src}" ]; then
            printf "Skipping %s: source does not exist.\n" "${src}" >&2
            continue
        fi

        if [ -L "${dest}" ] || [ -e "${dest}" ]; then
            if mv "${dest}" "${dest}.bak"; then
                printf 'Moved existing %s to %s\n' "${dest}" "${dest}.bak"
            else
                printf 'Failed to move %s to %s; skipping\n' "${dest}" "${dest}.bak" >&2
                continue
            fi
        fi

        mkdir -p "$(dirname "${dest}")"
        if ln -sf "${src}" "${dest}"; then
            printf 'Linked %s -> %s\n' "${dest}" "${src}"
        else
            printf 'Failed to link %s -> %s\n' "${dest}" "${src}" >&2
        fi
    done
}

link_config() {
    # $1 - destination directory that will be interpreted relative to ${HOME} (e.g., .config → ~/.config)
    # $2 - folder name (.e.g, nvim)
    local dest_dir="${1}"
    local name="${2}"

    local src="${DF_BASE}/${name}"
    local dest="${HOME}${dest_dir:+/${dest_dir}}/${name}"

    printf "Creating symlink\n  %s → %s\n" "${src}" "${dest}"

    [ -d "${src}" ] || {
        printf "⤹ Skipping %s (source not found)\n" "${src}"
        return
    }

    local target_dir
    target_dir="$(dirname "${dest}")"
    mkdir -p "${target_dir}" || err "Failed to create ${target_dir} directory"

    if [ -e "${dest}" ] && [ ! -L "${dest}" ]; then
        # Treating this as an error for now until we gain confidence that it's ok
        # to show a warning instead.
        err "${dest} exists (not a symlink) - skipping"
    fi

    if [ -L "${dest}" ]; then
        local current
        current="$(readlink "${dest}")" || true
        [ "${current}" = "${src}" ] && {
            printf "⤹ %s is already linked – skipping\n" "${dest}"
            return
        }

        # Treating this as an error for now until we gain confidence that it's ok
        # to show a warning instead.
        err "${dest} exists (points elsewhere) - skipping"
    fi

    ln -s "${src}" "${dest}" || err "Failed to create symlink for ${name}"
    printf "  ✓ Linked %s → %s\n" "${dest}" "${src}"
}

link_configs() {
    # $1 - destination directory relative to ${HOME}
    # remaining args - list of folder names
    local dest_dir="${1}"; shift
    [ "$#" -ge 1 ] || err "link_configs: at least one folder name required"
    for cfg in "$@"; do
        link_config "${dest_dir}" "${cfg}"
    done
}
