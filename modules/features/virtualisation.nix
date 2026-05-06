{ self, inputs, ... }: {
  
  flake.nixosModules.myVirtualisation = { config, pkgs, ... }: {
  
    users.users.doctor.extraGroups = [ "libvirtd" "kvm" ];

    # Enable virtualization with QEMU and libvirt.
    virtualisation = {
      libvirtd = {
        enable = true;
        qemu = {
          package = pkgs.qemu_kvm;
          runAsRoot = true;
          swtpm.enable = true;

          verbatimConfig = ''
            namespace = [ "mount" ]
            tpms_user = "libvirt_qemu"
            tpms_group = "libvirt_qemu"
          '';
        };
      };
    };

    security.polkit.enable = true; # Enable polkit for privilege escalation in desktop environments.

    environment.systemPackages = with pkgs; [
      # windows virtualization
      gnome-boxes
      virt-manager
      swtpm
      virtio-win
    ];
  };
}
