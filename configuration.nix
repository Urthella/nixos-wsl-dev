{ pkgs, ... }:

{
  nixpkgs.hostPlatform = "x86_64-linux";

  wsl.enable = true;
  wsl.defaultUser = "utku";

  users.users.utku.shell = pkgs.zsh;
  programs.zsh.enable = true;

  # `wsl -u root` already opens a root shell from Windows, so a sudo password adds no real protection here.
  security.sudo.wheelNeedsPassword = false;

  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    trusted-users = [ "utku" ];
    # The disk is small: hard-link identical store files and drop old generations weekly.
    auto-optimise-store = true;
  };
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 14d";
  };

  # Lets prebuilt Linux binaries (VS Code Server, Claude Code, language servers) find a dynamic loader.
  programs.nix-ld.enable = true;

  environment.systemPackages = with pkgs; [ git curl wget ];

  system.stateVersion = "26.05";
}
