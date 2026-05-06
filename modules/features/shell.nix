{ self, inputs, ... }: {
  
  flake.nixosModules.myCustomShell = { config, pkgs, lib, ... }: {

    users.users.doctor.shell = pkgs.zsh;

    environment.systemPackages = with pkgs; [
      starship
    ];

    programs.zsh = { # Enable Zsh as the default shell.
      enable = true;
      enableCompletion = true;
      autosuggestions.enable = true;
      syntaxHighlighting.enable = true;
      
      # Garante que o Zsh use o Starship
      promptInit = ""; 

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
  };
}