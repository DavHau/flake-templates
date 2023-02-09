{
  description = "Collection of flake templates";

  outputs = {
    self,
  } @ inp: {
    templates = {
      basic = {
        description = "Basic nix flake with `forAllSystems`";
        path = ./basic;
      };
      flake-parts = {
        description = "Flake using flake-parts (modular flake, makes modules reusable)";
        path = ./flake-parts;
      };
    };
  };
}
