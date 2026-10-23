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
      
      # C / C++
      gcc
      gdb 
      gnumake

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

      # Lua
      lua5_4
      lua54Packages.luarocks

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
