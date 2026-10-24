{...}: {

  flake.nixosModules.gnome = { pkgs, ... }: {

    # Habilita o daemon do GNOME Remote Desktop
    services.gnome.gnome-remote-desktop.enable = true;

    # Pacotes para acesso remoto do GNOME (servidor RDP e clientes) e extensões
    environment.systemPackages = with pkgs; [
      gnome-remote-desktop
      gnome-connections
      remmina
      gnomeExtensions.clipboard-history
      gnomeExtensions.desktop-cube
      gnomeExtensions.coverflow-alt-tab
      gnomeExtensions.blur-my-shell
    ];

    # Libera a porta padrão de RDP (3389) no firewall
    networking.firewall = {
      allowedTCPPorts = [ 3389 ];
      allowedUDPPorts = [ 3389 ];
    };

    # Habilita os serviços de sistema no graphical.target para que o systemd
    # reporte o estado como "enabled" (em vez de "linked"), fazendo o
    # GNOME Control Center (Configurações -> Sistema) exibir o item de "Área de Trabalho Remota".
    systemd.services.gnome-remote-desktop = {
      wantedBy = [ "graphical.target" ];
    };

    systemd.services.gnome-remote-desktop-configuration = {
      wantedBy = [ "graphical.target" ];
    };

  };

}
