{ self, inputs, ... }: {

  flake.nixosModules.niri = { pkgs, lib, ... }: {
    programs.niri = {
      enable = true;
      package = self.packages.${pkgs.stdenv.hostPlatform.system}.myNiri;
    };
  };

  perSystem = { pkgs, lib, self', ... }: {

    packages.myNiri = inputs.wrapper-modules.wrappers.niri.wrap {
      inherit pkgs;

      package = pkgs.niri;

      settings = {
        spawn-at-startup = [ (lib.getExe self'.packages.myNoctalia) ];
        input = {
          keyboard = { xkb.layout = "br"; };
          # touchpad = {
          #   tap = { };
          #   natural-scroll = { };
          # };
        };

        window-rules = [
          
        ];

        prefer-no-csd = true;
        
        binds = {
          "Mod+Space".show-hotkey-overlay = [ ];
          "Mod+Return".spawn-sh = lib.getExe self'.packages.myKittyTerminal;
          "Mod+Q".close-window = [ ];

          "Mod+D".spawn = [ (lib.getExe self'.packages.myNoctalia) "ipc" "call" "launcher" "toggle" ];
          "Mod+S".spawn = [ (lib.getExe self'.packages.myNoctalia) "ipc" "call" "settings" "toggle" ];
          "Mod+L".spawn = [ (lib.getExe self'.packages.myNoctalia) "ipc" "call" "lockScreen" "lock" ];
          "Mod+A".toggle-overview = [ ];

          "Mod+F".maximize-column = [ ];
          "Mod+Shift+F".fullscreen-window = [ ];
          "Mod+V".toggle-window-floating = [ ];
          "Mod+C".center-column = [ ];
          "Mod+Shift+V".switch-focus-between-floating-and-tiling = [ ];

          "Mod+O".toggle-window-rule-opacity = [ ]; 
          "Mod+Shift+Q".quit = [ ];
          "Mod+Comma".consume-window-into-column = [ ];
          "Mod+Period".expel-window-from-column = [ ];
          
          "Mod+Left".focus-column-left = [ ];
          "Mod+Right".focus-column-right = [ ];
          "Mod+Up".focus-window-up = [ ];
          "Mod+Down".focus-window-down = [ ];

          "Mod+Shift+Left".move-column-left = [ ];
          "Mod+Shift+Right".move-column-right = [ ];
          "Mod+Shift+Up".move-window-up = [ ];
          "Mod+Shift+Down".move-window-down = [ ];
 
          # Bindings to switch to workspaces 0-9.
          "Mod+Alt+Up".focus-workspace-up = [ ];
          "Mod+Alt+Down".focus-workspace-down = [ ];
          "Mod+0".focus-workspace = 10;
          "Mod+1".focus-workspace = 1;
          "Mod+2".focus-workspace = 2;
          "Mod+3".focus-workspace = 3;
          "Mod+4".focus-workspace = 4;
          "Mod+5".focus-workspace = 5;
          "Mod+6".focus-workspace = 6;
          "Mod+7".focus-workspace = 7;
          "Mod+8".focus-workspace = 8;
          "Mod+9".focus-workspace = 9;
        };
      };
    };
  };

}
