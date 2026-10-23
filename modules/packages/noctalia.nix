{ self, inputs, ... }: {

  perSystem = { pkgs, system, ... }: {
    packages.myNoctalia =
    let
      noctaliaQsPatched = pkgs.noctalia-qs.overrideAttrs (old: {
        patches = (old.patches or [ ]) ++ [ ./noctalia-qs-qt612.patch ];
      });

      noctaliaShellWithQs = pkgs.noctalia-shell.override {
        noctalia-qs = noctaliaQsPatched;
      };

      noctaliaFixed = noctaliaShellWithQs.overrideAttrs (oldAttrs: {
        postPatch = (oldAttrs.postPatch or "") + ''
          find . -name "template-apply.sh" -exec sed -i '/KITTY_CONF=.*config\/kitty/,/fi/d' {} +
          find . -type f -exec sed -i 's/kitty +runpy.*//g' {} +
          find . -type f -exec sed -i 's/kitty +kitten.*//g' {} +
        '';
      });
    in
    inputs.wrapper-modules.wrappers.noctalia-shell.wrap {
      inherit pkgs;

      package = noctaliaFixed;
      # package = pkgs.noctalia-shell;
    };
  };

}