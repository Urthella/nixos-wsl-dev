# nixos-wsl-dev

[![ci](https://github.com/Urthella/nixos-wsl-dev/actions/workflows/ci.yml/badge.svg)](https://github.com/Urthella/nixos-wsl-dev/actions/workflows/ci.yml)

My Windows dev machine, declared as a NixOS flake on [NixOS-WSL](https://github.com/nix-community/NixOS-WSL). The whole Linux side, from the user account to the shell config, rebuilds from this repo with one command.

| Layer | Source |
|---|---|
| WSL integration, default user `utku` | [NixOS-WSL](https://github.com/nix-community/NixOS-WSL) module |
| System: flakes, zsh, nix-ld, weekly GC, store dedup | [configuration.nix](configuration.nix) |
| User: shell, editor, git, direnv | [dotfiles-nix](https://github.com/Urthella/dotfiles-nix) via home-manager |
| Per-project toolchains | [nix-devshells](https://github.com/Urthella/nix-devshells) templates + direnv |

## Install

1. Install NixOS-WSL on any drive (here, a roomier `E:`). From PowerShell:

   ```powershell
   wsl --install --from-file nixos.wsl --location E:\wsl\NixOS
   ```

2. Inside `wsl -d NixOS`, apply this flake. A fresh install doesn't have flakes enabled yet, so the first run turns them on for that one command:

   ```bash
   sudo nixos-rebuild boot --flake github:Urthella/nixos-wsl-dev#wsl --option experimental-features 'nix-command flakes'
   ```

3. The default user changes from `nixos` to `utku`, which takes effect after a WSL restart. From PowerShell:

   ```powershell
   wsl -t NixOS
   wsl -d NixOS --user root exit
   wsl -t NixOS
   ```

After that, day-to-day changes are `sudo nixos-rebuild switch --flake .#wsl` from a clone.

## Why these choices

- **nix-ld**: VS Code Server, Claude Code and many language servers ship prebuilt Linux binaries that expect `/lib64/ld-linux-x86-64.so.2`. nix-ld provides it without patching each one.
- **Disk care**: `auto-optimise-store` hard-links identical files in `/nix/store`, and a weekly GC deletes generations older than 14 days.
- **Passwordless sudo**: from Windows, `wsl -u root` already gives a root shell, so a sudo password would only add friction.

## CI

Every push and PR builds the complete system closure (`system.build.toplevel`), so a renamed option or removed package fails in CI instead of on the machine.

## License

[MIT](LICENSE)
