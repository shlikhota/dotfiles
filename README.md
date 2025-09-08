# Configurations

This repository contains a collection of personalized dotfiles for macOS, managed declaratively using Nix, including:
- System packages and applications
- Terminal and shell configurations
- Development tools
- Custom settings for macOS

## Prerequisites (optional)
Terminal should have full disk access to apply Safari settings because of [containerization](https://lapcatsoftware.com/articles/containers.html) (System Settings -> Privacy & Security -> Full Disk Access)

## Install
```bash
bash <(curl -sL https://raw.githubusercontent.com/shlikhota/dotfiles/main/install)
```

## Update
```bash
nix flake update
sudo darwin-rebuild switch --flake ~/dotfiles#home
```

## Unautomated

Some things still have to do manually:
- add applications to the "Open at Login" list (such as Raycast, Shortcat, etc.)
- add alternative source input (Czech and Russian in my case)
- turn off Dictation (System Settings -> Keyboard -> Dictation -> Shortcut)
- export/import Raycast config

## Useful nix commands

```bash
# delete old generations (versions) of nix store
nix-collect-garbage -d

# run shell with some temporary installed packages
nix-shell -p llama-cpp aider-chat

# run package without installing it globally
nix run nixpkgs#neofetch
```

## AI suggestions for commit messages

Ollama:
```sh
set -U AI_COMMIT_PROVIDER "ollama"
set -U OLLAMA_MODEL "qwen2.5-coder:7b"
set -U OLLAMA_NUM_CTX 32768
git commit -m <tab> # or just `gcm` that use fzf
```

OpenAI:
```sh
set -U AI_COMMIT_PROVIDER "openai"
set -U OPENAI_TOKEN "your_token"
set -U OPENAI_MODEL "" # optional, gpt-4o-mini as default
git commit -m <tab> # or just `gcm` that use fzf
```
