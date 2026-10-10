{ self, inputs, ... }: {

  flake.nixosModules.myHardware = { config, pkgs, lib, ... }: {

    # Habilita aceleração gráfica (OpenGL / Vulkan)
    hardware.graphics = {
      enable = true;
      enable32Bit = true;
    };

    # Carrega o driver da NVIDIA no Xserver e Wayland
    services.xserver.videoDrivers = [ "nvidia" ];

  };

}
