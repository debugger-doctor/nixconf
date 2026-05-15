{ self, inputs, ... }: {
  
  flake.nixosModules.myCustomShell = { config, pkgs, lib, ... }: {

    users.users.doctor.shell = pkgs.zsh;

    environment.systemPackages = with pkgs; [
      starship
      nerd-fonts.fira-code
    ];

    programs.zsh = { # Enable Zsh as the default shell.
      enable = true;
      enableCompletion = true;
      autosuggestions.enable = true;
      syntaxHighlighting.enable = true;
      
      promptInit = ""; # Force Zsh to use the Starship prompt instead of the default one.

      # ohMyZsh = {
      #   enable = true;
      #   theme = "robbyrussell";
      #   puglins = [ "git" ];
      # };
    };

    programs.starship = { # Enable the Starship prompt.
      enable = true;
      settings = {
        add_newline = false;
        character = {
          success_symbol = "[➜](bold green)";
          error_symbol = "[➜](bold red)";
        };
      };
    };

    # services.ttyd = {
    #   enable = true;
    #   writeable = true; # Permite digitar comandos (se false, é apenas visualização)
    #   port = 7681;      # Porta padrão
    #   interface = "0.0.0.0"; # "localhost" para apenas acesso local ou "0.0.0.0" para rede
    # };

  };
}