{ self, inputs, ... }: {
  
  flake.nixosModules.myWf-Recorder = { pkgs, lib, ... }: {
    
    environment.systemPackages = with pkgs; [
      wf-recorder
      slurp
      # libnotify
    ];

  };
    
}