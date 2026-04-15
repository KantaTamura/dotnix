# XDG base Directory Specification
export XDG_DATA_HOME=$HOME/.local/share
export XDG_CONFIG_HOME=$HOME/.config
export XDG_STATE_HOME=$HOME/.local/state
export XDG_CACHE_HOME=$HOME/.cache

# zsh dotenv
export ZSH_CACHE_DIR=$XDG_CACHE_HOME/zsh

# screenshots
export HYPRSHOT_DIR=$HOME/screenshots

# editor
export EDITOR=nvim

# rust
export RUSTUP_HOME=$XDG_DATA_HOME/rustup
export CARGO_HOME=$XDG_DATA_HOME/cargo

# go
export GOPATH=$XDG_DATA_HOME/go

# zig
export ZVM_PATH=$XDG_DATA_HOME/zvm
export ZVM_INSTALL=$ZVM_PATH/self
export PATH=$ZVM_PATH/bin:$PATH
export PATH=$ZVM_INSTALL:$PATH

# texlive
export TEXMFVAR=$XDG_CACHE_HOME/texlive/texmf-var

# npm
export NPM_CONFIG_USERCONFIG=$XDG_CONFIG_HOME/npm/npmrc

# pnpm
export PNPM_HOME=$XDG_DATA_HOME/pnpm

# gunpg
export GNUPGHOME=$XDG_DATA_HOME/gnupg

# sqlite
export SQLITE_HISTORY=$XDG_CACHE_HOME/sqlite_history

# dotnet
export DOTNET_CLI_HOME=$XDG_DATA_HOME/dotnet

# less
export LESSKEYIN=$XDG_CONFIG_HOME/less/lesskey
export LESSHISTFILE=$XDG_STATE_HOME/less/history

# cuda
export CUDA_CACHE_PATH=$XDG_CACHE_HOME/nv

# jupyter lab
export JUPYTER_CONFIG_DIR=$XDG_CONFIG_HOME/jupyter

# path
export PATH=$HOME/.local/bin:$PATH
export PATH=$PNPM_HOME:$PATH
export PATH=$GOPATH/bin:$PATH
export PATH=$XDG_DATA_HOME/cargo/bin:$PATH
export PATH=$XDG_DATA_HOME/JetBrains/Toolbox/scripts:$PATH
