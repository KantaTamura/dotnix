# dotnix

This repository contains my Nix-managed system and user configuration.

## Layout

- `flake.nix`: flake inputs and top-level outputs
- `lib/`: builders for NixOS, Home Manager, and nix-darwin
- `modules/common/`: cross-platform modules
- `modules/nixos/`: NixOS-only modules
- `profiles/`: reusable system profiles
- `hosts/nixos/`: machine-specific host definitions
- `home/`: Home Manager profiles and per-user modules

## Usage

### NixOS

Apply a host from this repository directly:

```bash
sudo nixos-rebuild switch --flake github:KantaTamura/dotnix#ms-a2
```

### Home Manager

Apply the standalone Home Manager configuration:

```bash
home-manager switch --flake github:KantaTamura/dotnix#kanta
```

If Home Manager is not installed yet, run it through Nix:

```bash
nix run github:nix-community/home-manager -- switch --flake github:KantaTamura/dotnix#kanta
```

The `kanta` Home Manager profile installs and configures the user environment that used to be provisioned manually, including:

- `git`, `neovim`, `lazygit`, `zsh`
- `starship`, `zoxide`, `eza`, `bat`, `fd`, `fzf`, `fastfetch`
- `direnv`, `nix-direnv`
- development tools such as `clang`, `cmake`, `ninja`, `pkg-config`, `openssl`, `go`, `rustup`, `uv`, `luarocks`, `tree-sitter`, `nixd`

The following still need to be handled outside Home Manager:

- installing Nix itself
- changing the login shell with `chsh`
- `/etc` changes such as system-wide `zshenv`
- OS locale generation and other root-owned system settings

### nix-darwin

This repository already includes `nix-darwin` as a flake input, but `darwinConfigurations` is currently empty in [`flake.nix`](/home/kanta/dotnix/flake.nix). After adding a Darwin host such as `macbook`, apply it with:

```bash
darwin-rebuild switch --flake github:KantaTamura/dotnix#macbook
```

## Verify

You can verify that the flake evaluates and builds the expected outputs without switching immediately.

Check the NixOS system build:

```bash
nix build github:KantaTamura/dotnix#nixosConfigurations.ms-a2.config.system.build.toplevel
```

Check the Home Manager activation package:

```bash
nix build github:KantaTamura/dotnix#homeConfigurations.kanta.activationPackage
```

Check available flake outputs:

```bash
nix flake show github:KantaTamura/dotnix
```
