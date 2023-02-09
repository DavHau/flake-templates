{config, lib, ...}: let

  moduleKinds = builtins.readDir ../.;

  mapModules = kind:
    lib.mapAttrs'
    (fn: _:
      lib.nameValuePair
      (lib.removeSuffix ".nix" fn)
      "${../.}/${kind}/${fn}")
    (builtins.readDir ("${../.}/${kind}"));

in {

  options.flake.modules = lib.mkOption {
    type = lib.types.anything;
  };

  # generates future flake outputs: `modules.<kind>.<module-name>`
  config.flake.modules = lib.mapAttrs (kind: _: mapModules kind) moduleKinds;

  # comapt to current schema: `nixosModules` / `darwinModules`
  config.flake.nixosModules = config.flake.modules.nixos or {};
  config.flake.darwinModules = config.flake.modules.darwin or {};
}
