{
  description = "NixOS-WSL dev machine: flakes, zsh, nix-ld and my home-manager dotfiles";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL/main";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    dotfiles = {
      url = "github:Urthella/dotfiles-nix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
  };

  outputs = { nixpkgs, nixos-wsl, home-manager, dotfiles, ... }: {
    nixosConfigurations.wsl = nixpkgs.lib.nixosSystem {
      modules = [
        nixos-wsl.nixosModules.default
        home-manager.nixosModules.home-manager
        ./configuration.nix
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.utku = dotfiles.homeModules.default;
        }
      ];
    };
  };
}
