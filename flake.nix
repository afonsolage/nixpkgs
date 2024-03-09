{
  description = "Afonso-PC Flakes";

  inputs = {
	nixpkgs.url = "nixpkgs/nixos-23.11";
	home-manager.url = "github:nix-community/home-manager/release-23.11";
	home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, home-manager, ... }: 
 	let
		lib = nixpkgs.lib;
		lib-hm = home-manager.lib;
		system = "x86_64-linux";
		pkgs = import nixpkgs { inherit system; config.allowUnfree = true; };

	in {
		nixosConfigurations = {
			afonso-pc = lib.nixosSystem {
				inherit pkgs;
				modules = [ ./configuration.nix ];
			};
		};
		homeConfigurations = {
			afonsolage = home-manager.lib.homeManagerConfiguration {
				inherit pkgs;
				modules = [ ./home.nix ];
			};
		};
  	};
}
