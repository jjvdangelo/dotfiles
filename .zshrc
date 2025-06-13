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

# keeper
export SSH_AUTH_SOCK=${HOME}/.keeper/jjvd@hey.com.ssh_agent

# pipx
# eval "$(register-python-argcomplete pipx)"
# zinit ice lucid; zinit snippet OMZP::pip # could use pip instead /shrug

# nvm
export NVM_DIR="${HOME}/.nvm"
# [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
# [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
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

# qol
## vi mode
bindkey -v
## no beeping
unsetopt BEEP
## match on dot files without having to specify the .
setopt globdots 
## move the default zcompdumps
export ZSH_COMPDUMP=~/.cache/zsh/.zcompdump-${HOST}

# docker helpers
alias dup="docker compose up -d"
alias dbuild="COMPOSE_BAKE=true docker compose up -d --build"
alias ddbuild="docker compose down -v && dbuild"
alias ddown="docker compose down"
alias dkill="docker compose down -v"

# eza
alias l="eza --icons"
alias ls="eza -al --icons"
alias ll="eza -lg --icons"
alias la="eza -lag --icons"
alias lt="eza -lTg --icons"
alias lt1="eza -lTg --level=1 --icons"
alias lt2="eza -lTg --level=2 --icons"
alias lt3="eza -lTg --level=3 --icons"
alias lta="eza -lTag --icons"
alias lta1="eza -lTag --level=1 --icons"
alias lta2="eza -lTag --level=2 --icons"
alias lta3="eza -lTag --level=3 --icons"

# bat
function config_bat() {
    typeset exe_name="${${commands[batcat]:-}:+batcat}${${commands[bat]:-}:+bat}"
    [[ -z "${exe_name}" ]] && { echo "**** bat is not installed ****" &>2; return }
    [[ "${exe_name}" != "bat" ]] && { alias bat="batcat" }

    # alias -g -- -h="-h 2>&1 | ${exe_name} --language=help --style=plain"
    alias -g -- --help="--help 2>&1 | ${exe_name} --language=help --style=plain"
    alias fzf="fzf --preview \"${exe_name} --color=always --style=numbers --line-range=:500 {}\""
    alias cat="${exe_name}"
}
config_bat


# ssh
# if command -v keeper >/dev/null 2>&1; then
#     if ! keeper ssh-agent info >/dev/null 2>&1; then
#         keeper ssh-agent start
#     fi
# fi
# export SSH_AUTH_SOCK="${HOME}/.keeper/ssh-agent.sock"
# export SSH_AUTH_SOCK="${HOME}/.keeper/jjvd@hey.com.ssh_agent"
# eval "$(ssh-agent -s)" >>/dev/null
export SSH_AUTH_SOCK="${HOME}/.keeper/jjvd@hey.com.ssh_agent"

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
