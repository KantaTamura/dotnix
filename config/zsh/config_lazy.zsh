# make and cd
function mcd() {
    mkdir -p $1
    cd $1
}

# lazy keybindings
bindkey "^J" history-beginning-search-forward
bindkey "^K" history-beginning-search-backward
zsh-defer bindkey "^H" backward-char
bindkey "^L" forward-char

# fzf history
# function fzf-select-history() {
#     BUFFER=$(history -n -r 1 | fzf --query "$LBUFFER" --reverse)
#     CURSOR=$#BUFFER
#     zle reset-prompt
# }
# zle -N fzf-select-history
# bindkey "^R" fzf-select-history
bindkey "^R" histdb-fzf-widget

# eza
if command -v eza &> /dev/null; then
    alias ls='eza --classify=auto --icons=always'
    alias l='eza --all --classify=auto --icons=always'
    alias ll='eza --all --long --group --classify=auto --icons=always'
    alias lt='eza --all --tree --group --classify=auto --icons=always'
fi

# bat
if command -v bat &> /dev/null; then
    alias cat='bat'
	alias -g -- -h='-h 2>&1 | bat --language=help --style=plain'
	alias -g -- --help='--help 2>&1 | bat --language=help --style=plain'
	export MANPAGER="sh -c 'awk '\''{ gsub(/\x1B\[[0-9;]*m/, \"\", \$0); gsub(/.\x08/, \"\", \$0); print }'\'' | bat -p -lman'"
fi

# viu
if command -v viu &> /dev/null; then
	alias gcat='viu'
fi

# lazygit
if command -v lazygit &> /dev/null; then
	alias lg='lazygit'
fi

# fastfetch
if command -v fastfetch &> /dev/null; then
    alias ff='fastfetch'
fi

# bottom
if command -v btm &> /dev/null; then
	alias top='btm --basic'
fi

# clear
alias cls='clear'
alias c='clear'

# ip
alias ip='ip --color=auto'

# wget
alias wget=wget --hsts-file="$XDG_DATA_HOME/wget-hsts"

# sudo
alias sudosu='sudo -E zsh'
