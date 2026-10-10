{...}: {

  flake.nixosModules.gnome = { pkgs, ... }: {

    environment.systemPackages = with pkgs; [
        gnomeExtensions.clipboard-history
        gnomeExtensions.desktop-cube
        gnomeExtensions.coverflow-alt-tab
        gnomeExtensions.blur-my-shell
    ];

  };

}