# overwrite source
function source {
    ensure_zcompiled $1
    builtin source $1
}
function ensure_zcompiled {
    local compiled="$1.zwc"
    if [[ ! -r "$compiled" || "$1" -nt "$compiled" ]]; then
        echo "\033[1;36mCompiling\033[m $1"
        zcompile $1
    fi
}
ensure_zcompiled $XDG_CONFIG_HOME/zsh/.zshrc

# load config file
source $XDG_CONFIG_HOME/zsh/config.zsh

# make & use sheldon script cache
sheldon_cache="$XDG_CONFIG_HOME/zsh/sheldon.zsh"
sheldon_toml="$XDG_CONFIG_HOME/sheldon/plugins.toml"
if [[ ! -r "$sheldon_cache" || "$sheldon_toml" -nt "$sheldon_cache" ]]; then
    sheldon source > $sheldon_cache
fi
source "$sheldon_cache"
unset sheldon_cache sheldon_toml

# un-overwrite source
zsh-defer unfunction source

# nvm
zsh-defer source /usr/share/nvm/init-nvm.sh
