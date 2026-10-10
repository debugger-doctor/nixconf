{ ... }: {
  
  flake.nixosModules.myVirtualisation = { pkgs, config, ... }: {

    # Variáveis essenciais para a NVIDIA não quebrar o Wayland/Hyprland
    environment.sessionVariables = {
      LIBVA_DRIVER_NAME = "nvidia";
      XDG_SESSION_TYPE = "wayland";
      GBM_BACKEND = "nvidia-drm";
      __GLX_VENDOR_LIBRARY_NAME = "nvidia";
      WLR_NO_HARDWARE_CURSORS = "1"; # Corrige o bug do cursor invisível
    };

    # 3. Drivers Oficiais da NVIDIA (Ajustado para a GTX 1660)
    hardware.graphics.enable = true;
    services.xserver.videoDrivers = [ "nvidia" ];
    hardware.nvidia = {
      modesetting.enable = true;
      powerManagement.enable = true; # Mude para true se tiver problemas de suspensão
      powerManagement.finegrained = false;
      open = false; # Drivers proprietários estáveis (melhor para a série 16XX)
      nvidiaSettings = true;
      package = config.boot.kernelPackages.nvidiaPackages.stable;
    };

    environment.systemPackages = with pkgs; [
      # windows virtualization
      gnome-boxes
      virt-manager
      swtpm
      virtio-win

      podman-compose
    ];

    users.users.doctor.extraGroups = [ "libvirtd" "kvm" ];

    # Enable virtualization with QEMU and libvirt.
    virtualisation = {
      libvirtd = {
        enable = true;
        qemu = {
          package = pkgs.qemu_kvm;
          runAsRoot = true;
          swtpm.enable = true;

          # For windowns 11 setup
          # verbatimConfig = ''
          #   namespaces = [ "mount" ]
          #   tpms_user = "libvirt-qemu"
          #   tpms_group = "libvirt-qemu"
          # '';
        };
      };

      podman = {
        enable = true;
        # Cria um link simbólico para que o comando 'docker' aponte para o 'podman'
        dockerCompat = true;
        enableNvidia = true;
        # Necessário para que os containers se comuniquem entre si usando nomes de domínio (ex: kibana chamando http://elasticsearch:9200)
        defaultNetwork.settings.dns_enabled = true;
      };
    };

    hardware.nvidia-container-toolkit.enable = true;

    security.polkit.enable = true; # Enable polkit for privilege escalation in desktop environments.
  };
}
