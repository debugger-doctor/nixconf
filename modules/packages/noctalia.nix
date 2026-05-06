{ self, inputs, ... }: {

  perSystem = { pkgs, system, ... }: {
    packages.myNoctalia = inputs.wrapper-modules.wrappers.noctalia-shell.wrap {
      inherit pkgs;

      package = pkgs.noctalia-shell;
    };
  };

}