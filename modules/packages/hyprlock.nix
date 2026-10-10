{ self, inputs, ... }: {

  flake.nixosModules.hyprlock = { pkgs, ... }: {
    programs.hyprlock = {
      enable = true;
      package = self.packages.${pkgs.stdenv.hostPlatform.system}.myHyprlock;
    };
  };

  perSystem = { pkgs, ... }: {

    packages.myHyprlock = inputs.wrapper-modules.wrappers.hyprlock.wrap {
      inherit pkgs;

      
        
    };
  };

}