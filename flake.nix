{
  description = "Afonso-PC Flakes";

  inputs = {
	nixpkgs.url = "nixpkgs/nixos-23.11";
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";
	home-manager.url = "github:nix-community/home-manager/release-23.11";
	home-manager.inputs.nixpkgs.follows = "nixpkgs";
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, home-manager, neovim-nightly-overlay, ... }: 
 	let
		lib = nixpkgs.lib;
		lib-hm = home-manager.lib;
		system = "x86_64-linux";
		pkgs = import nixpkgs { 
            inherit system; 
            overlays = [neovim-nightly-overlay.overlay];
            config.allowUnfree = true; 
        };
		pkgs-unstable = import nixpkgs-unstable { inherit system; config.allowUnfree = true; };
	in {
		nixosConfigurations = {
			afonso-pc = lib.nixosSystem {
				inherit pkgs;
                specialArgs = { inherit pkgs-unstable; };
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
