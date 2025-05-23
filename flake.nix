{
  description = "My NixOS Configurations";

  inputs = {
    # NixOS official package source
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      # The `follows` keyword in inputs is used for inheritance.
      # Here, `inputs.nixpkgs` of home-manager is kept consistent with
      # the `inputs.nixpkgs` of the current flake,
      # to avoid problems caused by different versions of nixpkgs.
      inputs.nixpkgs.follows = "nixpkgs";
    };

    musnix  = { url = "github:musnix/musnix"; };
  };

  outputs = { nixpkgs, home-manager, musnix, ... }@inputs:
    let 
      customPkgs = ./pkgs/default.nix;
      nixpkgs-cfg = ({ nixpkgs, ... }:
        {
          nixpkgs = {
            config.allowUnfree = true;
            overlays = [ (import ./pkgs/overlay.nix) ];
          };
        });
    in {
    # Please replace my-nixos with your hostname
    nixosConfigurations.brokoli = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };
      modules = [
        inputs.musnix.nixosModules.musnix

        ./modules/brokoli-configuration.nix

        nixpkgs-cfg

        # make home-manager as a module of nixos
        # so that home-manager configuration will be deployed automatically when executing `nixos-rebuild switch`
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;

          home-manager.users.fading = import ./home/fading-home.nix;

          # Optionally, use home-manager.extraSpecialArgs to pass arguments to home.nix
        }
      ];
    };
  };
}
