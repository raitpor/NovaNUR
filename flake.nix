{
  description = "raitpor 自用 Nix 包集合";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      forAllSystems = nixpkgs.lib.genAttrs [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];

      forEachSystem = f: forAllSystems (system:
        let
          pkgs = import nixpkgs { inherit system; };
        in f pkgs
      );
    in
    {
      packages = forEachSystem (pkgs: {
        reasonix-desktop = pkgs.callPackage ./pkgs/reasonix-desktop { };
      });

      # home-manager 通过这种方式也能导入
      legacyPackages = forEachSystem (pkgs:
        import ./default.nix { inherit pkgs; }
      );
    };
}
