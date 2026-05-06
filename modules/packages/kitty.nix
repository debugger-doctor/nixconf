{ self, inputs, ... }: {

  perSystem = { pkgs, lib, ... }: {
    packages.myKittyTerminal = inputs.wrapper-modules.wrappers.kitty.wrap {
      inherit pkgs;

      package = pkgs.kitty;

      settings = {
        enable_audio_bell = "no";

        font_size = 15;
        cursor_text_color = "background";

        allow_remote_control = "yes";
        shell_integration = "yes";

        shell = "/run/current-system/sw/bin/zsh --login";

        cursor_trail = 3;

        background_opacity = "0.85";
        dynamic_background_opacity = "yes";
      };
    };
  };

}
