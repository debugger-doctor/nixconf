{ inputs, ... }: {

  flake.nixosModules.myNeovim = { pkgs, ... }: {

    # 1. IMPORTANTE: Importamos o módulo do Nixvim para dentro do escopo do NixOS aqui
    imports = [
      inputs.nixvim.nixosModules.nixvim
    ];

    # Configuração declarativa do Neovim via Nixvim
    programs.nixvim = {
      enable = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;

      # Configurações básicas do Vim (Options)
      opts = {
        number = true;         # Linhas numeradas
        relativenumber = true; # Números relativos para pular linhas rápido
        shiftwidth = 2;        # Indentação de 2 espaços
        tabstop = 2;
        expandtab = true;      # Converte tab em espaços
        smartindent = true;
        termguicolors = true;  # Suporte a cores modernas do terminal
      };

      # Esquema de cores (Theme)
      colorschemes.catppuccin = {
        enable = true;
        settings.flavour = "mocha"; # Tema escuro confortável
      };

      # Habilitando Plugins Essenciais
      plugins = {
        # Linha de status bonita no rodapé
        lualine.enable = true; 

        # Árvore de arquivos lateral (Aperte Ctrl+n para abrir/fechar, configurado em keymaps abaixo)
        neo-tree.enable = true;

        # Realce de sintaxe ultra-avançado (Treesitter)
        treesitter = {
          enable = true;
          nixGrammars = true; # Garante que baixa os parsers via Nix
        };

        # Menu de buscas globais (Telescope) - Necessita do ripgrep/fd instalados no sistema
        telescope = {
          enable = true;
          keymaps = {
            "<leader>ff" = "find_files";
            "<leader>fg" = "live_grep";
          };
        };

        # Autocompletar (nvim-cmp) enquanto você digita
        cmp = {
          enable = true;
          settings = {
            autoEnableSources = true;
            sources = [
              { name = "nvim_lsp"; }
              { name = "path"; }
              { name = "buffer"; }
            ];
            mapping = {
              "<CR>" = "cmp.mapping.confirm({ select = true })"; # Enter aceita a sugestão
              "<Tab>" = "cmp.mapping.select_next_item()";        # Tab navega para baixo
              "<S-Tab>" = "cmp.mapping.select_prev_item()";    # Shift+Tab navega para cima
            };
          };
        };

        # Gerenciador de LSP (Language Servers)
        lsp = {
          enable = true;
          servers = {
            # Ativa o LSP de C/C++ (ele vai usar o clangd que está no seu systemPackages)
            clangd.enable = true;
            
            # Ativa o LSP do Nix
            nixd.enable = true;
          };
          keymaps.lspBuf = {
            "gd" = "definition";      # 'gd' vai para a definição da função/variável
            "K" = "hover";            # 'K' mostra a documentação/tipo no cursor
            "<leader>ca" = "code_action"; # Ações de correção rápida de código
          };
        };
      };

      # Atalhos customizados (Keymaps globais)
      keymaps = [
        {
          mode = "n";
          key = "<C-n>";
          action = "<cmd>Neotree toggle<CR>";
          options.desc = "Toggle Neo-tree";
        }
      ];
    };

    environment.systemPackages = with pkgs; [
      cmake        
      clang-tools  # O Nixvim vai usar o 'clangd' contido aqui de forma transparente

      # Utilitários de sistema para o Neovim
      xclip        # Suporte a clipboard se usar X11
      wl-clipboard # Suporte a clipboard se usar Wayland
      ripgrep      # Busca ultra-rápida de arquivos dentro do Neovim
      fd           # Alternativa rápida ao 'find' usada por plugins do Neovim

    ];
  };
}
