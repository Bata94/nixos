# List available commands
default:
  @just --list

# Install NixOS via NixOS-Anywhere. Careful it will delete all that systems data!
install SYSTEM HOST:
  nix run github:nix-community/nixos-anywhere -- --flake .#{{SYSTEM}} --target-host root@{{HOST}}

# Deploy system configuration
deploy SYSTEM HOST:
  nixos-rebuild switch --flake .#{{SYSTEM}} --target-host {{HOST}} --sudo

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
  nix-shell -p alejandra --run "alejandra ."

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

# Collect and delete old Nix Store entries
collect-garbage:
  nix-collect-garbage --delete-older-than 14d --max-jobs auto --cores 0 --quiet
  sudo nix-collect-garbage --delete-older-than 14d --max-jobs auto --cores 0 --quiet

# Collect and delete all old Nix Store entries
collect-garbage-all:
  nix-collect-garbage -d --max-jobs auto --cores 0 --quiet
  sudo nix-collect-garbage -d --max-jobs auto --cores 0 --quiet

alias gc := collect-garbage

sops-edit FILE="secrets/secrets.yaml":
  nix-shell -p sops --run "sops {{FILE}}"

sops-update-keys FILE="secrets/secrets.yaml":
  nix-shell -p sops --run "sops updatekeys {{FILE}}"

sops-HostKey2AgeKey:
  nix-shell -p ssh-to-age --run "cat /etc/ssh/ssh_host_ed25519_key.pub | ssh-to-age"

sopd-PrivateKey2AgeKey:
  nix run nixpkgs#ssh-to-age -- -private-key -i ~/.ssh/id_ed25519 > ~/.config/sops/age/keys.txt
