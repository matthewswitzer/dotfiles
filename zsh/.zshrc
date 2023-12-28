# Zsh Configuration

## Remove older command from history if a duplicate is to be added
setopt HIST_IGNORE_ALL_DUPS

## Set editor default keymap to emacs (`-e`) or vi (`-v`)
bindkey -e

## Remove path separator from WORDCHARS
WORDCHARS=${WORDCHARS//[\/]}

## Set what highlighters will be used
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets)


# Zim Configuration

## Initialize modules
ZIM_HOME=${ZDOTDIR:-${HOME}}/.zim
if [[ ! -e ${ZIM_HOME}/zimfw.zsh ]]; then
  ### Download zimfw script if missing.
  if (( ${+commands[curl]} )); then
    curl -fsSL --create-dirs -o ${ZIM_HOME}/zimfw.zsh https://github.com/zimfw/zimfw/releases/latest/download/zimfw.zsh
  else
    mkdir -p ${ZIM_HOME} && wget -nv -O ${ZIM_HOME}/zimfw.zsh https://github.com/zimfw/zimfw/releases/latest/download/zimfw.zsh
  fi
fi
if [[ ! ${ZIM_HOME}/init.zsh -nt ${ZDOTDIR:-${HOME}}/.zimrc ]]; then
  ### Install missing modules, and update ${ZIM_HOME}/init.zsh if missing or outdated.
  source ${ZIM_HOME}/zimfw.zsh init -q
fi
source ${ZIM_HOME}/init.zsh


# User Configuration

## Ensure user-install binaries take precedence
export PATH="/opt/homebrew/sbin:$PATH"
export PATH="$HOME/.local/bin:$PATH"

## Variables
export DOTFILES="$HOME/.dotfiles"
export PROJECTS="$HOME/Developer/Projects"
export ICLOUD="$HOME/Library/Mobile Documents/com~apple~CloudDocs"

## Aliases
alias lla="ls -alh"
alias lzg="lazygit"
alias lzd="lazydocker"

## Homebrew
export HOMEBREW_CASK_OPTS="--appdir=/Applications"
export HOMEBREW_NO_ANALYTICS=1
export HOMEBREW_NO_ENV_HINTS=1

## Docker
export DOCKER_HOST=unix:///var/run/docker.sock

## Go
export GOPATH="$HOME/.go"

## Set neovim as the default editor
if [ -x "$(command -v nvim)" ]; then
    export EDITOR=nvim
    export VISUAL=$EDITOR

    ### Use neovim instead of vim or vi
    alias vim=nvim
    alias vi=nvim

    ### Neovim config and data locations
    export VIMCONFIG=$HOME/.config/nvim
    export VIMDATA=$HOME/.local/share/nvim

    ### Prevent nesting neovim instances with nvr
    if [ -n "$NVIM_LISTEN_ADDRESS" ]; then
        if [ -x "$(command -v nvr)" ]; then
            export VISUAL="nvr -cc split --remote-wait +'set bufhidden=wipe'"
            alias nvim=nvr
        else
            alias nvim='echo "No Nesting!"'
        fi
    fi
fi

## Bind <C-x><C-e> to edit-command-line
autoload -U edit-command-line
zle -N edit-command-line
bindkey '^x^e' edit-command-line

## Load pipx completions
if type pipx &>/dev/null; then
    autoload -U bashcompinit
    bashcompinit

    eval "$(register-python-argcomplete pipx)"
fi

## Load Homebrew-managed completions
if type brew &>/dev/null; then
    FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"
fi

## Load manually configured completions
if [ -d "$HOME/.zfunc/completions" ]; then
    FPATH="$HOME/.zfunc/completions:$FPATH"
fi

## Initialize completion system
autoload -Uz compinit && compinit
