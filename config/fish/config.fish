set -g fish_greeting

set -gx XDG_DATA_HOME $HOME/.local/share
set -gx XDG_CONFIG_HOME $HOME/.config
set -gx XDG_STATE_HOME $HOME/.local/state
set -gx XDG_CACHE_HOME $HOME/.cache

set -gx HYPRSHOT_DIR $HOME/screenshots
set -gx EDITOR nvim
set -gx RUSTUP_HOME $XDG_DATA_HOME/rustup
set -gx CARGO_HOME $XDG_DATA_HOME/cargo
set -gx GOPATH $XDG_DATA_HOME/go
set -gx ZVM_PATH $XDG_DATA_HOME/zvm
set -gx ZVM_INSTALL $ZVM_PATH/self
set -gx TEXMFVAR $XDG_CACHE_HOME/texlive/texmf-var
set -gx NPM_CONFIG_USERCONFIG $XDG_CONFIG_HOME/npm/npmrc
set -gx PNPM_HOME $XDG_DATA_HOME/pnpm
set -gx GNUPGHOME $XDG_DATA_HOME/gnupg
set -gx SQLITE_HISTORY $XDG_CACHE_HOME/sqlite_history
set -gx DOTNET_CLI_HOME $XDG_DATA_HOME/dotnet
set -gx LESSKEYIN $XDG_CONFIG_HOME/less/lesskey
set -gx LESSHISTFILE $XDG_STATE_HOME/less/history
set -gx CUDA_CACHE_PATH $XDG_CACHE_HOME/nv
set -gx JUPYTER_CONFIG_DIR $XDG_CONFIG_HOME/jupyter

fish_add_path -gm $HOME/.local/bin
fish_add_path -gm $PNPM_HOME
fish_add_path -gm $GOPATH/bin
fish_add_path -gm $XDG_DATA_HOME/cargo/bin
fish_add_path -gm $XDG_DATA_HOME/JetBrains/Toolbox/scripts
fish_add_path -gm $ZVM_INSTALL
fish_add_path -gm $ZVM_PATH/bin

if test (uname) = Darwin
    if test -x /opt/homebrew/bin/brew
        eval (/opt/homebrew/bin/brew shellenv)
    end
    set -gx XDG_RUNTIME_DIR /run/user/$UID
end

function __kanta_init_starship
    command -sq starship; or return

    set -l cache_dir $XDG_CACHE_HOME/fish/generated
    set -l cache_file $cache_dir/starship-init.fish
    set -l config_file $XDG_CONFIG_HOME/starship.toml

    mkdir -p $cache_dir

    if not test -r $cache_file
        starship init fish > $cache_file
    else if test -f $config_file; and test $config_file -nt $cache_file
        starship init fish > $cache_file
    end

    source $cache_file

    if functions -q enable_transience
        enable_transience
    end
end

function __kanta_init_zoxide
    command -sq zoxide; or return

    set -l cache_dir $XDG_CACHE_HOME/fish/generated
    set -l cache_file $cache_dir/zoxide-init.fish

    mkdir -p $cache_dir

    if not test -r $cache_file
        zoxide init fish > $cache_file
    end

    source $cache_file
end

function __kanta_import_user_dirs --on-event fish_prompt
    functions -e __kanta_import_user_dirs

    set -l user_dirs $XDG_CONFIG_HOME/user-dirs.dirs
    test -f $user_dirs; or return

    if functions -q fenv
        fenv source $user_dirs
    else if functions -q bass
        bass source $user_dirs
    end
end

function __kanta_ctrl_z
    if jobs -q
        fg >/dev/null 2>/dev/null
    else
        commandline -f repaint
    end
end

function fish_user_key_bindings
    fish_vi_key_bindings

    bind -M insert \e\[A up-or-search
    bind -M insert \e\[B down-or-search
    bind -M insert \e\[3~ delete-char
    bind -M insert \e\[1~ beginning-of-line
    bind -M insert \e\[H beginning-of-line
    bind -M insert \e\[4~ end-of-line
    bind -M insert \e\[F end-of-line
    bind -M insert \cA beginning-of-line
    bind -M insert \cE end-of-line
    bind -M insert \cz __kanta_ctrl_z
    bind -M default \cz __kanta_ctrl_z
    bind \cx\ce edit_command_buffer
end

function mcd --description "mkdir -p and cd"
    mkdir -p $argv[1]
    and cd $argv[1]
end

function nvm --description "Run nvm via bass on demand"
    if not functions -q bass
        echo "bass is required to use nvm from fish" >&2
        return 127
    end

    if not test -f /usr/share/nvm/init-nvm.sh
        echo "nvm init script not found: /usr/share/nvm/init-nvm.sh" >&2
        return 127
    end

    bass source /usr/share/nvm/init-nvm.sh ';' nvm $argv
end

if command -sq eza
    alias ls='eza --classify=auto --icons=always'
    alias l='eza --all --classify=auto --icons=always'
    alias ll='eza --all --long --group --classify=auto --icons=always'
    alias lt='eza --all --tree --group --classify=auto --icons=always'
end

if command -sq bat
    alias cat='bat'
    set -gx MANPAGER "sh -c 'awk '\''{ gsub(/\\x1B\\[[0-9;]*m/, \"\", \\$0); gsub(/.\\x08/, \"\", \\$0); print }'\'' | bat -p -lman'"
end

if command -sq viu
    alias gcat='viu'
end

if command -sq lazygit
    alias lg='lazygit'
end

if command -sq fastfetch
    alias ff='fastfetch'
end

if command -sq btm
    alias top='btm --basic'
end

alias cls='clear'
alias c='clear'
alias ip='ip --color=auto'
alias wget='wget --hsts-file=$XDG_DATA_HOME/wget-hsts'
alias sudosu='sudo -E fish'

__kanta_init_starship
__kanta_init_zoxide
