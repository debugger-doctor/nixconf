{ self, ... }: {

  flake.nixosModules.mainPackages = { pkgs, ... }: {

    imports = [
      self.nixosModules.develop
      self.nixosModules.myNeovim
    ];

    nixpkgs.overlays = [
      (final: prev: {
        noctalia-qs = prev.noctalia-qs.overrideAttrs (old: {
          patches = (old.patches or [ ]) ++ [ ./noctalia-qs-qt612.patch ];
        });
      })
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