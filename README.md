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
