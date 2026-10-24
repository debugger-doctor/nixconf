{ inputs, ... }: {

  flake.nixosModules.develop = { pkgs, ... }: {

    programs.tmux = {
      enable = true;
      clock24 = true;
      keyMode = "vi";
    };

    programs.nix-ld.enable = true;

    users.users.doctor.extraGroups = [ "dialout" ];
    
    fonts.packages = [ pkgs.nerd-fonts.fira-code ];
    
    environment.systemPackages = with pkgs; [
      vim
      insomnia

      vscode-fhs
      
      # C / C++ (Compilador, Build, Formatador, Linter, LSP, Debugger e Profiler)
      gcc
      gdb 
      gnumake
      cmake
      ninja
      clang-tools # clangd (LSP), clang-format (formatador), clang-tidy (linter)
      cppcheck    # linter / análise estática
      valgrind    # debugger de memória e profiling

      # Rust (Compilador, Gerenciador, Formatador, Linter, LSP e Debugger)
      rustc
      cargo
      rustfmt
      clippy
      rust-analyzer
      lldb
      cargo-edit
      cargo-watch

      # Go (Compilador, Formatador, Linter, LSP e Debugger)
      go
      gopls
      delve
      golangci-lint
      gofumpt

      # Lua (Interpretador, Gerenciador, Formatador, Linter e LSP)
      lua5_4
      lua54Packages.luarocks
      stylua                  # formatador
      lua-language-server     # LSP
      lua54Packages.luacheck  # linter
      selene                  # linter

      # Erlang (Compilador, Build, Formatador, Linter, LSP e Debugger)
      beamPackages.erlang            # compilador erlc, runtime erl, dialyzer e debugger OTP
      beamPackages.rebar3            # gerenciador de build e dependências
      beamPackages.erlfmt            # formatador de código
      beamPackages.elvis-erlang      # linter de estilo
      erlang-language-platform       # LSP moderno (elp)

      # Elixir (Compilador, Build/Gerenciador, Formatador, LSP e Debugger)
      beamPackages.elixir            # compilador, iex (com dbg/pry), mix e mix format
      beamPackages.hex               # gerenciador de pacotes Hex
      beamPackages.elixir-ls         # LSP e DAP (debugger adapter)
      beamPackages.expert            # LSP moderno (Next LS + Lexical)

      arduino-cli
      avrdude

      nixd # for lsp 
      nil # for lsp
      nixpkgs-fmt # for lsp

      inputs.antigravity-nix.packages."${pkgs.stdenv.hostPlatform.system}".default
      inputs.antigravity-nix.packages."${pkgs.stdenv.hostPlatform.system}".google-antigravity-ide
      inputs.antigravity-nix.packages."${pkgs.stdenv.hostPlatform.system}".google-antigravity-cli
    ];

  };

}
