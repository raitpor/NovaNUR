# NovaNUR — raitpor 自用 Nix 包集合
# https://github.com/raitpor/NovaNUR
{ pkgs ? import <nixpkgs> {} }: {
 reasonix-desktop = pkgs.callPackage ./pkgs/reasonix-desktop { };
}
