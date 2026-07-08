{
  description = "raitpor 自用 Nix 包集合";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs }:
    let
      forAllSystems = nixpkgs.lib.genAttrs [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];

      # 提取为函数，packages 和 overlay 共用同一份构建逻辑
      reasonix-desktop = pkgs: pkgs.callPackage ./pkgs/reasonix-desktop { };
    in
    {
      # nix build / nix run 用（走自己的 nixpkgs 实例）
      packages = forAllSystems (system:
        let pkgs = import nixpkgs { inherit system; };
        in { reasonix-desktop = reasonix-desktop pkgs; }
      );

      # ★ home-manager / NixOS 集成推荐方式
      #    overlay 注入到你的 pkgs，allowUnfree 等配置自动生效
      overlays.default = final: prev: {
        inherit (reasonix-desktop final) reasonix-desktop;
      };
    };
}
