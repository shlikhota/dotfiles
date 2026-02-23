# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a personal macOS dotfiles repository managed declaratively with Nix. It uses **nix-darwin** for system configuration, **home-manager** for user-level dotfiles, and **nix-homebrew** for Homebrew-managed apps — all defined as a single Nix flake targeting `aarch64-darwin`.

## Applying Changes

```bash
# Apply all configuration changes (system + home-manager + homebrew)
sudo darwin-rebuild switch --flake ~/dotfiles#home

# Update all flake inputs (nixpkgs, home-manager, etc.) then apply
nix flake update
sudo darwin-rebuild switch --flake ~/dotfiles#home
```

## Updating Claude Code

The `packages/claude-code.nix` derivation pins a specific Claude Code version fetched directly from Anthropic's native binary distribution. To bump to the latest version:

```bash
./scripts/update-claude.sh
sudo darwin-rebuild switch --flake ~/dotfiles#home
```

## Repository Structure

| File/Dir | Purpose |
|---|---|
| `flake.nix` | Entry point — defines inputs (nixpkgs stable/unstable, nix-darwin, home-manager, catppuccin, nix-homebrew) and the `home` darwin configuration |
| `home.nix` | User-level config: Homebrew casks/brews/mas apps, home-manager programs (fish, fzf, starship, yazi, k9s), symlinked dotfiles |
| `darwin-defaults.nix` | macOS system defaults (dock, finder, trackpad, NSGlobalDomain, etc.) |
| `packages/claude-code.nix` | Custom Nix derivation fetching the Claude Code CLI binary directly from Anthropic |
| `scripts/update-claude.sh` | Fetches latest Claude version + hashes from Anthropic's manifest and patches `claude-code.nix` |
| `.config/` | Dotfiles symlinked into `~/.config/` via `mkOutOfStoreSymlink` (bat, fish, ghostty, git, kanata, nvim, zed) |

## Key Architectural Decisions

- **Stable vs unstable packages**: `flake.nix` defines an overlay that exposes `pkgs.unstable` from `nixpkgs-unstable`. Packages needing bleeding-edge versions (codex, colima, golangci-lint, gopls) are referenced as `unstable.<pkg>`.
- **Dotfiles linking strategy**: Config dirs under `.config/` are symlinked using `config.lib.file.mkOutOfStoreSymlink` so edits to files in the repo take effect immediately without rebuilding.
- **Fish functions path**: `home.nix` generates `~/.config/fish/conf.d/90-dotfiles-paths.fish` at activation time to prepend the repo's fish functions/completions directories to the fish path.
- **Catppuccin theme**: Applied globally via `catppuccin.homeModules.catppuccin` with `flavor = "frappe"`.
- **Kanata**: Keyboard remapping daemon configured via `.config/kanata/kanata.kbd`, launched as a `launchd` daemon alongside the required Karabiner Virtual HID daemon.
