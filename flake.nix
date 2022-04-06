{
  description = "Collection of flake templates";

  outputs = {
    self,
  } @ inp: {
    templates = {
      basic = {
        description = "Basic nix flake with `forAllSystems`";
      };
    };
  };
}
