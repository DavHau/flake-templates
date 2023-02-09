{config, lib, ...}: let

  modulesDir = ../.;

  moduleKinds = builtins.readDir modulesDir;

  mapModules = kind:
    lib.mapAttrs'
    (fn: _:
      lib.nameValuePair
      (lib.removeSuffix ".nix" fn)
      "${modulesDir}/${kind}/${fn}")
    (builtins.readDir ("${modulesDir}/${kind}"));

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
