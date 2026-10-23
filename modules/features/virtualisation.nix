{ ... }: {
  
  flake.nixosModules.myVirtualisation = { pkgs, config, ... }: {

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
        # Necessário para que os containers se comuniquem entre si usando nomes de domínio (ex: kibana chamando http://elasticsearch:9200)
        defaultNetwork.settings.dns_enabled = true;
      };
    };

    hardware.nvidia-container-toolkit.enable = true;

    security.polkit.enable = true; # Enable polkit for privilege escalation in desktop environments.
  };
}
