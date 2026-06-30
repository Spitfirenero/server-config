# nixos-config

Modular flake-based NixOS configuration.

## Structure

- `flake.nix` - flake entrypoint
- `hosts/server/default.nix` - host module imports + host-level settings
- `hosts/server/networking.nix` - static network config
- `hosts/server/hardware-configuration.nix` - placeholder hardware config to replace with `nixos-generate-config`
- `modules/*.nix` - reusable modules (ssh, firewall, users, etc.)

## Usage

```bash
sudo nix flake update /etc/nixos
sudo nixos-rebuild test --flake /etc/nixos#nixos
sudo nixos-rebuild switch --flake /etc/nixos#nixos
```
