{
  description = "";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };
  };

  outputs = inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } rec {
      systems = [
        "aarch64-darwin"
        "aarch64-linux"
        "x86_64-darwin"
        "x86_64-linux"
      ];

      # auto import all nix code from `./modules`
      imports = builtins.attrValues flake.modules.flakeParts;

      # export all flake modules via `.modules.flakeParts.{file-name}`
      flake.modules.flakeParts =
        builtins.mapAttrs
        (modulePath: _: "${./.}/modules/flake-parts/${modulePath}")
        (builtins.readDir ./modules/flake-parts);
    };
}
