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

### nix-darwin

This repository already includes `nix-darwin` as a flake input, but `darwinConfigurations` is currently empty in [`flake.nix`](/home/kanta/dotnix/flake.nix). After adding a Darwin host such as `macbook`, apply it with:

```bash
darwin-rebuild switch --flake github:KantaTamura/dotnix#macbook
```
