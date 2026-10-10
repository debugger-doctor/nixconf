{...}: {

  flake.nixosModules.develop = { pkgs, ... }: {

    programs.tmux = {
      enable = true;
      clock24 = true;
      keyMode = "vi";
    };

    programs.nix-ld.enable = true;

    users.users.doctor.extraGroups = [ "dialout" ];
    
    
    environment.systemPackages = with pkgs; [
      vim
      insomnia

      vscode-fhs
      
      gcc
      gdb 
      gnumake

      arduino-cli
      avrdude

      nerd-fonts.fira-code

      nixd # for lsp 
      nil # for lsp
      nixpkgs-fmt # for lsp
    ];

  };

}