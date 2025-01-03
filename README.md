# Configurations

## Install dependencies
```bash
xcode-select --install
```

## Install nix
```bash
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
```

## Clone configurations
```bash
git clone https://github.com/shlikhota/dotfiles.git ~/dotfiles
```

## Apply nix configs
```bash
nix run nix-darwin -- switch --flake ~/dotfiles#home
```

## Update configuration
```bash
nix flake update
darwin-rebuild switch --flake ~/dotfiles#home
```
