# history
export HISTFILE=${XDG_STATE_HOME:-$HOME/.local/state}/zsh/history
export HISTSIZE=100000
export SAVEHIST=100000
setopt extended_history
setopt hist_ignore_all_dups
setopt hist_reduce_blanks
setopt hist_no_store
setopt share_history
setopt hist_ignore_dups
setopt append_history
setopt inc_append_history

# no beep
unsetopt beep

# keybinding
bindkey -v
bindkey "^[[A" history-beginning-search-backward
bindkey "^[[B" history-beginning-search-forward
bindkey "^[[3~" delete-char
bindkey "^[[1~" beginning-of-line
bindkey "^[[H" beginning-of-line
bindkey "^[[4~" end-of-line
bindkey "^[[F" end-of-line
bindkey "^A" beginning-of-line
bindkey "^E" end-of-line
bindkey '^Z' fancy-ctrl-z

autoload -Uz edit-command-line
zle -N edit-command-line
bindkey '^xe' edit-command-line

# for MacOS
if [[ "$(uname)" == "Darwin" ]] then
	eval "$(/opt/homebrew/bin/brew shellenv)"
	export XDG_RUNTIME_DIR=/run/user/$UID
fi

# make & use starship script cache
if command -v starship &> /dev/null; then
    # starship setting
    starship_cache="$XDG_CONFIG_HOME/zsh/starship.zsh"
    starship_toml="$XDG_CONFIG_HOME/starship.toml"
    if [[ ! -r "$starship_cache" || "$starship_toml" -nt "$starship_cache" ]]; then
        starship init zsh > $starship_cache
    fi
    source "$starship_cache"
    unset starship_cache starship_toml
    # starship transient prompt
    source $XDG_CONFIG_HOME/zsh/transient_prompt.zsh
fi

# make & use zoxide script cache
if command -v zoxide &> /dev/null; then
    zoxide_cache="$XDG_CONFIG_HOME/zsh/zoxide.zsh"
    if [[ ! -r "$zoxide_cache" ]]; then
        zoxide init zsh > $zoxide_cache
    fi
    source "$zoxide_cache"
    unset zoxide_cache
fi

# history per directory
source $XDG_CONFIG_HOME/zsh/cwd_history.zsh

# load user dirs
if [[ -f $XDG_CONFIG_HOME/user-dirs.dirs ]]; then
	source $XDG_CONFIG_HOME/user-dirs.dirs
fi

# fix duplicate PATH
typeset -U path
export PATH
