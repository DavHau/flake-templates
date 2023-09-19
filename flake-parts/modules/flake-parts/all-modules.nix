{
  config,
  lib,
  ...
}: let
  modulesDir = config.modulesDir;

  moduleKinds = builtins.readDir modulesDir;

  mapModules = kind:
    lib.mapAttrs'
    (fn: _:
      lib.nameValuePair
      (lib.removeSuffix ".nix" fn)
      (modulesDir + "/${kind}/${fn}"))
    (builtins.readDir (modulesDir + "/${kind}"));

  flakePartsModules = lib.attrValues (
    lib.filterAttrs
    (modName: _: modName != "all-modules")
    (mapModules "flake-parts")
  );
in {
  imports = flakePartsModules;

  options.flake.modules = lib.mkOption {
    type = lib.types.anything;
  };

  options.modulesDir = lib.mkOption {
    type = lib.types.path;
    description = ''
      Define directory to search for modules which to export via the flake.
      Modules from:
        - {modulesDir}/flake-parts/<name> will be imported automatically and exported to:
          -> flake.modules.flake-parts.<name>
        - {modulesDir}/nixos/<name> will be exported to:
          -> flake.nixosModules.<name>
        - {modulesDir}/<class>/<name> will be exported to:
          -> flake.modules.<class>.<name>
    '';
  };

  # generates future flake outputs: `modules.<kind>.<module-name>`
  config.flake.modules = lib.mapAttrs (kind: _: mapModules kind) moduleKinds;

  # comapt to current schema: `nixosModules` / `darwinModules`
  config.flake.nixosModules = config.flake.modules.nixos or {};
  config.flake.darwinModules = config.flake.modules.darwin or {};
}
