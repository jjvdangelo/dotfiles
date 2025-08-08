# zinit and plugins
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

if [ ! -d "${ZINIT_HOME}" ]; then
    mkdir -p "$(dirname ${ZINIT_HOME})"
    git clone https://github.com/zdharma-continuum/zinit.git "${ZINIT_HOME}"
fi

source "${ZINIT_HOME}/zinit.zsh"

# path
typeset -a path_dirs=(
    "/opt/homebrew/bin"
    "/usr/local/go/bin"
    "${HOME}/go/bin"
    "${HOME}/.cargo/bin"
)
for dir in "${path_dirs[@]}"; do
    [[ -d "${dir}" && ":${PATH}:" != *":${dir}:"* ]] && PATH="${PATH}:${dir}"
done

# plugins
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab
zinit ice depth=1; zinit light jeffreytse/zsh-vi-mode

zinit ice lucid; zinit snippet OMZP::git
zinit ice lucid; zinit snippet OMZP::fzf

# nvm
export NVM_DIR="${HOME}/.nvm"
zinit ice lucid; zinit snippet OMZP::nvm

# history
HISTSIZE=1000
HISTFILE=~/.cache/zsh/.zsh_history
SAVEHIST=${HISTSIZE}
HISTDUP=erase

setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

export EDITOR=nvim

# ssh & gpg
eval "$(ssh-agent -s)" >>/dev/null
export GPG_TTY=$TTY

# qol
## vi mode
bindkey -v
## no beeping
unsetopt BEEP
## match on dot files without having to specify the .
setopt globdots 
## move the default zcompdumps
export ZSH_COMPDUMP=~/.cache/zsh/.zcompdump-${HOST}

# docker helpers - not going to check if `docker` exists because
# these aliases don't interfere with anything and if Docker Desktop
# isn't running on Windows, WSL doesn't "see" `docker`--but, if we
# start Docker Desktop then a symlink for `docker` is created in /usr/bin
# and so it's accessible from within an existing shell instance.
export COMPOSE_BAKE=true
alias dup="docker compose up -d"
alias dbuild="docker compose up -d --build"
alias ddbuild="docker compose down -v && dbuild"
alias ddown="docker compose down"
alias dkill="docker compose down -v"

function __warn {
    local msg="${1}"
    echo "[WARNING] ${msg}"
}

# eza
typeset eza_cmd=$(whence -p eza)
if [[ -x $eza_cmd ]]; then
    alias l="${eza_cmd} --icons"
    alias ls="${eza_cmd} -al --icons"
    alias ll="${eza_cmd} -lg --icons"
    alias la="${eza_cmd} -lag --icons"
    alias lt="${eza_cmd} -lTg --icons"
    alias lt1="${eza_cmd} -lTg --level=1 --icons"
    alias lt2="${eza_cmd} -lTg --level=2 --icons"
    alias lt3="${eza_cmd} -lTg --level=3 --icons"
    alias lta="${eza_cmd} -lTag --icons"
    alias lta1="${eza_cmd} -lTag --level=1 --icons"
    alias lta2="${eza_cmd} -lTag --level=2 --icons"
    alias lta3="${eza_cmd} -lTag --level=3 --icons"
else
    typeset _ls=$(whence -p ls)
    alias ls="${_ls} -al"
    alias ll="${_ls} -lg"
    alias la="${_ls} -lag"
    alias lt="${_ls} -lTg"

    __warn "eza is not installed"
fi

# fzf / fd / bat
typeset fzf_cmd=$(whence -p fzf)
typeset bat_cmd=$(whence -p batcat || whence -p bat)

if [[ -x $bat_cmd ]]; then 
    # override `cat` with bat.
    alias cat="$bat_cmd"

    # if we're on a system using `batcat`, create an alias `bat`.
    [[ "${bat_cmd##*/}" == "batcat" ]] && { alias bat="${bat_cmd}" }

    typeset tail_cmd=$(whence -p tail)
    if [[ -x $tail_cmd ]]; then
        btail() {
            command "${tail_cmd}" "${@}" | "$bat_cmd" --paging=never -l log
        }
    fi
else 
    __warn "bat is not installed"
fi

if [[ -x $fzf_cmd ]]; then
    export FZF_COMPLETION_OPTS="--border --info=inline"
    export FZF_COMPLETION_PATH_OPTS="--walker file,dir,follow,hidden"
    export FZF_COMPLETION_DIR_OPTS="--walker dir,follow,hidden"

    typeset fd_cmd=$(whence -p fd)
    if [[ -x $fd_cmd ]]; then
        typeset command_cmd="${fd_cmd} --hidden --strip-cwd-prefix --exclude .git"
        export FZF_DEFAULT_COMMAND="${command} --type f"
        export FZF_CTRL_T_COMMAND="${command} --type f"
        export FZF_ALT_C_COMMAND="${command} --type d"
    else
        __warn "fd not installed"
    fi

    if [[ -x $bat_cmd ]]; then
        typeset preview_cmd="--preview '${bat_cmd} --style=numbers --color=always {}'"
        export FZF_DEFAULT_OPTS=$preview
        export FZF_CTRL_T_OPTS=$preview
        export FZF_ALT_C_OPTS=$preview
        alias fzf="${fzf_cmd} $preview"
    fi
else
    __warn "fzf is not installed"
fi

# completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors '${(s.:.)LS_COLORS}'
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls -al --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls -al --color $realpath'

# shell integrations
function zvm_config() {
    ZVM_LINE_INIT_MODE=${ZVM_MODE_INSERT}
    ZVM_VI_INSERT_ESCAPE_BINDKEY=jj
}

function zvm_after_init() {
    [ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
    bindkey '^p' history-beginning-search-backward
    bindkey '^n' history-beginning-search-forward
    bindkey '^y' autosuggest-accept

    # completions
    autoload -Uz compinit && compinit

    zinit cdreplay -q
    eval "$(zoxide init --cmd cd zsh)"
}

function __set_title() {
    typeset title="${1}"
    echo -ne "\033]0; ${title} \007"
}

function __set_title_precmd() {
    __set_title "$(basename "$PWD")"
}

function __set_title_preexec() {
    typeset cmd=${1%% *}
    __set_title "$cmd"
}

precmd_functions+=(__set_title_precmd)
preexec_functions+=(__set_title_preexec)

type starship_zle-keymap-select >/dev/null || source <(starship init zsh)
