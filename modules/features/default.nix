{ self, ... }: {

  flake.nixosModules.mainFeatures = {...}: {
    imports = [
      self.nixosModules.gnome
      self.nixosModules.niri
      # self.nixosModules.myHyprland
      self.nixosModules.myVirtualisation
      self.nixosModules.myCustomShell
      self.nixosModules.myHardware
    ];
  };
}