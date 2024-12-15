# List available commands
default:
  @just --list

# Install NixOS via NixOS-Anywhere
install SYSTEM HOST:
  nix run github:nix-community/nixos-anywhere -- --flake .#{{SYSTEM}} --target-host root@{{HOST}}

# Deploy system configuration
deploy SYSTEM HOST:
  nixos-rebuild switch --flake .#{{SYSTEM}} --target-host {{HOST}} --use-remote-sudo

# Update flake
update:
  nix flake update

# Update Home-Manager
update-home-manager:
  nix flake lock --update-input home-manager

# Update Nixvim
update-nixvim:
  nix flake lock --update-input nixvim

# Commit and push changes
commit MESSAGE:
  git add .
  git commit -m "{{MESSAGE}}"
  git push

# Update, commit, and push changes
update-and-commit MESSAGE: update
  @just commit "{{MESSAGE}}"

# Deploy, update, commit, and push changes
deploy-update-commit SYSTEM HOST MESSAGE: (deploy SYSTEM HOST) update
  @just commit "{{MESSAGE}}"

# Check flake
check:
  nix flake check

# Show flake info
show:
  nix flake show

# Format nix files
format:
  alejandra .

alias fmt := format

# Build system configuration
build SYSTEM:
  nixos-rebuild build --flake .#{{SYSTEM}}

# Rebuild local system
rebuild-system:
  nixos-rebuild switch --flake . &>nixos-switch.log || (
  cat nixos-switch.log | grep --color error && false)

# Rebuild local Home-Manager
rebuild-home-manager:
  home-manager switch --flake . &>home-manager-switch.log || (
  cat home-manager-switch.log | grep --color error && false)

# Rebuild local System and Home-Manager
rebuild: rebuild-system rebuild-home-manager
  @echo "Done :)"

# Enter a development shell
dev-shell:
  nix develop
