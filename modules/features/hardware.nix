{ self, inputs, ... }: {

  flake.nixosModules.myHardware = { config, pkgs, lib, ... }: {

    # Variáveis essenciais para a NVIDIA no Wayland
    environment.sessionVariables = {
      LIBVA_DRIVER_NAME = "nvidia";
      XDG_SESSION_TYPE = "wayland";
      GBM_BACKEND = "nvidia-drm";
      __GLX_VENDOR_LIBRARY_NAME = "nvidia";
      WLR_NO_HARDWARE_CURSORS = "1"; # Corrige o bug do cursor invisível
    };

    # Habilita aceleração gráfica (OpenGL / Vulkan)
    hardware.graphics = {
      enable = true;
      enable32Bit = true;
    };

    # Drivers Oficiais da NVIDIA (Ajustado para a GTX 1660)
    services.xserver.videoDrivers = [ "nvidia" ];
    hardware.nvidia = {
      modesetting.enable = true;
      powerManagement.enable = true;
      powerManagement.finegrained = false;
      open = false; # Drivers proprietários estáveis (melhor para a série 16XX)
      nvidiaSettings = true;
      package = config.boot.kernelPackages.nvidiaPackages.stable;
    };

  };

}
