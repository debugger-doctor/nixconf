{ self, ... }: {

  flake.nixosModules.mainPackages = { pkgs, ... }: {

    imports = [
      self.nixosModules.develop
    ];

    environment.systemPackages = with pkgs; [
      networkmanagerapplet
      obs-studio

      self.packages.${stdenv.hostPlatform.system}.git
      self.packages.${stdenv.hostPlatform.system}.myBtop
      self.packages.${stdenv.hostPlatform.system}.myKittyTerminal
      # self.packages.${stdenv.hostPlatform.system}.myNoctalia
    ];

  };

}