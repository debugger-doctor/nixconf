{ self, inputs, ... }: {

  flake.nixosModules.mainFeatures = { config, pkgs, ... }: {
    imports = [
      self.nixosModules.myVirtualisation
      self.nixosModules.niri
      self.nixosModules.myCustomShell
      self.nixosModules.mainPackages
    ];
  };
}