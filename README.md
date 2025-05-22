# DotFiles

## Install Nix
Nix must first be installed. Please refer to the [Nix documentation](https://nix.dev/install-nix).


## Clone Repo
```shell
nix-shell -P git # If you need access to git
git clone git@github.com:chrhjoh/dotfiles.git ~/.dotfiles
```    

## Build Flake

### On Darwin:
The darwin build does depend on homebrew for some GUI applications as these are not integrated as nicely with nix-darwin.
Installation guide for homebrew can be found [here](https://brew.sh)

```shell
cd ~/.dotfiles && nix build ".#darwinConfigurations.$HOST.system" && ./result/sw/bin/darwin-rebuild switch --flake ".#$HOST"
```

# Updating

## Updating flake.lock

If the flake.lock needs to be updated:

```shell
nix flake update
```

or for a single input

```shell
nix flake lock --update-input my-input
```

## Rebuilding and Switching

To update the system after making changes:

### On Darwin

```shell
darwin-rebuild switch --flake ".#$HOST"
```



