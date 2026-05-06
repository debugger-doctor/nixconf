{ self, inputs, ... }: {

  flake.nixosModules.mainPackages = { config, pkgs, ... }: {

    environment.systemPackages = with pkgs; [
      self.packages.${stdenv.hostPlatform.system}.git
      self.packages.${stdenv.hostPlatform.system}.myKittyTerminal
    ];

  };

}