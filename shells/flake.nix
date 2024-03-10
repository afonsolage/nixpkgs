{
    inputs = {
        nixpkgs.url = "nixpkgs/nixos-23.11";
    };
    outputs = {self, nixpkgs, ...}:
    let
        system = "x86_64-linux";
        pkgs = nixpkgs.legacyPackages.${system};
        buildInputs = with pkgs; [
            udev alsa-lib vulkan-loader
            xorg.libX11 xorg.libXcursor xorg.libXi xorg.libXrandr #x11
            libxkbcommon wayland #wayland
        ];
    in
    with pkgs; {
        devShells.${system} = {
            bevy = mkShell {
                name = "bevy";
                nativeBuildInputs = [
                    pkg-config
                ];
                inherit buildInputs;
                shellHook = ''export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:${lib.makeLibraryPath buildInputs}"'';
            };
        };
    };
}
