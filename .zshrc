# zinit and plugins
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

if [ ! -d "$ZINIT_HOME" ]; then
    mkdir -p "$(dirname $ZINIT_HOME)"
    git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

source "${ZINIT_HOME}/zinit.zsh"

# path
path_dirs=(
    "/usr/local/go/bin"
    "$HOME/.cargo/bin"
)
for dir in "${path_dirs[@]}"; do
    if [[ ":$PATH:" != *":$dir:"* ]]; then
        export PATH="$PATH:$dir"
    fi
done

# plugins
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab
zinit ice depth=1; zinit light jeffreytse/zsh-vi-mode

zinit ice lucid wait; zinit snippet OMZP::git
zinit ice lucid wait; zinit snippet OMZP::fzf

# history
HISTSIZE=1000
HISTFILE=~/.cache/zsh/.zsh_history
SAVEHIST=$HISTSIZE
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
export ZSH_COMPDUMP=~/.cache/zsh/.zcompdump-$HOST

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
alias bat="batcat"
alias cat="bat"
alias fzf="fzf --preview \"batcat --color=always --style=numbers --line-range=:500 {}\""
help() {
    "$@" --help 2>&1 | batcat --plain --language=help
}
alias -g -- -h="-h 2>&1 | batcat --language=help --style=plain"
alias -g -- --help="--help 2>&1 | batcat --language=help --style=plain"

# nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# ssh
eval "$(ssh-agent -s)" >>/dev/null

# completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors '${(s.:.)LS_COLORS}'
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls -al --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls -al --color $realpath'

# shell integrations
type starship_zle-keymap-select >/dev/null || {
    eval "$(starship init zsh)"
}

function zvm_config() {
    ZVM_LINE_INIT_MODE=$ZVM_MODE_INSERT
    ZVM_VI_INSERT_ESCAPE_BINDKEY=jj
}

function zvm_after_init() {
    eval "$(zoxide init --cmd cd zsh)"
    [ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
    bindkey '^p' history-beginning-search-backward
    bindkey '^n' history-beginning-search-forward
    bindkey '^ ' autosuggest-accept

    # completions
    autoload -Uz compinit && compinit

    zinit cdreplay -q
}

__set_title() {
    case "$TERM" in
        linux|dumb) return ;;
    esac

    local title="$1"

    if [[ -n "$TMUX" ]]; then
        printf '\033Ptmux;\033\033]0;%s\007\033\\' "${title}"
    else
        printf '\033]0;%s\007' "${title}"
    fi
}

preexec() { __set_title "${1%% *}" ; }
precmd() { __set_title "${PWD/#$HOME/~}" ; }
