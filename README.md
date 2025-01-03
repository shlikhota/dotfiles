# Configurations

This repository contains a collection of personalized dotfiles for macOS, managed declaratively using Nix, including:
- System packages and applications
- Terminal and shell configurations
- Development tools
- Custom settings for macOS

## Install
```bash
bash <(curl -sL https://raw.githubusercontent.com/shlikhota/dotfiles/main/install)
```

## Update
```bash
nix flake update
darwin-rebuild switch --flake ~/dotfiles#home
```
