{ ... }: {
  
  flake.nixosModules.myCustomShell = { pkgs, ... }: {

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
      
      interactiveShellInit = ''
        # Configura o cursor como barra vertical (beam) em todos os terminais (GNOME Console, Ptyxis, etc.)
        _set_cursor_beam() {
          printf '\e[5 q'
        }
        autoload -Uz add-zsh-hook
        add-zsh-hook precmd _set_cursor_beam
        zle -N zle-line-init _set_cursor_beam
      '';

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