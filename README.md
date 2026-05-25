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

## Initial Setup

### Install Nix

If Nix is not installed yet, install it with the official Nix installer before using any flake output from this repository.

On macOS, the official manual recommends the multi-user install:

```bash
bash <(curl -L https://nixos.org/nix/install) --daemon
```

On non-NixOS Linux, install Nix first as well. If the machine supports the multi-user install, prefer that; otherwise use the mode described in the official Nix manual for your environment.

After installation, open a new shell and confirm that Nix is available:

```bash
nix --version
```

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

- changing the login shell with `chsh`
- OS locale generation and other root-owned system settings

### nix-darwin

This repository now exposes a Darwin host named `macbook` for Apple Silicon Macs.

Recommended initial setup on a fresh Mac:

1. Install Apple's Command Line Tools first:

```bash
xcode-select --install
```

This installs the basic macOS development toolchain such as `git`, `clang`, `make`, `xcrun`, and SDK headers. For terminal-based development this is usually enough. Install the full Xcode app only if you need the IDE, simulators, or tools such as `xcodebuild`.

2. Install Nix with the official installer:

```bash
bash <(curl -L https://nixos.org/nix/install) --daemon
```

3. Apply the Darwin configuration for the first time:

```bash
sudo nix run github:nix-darwin/nix-darwin/master#darwin-rebuild -- switch --flake github:KantaTamura/dotnix#macbook
```

This bootstrap step is needed because `nix-darwin` is not installed on a fresh Mac, so `darwin-rebuild` is not yet available in `PATH`.

The published `macbook` host currently targets Apple Silicon. If the Mac is Intel or you want to customize the host locally, clone the repository and edit [`flake.nix`](/flake.nix) before switching.

After the first switch, `darwin-rebuild` should be available in your environment, so later updates can be applied with:

```bash
sudo darwin-rebuild switch --flake github:KantaTamura/dotnix#macbook
```

The Darwin profile includes a few opinionated defaults in [`profiles/darwin/base.nix`](/profiles/darwin/base.nix), each documented inline:

- Touch ID for `sudo`
- faster key repeat and disabled smart substitutions for coding
- Dock autohide and stable Spaces ordering
- Finder path/status bars and always-visible file extensions
- tap-to-click and three-finger drag
- screenshot output under `~/Pictures/Screenshots`

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

Build a disposable NixOS VM that applies the current `home-manager` config for `kanta`:

```bash
nix build github:KantaTamura/dotnix#home-manager-vm
./result/bin/run-home-manager-vm-vm
```

The VM skips host-specific NixOS hardware settings and is intended only for checking the Home Manager environment. It autologins as `kanta`, and SSH is exposed on host port `2222`.

You can also log in over SSH:

```bash
ssh kanta@localhost -p 2222
```

The initial password for `kanta` is `nixos`.

To leave the VM cleanly, run `poweroff` inside the guest. To quit QEMU directly from the console, use `Ctrl-a x`.

Check available flake outputs:

```bash
nix flake show github:KantaTamura/dotnix
```

## Contributing

If you want to modify this repository, test local changes before publishing them, or adapt the Darwin host for a different machine, work from a local clone:

```bash
git clone https://github.com/KantaTamura/dotnix.git
cd dotnix
```

Useful local verification commands:

```bash
nix flake show .
nix build .#homeConfigurations.kanta.activationPackage
nix eval .#darwinConfigurations.macbook.config.system.build.toplevel.drvPath
```

To apply a local Darwin change from the clone before it is pushed:

```bash
sudo nix run github:nix-darwin/nix-darwin/master#darwin-rebuild -- switch --flake .#macbook
```
