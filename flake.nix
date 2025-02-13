{
  description = "rngadam's homelab";

  inputs = {
    # NixOS official package source, using the nixos-24.11 branch here
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    agenix.url = "github:ryantm/agenix";
    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, agenix, ... }@inputs: {
    nixosConfigurations.nixos02 = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        # Import the previous configuration.nix we used,
        # so the old configuration file still takes effect
        ./configuration.nix
        ./tailscale.nix
        ./caddy.nix
        ./peertube.nix
        ./virtiofs.nix
        home-manager.nixosModules.home-manager 
	{
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.verbose = true;
            home-manager.users.rngadam = import ./home.nix;
            home-manager.backupFileExtension = "bak";
	}
        agenix.nixosModules.default
        {
            environment.systemPackages = [ agenix.packages.x86_64-linux.default ];
        }
      ];
    };

    nixosConfigurations.nixos01 = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        # Import the previous configuration.nix we used,
        # so the old configuration file still takes effect
        ./configuration.nix
        home-manager.nixosModules.home-manager 
	{
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.verbose = true;
            home-manager.users.rngadam = import ./home.nix;
            home-manager.backupFileExtension = "bak";
	}
      ];
    };
  };
}
