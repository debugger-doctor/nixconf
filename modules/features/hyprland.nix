{ self, ... }: {

  flake.nixosModules.myHyprland = { pkgs, lib, ... }: {

    programs.hyprland = {
      enable = true;
      withUWSM = true;
      xwayland.enable = true;
    };

    # Configuração moderna em formato Lua (Hyprland 0.56+)
    environment.etc."hypr/hyprland.lua".text = ''
      -------------------------------
      ---- THEME / NOCTALIA COLORS --
      -------------------------------
      -- Carrega dinamicamente a paleta de cores gerada pelo Noctalia Shell
      local colors = {
          active_border = { "rgba(33ccffee)", "rgba(00ff99ee)" },
          inactive_border = "rgba(595959aa)",
          border_locked = "rgba(ff5555aa)",
      }

      local function load_noctalia_colors()
          local path = (os.getenv("HOME") or "/home/doctor") .. "/.config/hypr/noctalia/noctalia-colors.conf"
          local f = io.open(path, "r")
          if not f then return end

          local vars = {}
          for line in f:lines() do
              local k, v = line:match("^%s*%$(%w+)%s*=%s*(.-)%s*$")
              if k and v then
                  vars[k] = v
              end
          end
          f:close()

          if vars.primary and vars.secondary then
              colors.active_border = { vars.primary, vars.secondary }
          elseif vars.primary then
              colors.active_border = { vars.primary }
          end

          if vars.surface then
              colors.inactive_border = vars.surface
          end

          if vars.error then
              colors.border_locked = vars.error
          end
      end

      load_noctalia_colors()

      ------------------
      ---- MONITORS ----
      ------------------
      hl.monitor({
          output   = "",
          mode     = "preferred",
          position = "auto",
          scale    = "auto",
      })

      -------------------------------
      ---- ENVIRONMENT VARIABLES ----
      -------------------------------
      hl.env("LIBVA_DRIVER_NAME", "nvidia")
      hl.env("XDG_SESSION_TYPE", "wayland")
      hl.env("GBM_BACKEND", "nvidia-drm")
      hl.env("__GLX_VENDOR_LIBRARY_NAME", "nvidia")
      hl.env("NVD_BACKEND", "direct")
      hl.env("XCURSOR_SIZE", "24")
      hl.env("HYPRCURSOR_SIZE", "24")

      -----------------------
      ---- LOOK AND FEEL ----
      -----------------------
      hl.config({
          general = {
              gaps_in = 5,
              gaps_out = 20,
              border_size = 2,
              col = {
                  active_border = { colors = colors.active_border, angle = 45 },
                  inactive_border = colors.inactive_border,
              },
              resize_on_border = false,
              allow_tearing = false,
              layout = "dwindle",
          },

          group = {
              col = {
                  border_active = colors.active_border[1] or colors.active_border,
                  border_inactive = colors.inactive_border,
                  border_locked_active = colors.border_locked,
                  border_locked_inactive = colors.inactive_border,
              },
          },

          decoration = {
              rounding = 10,
              rounding_power = 2,
              active_opacity = 1.0,
              inactive_opacity = 1.0,
              shadow = {
                  enabled = true,
                  range = 4,
                  render_power = 3,
                  color = 0xee1a1a1a,
              },
              blur = {
                  enabled = true,
                  size = 3,
                  passes = 1,
                  vibrancy = 0.1696,
              },
          },

          animations = {
              enabled = true,
          },

          misc = {
              force_default_wallpaper = 0,
              disable_hyprland_logo = true,
          },

          cursor = {
              no_hardware_cursors = true,
          },

          input = {
              kb_layout = "br",
              follow_mouse = 1,
              touchpad = {
                  natural_scroll = false,
              },
          },

          dwindle = {
              preserve_split = true,
          },
      })

      ----------------------
      ---- WINDOW RULES ----
      ----------------------
      -- Impede que aplicativos solicitem modo maximizado automaticamente ao abrir
      hl.window_rule({
          name = "suppress-maximize-events",
          match = { class = ".*" },
          suppress_event = "maximize",
      })

      -------------------
      ---- AUTOSTART ----
      -------------------
      local terminal = "kitty"
      local noctalia = "${lib.getExe self.packages.${pkgs.stdenv.hostPlatform.system}.myNoctalia}"

      hl.on("hyprland.start", function ()
          hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
          hl.exec_cmd("systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
          hl.exec_cmd(noctalia)
      end)

      ---------------------
      ---- KEYBINDINGS ----
      ---------------------
      local mainMod = "SUPER"

      -- Janelas e Terminal
      hl.bind(mainMod .. " + Return", hl.dsp.exec_cmd(terminal))
      hl.bind(mainMod .. " + Q", hl.dsp.window.kill())
      -- Maximizar (largura total da área de trabalho, mantendo barra e margens visíveis)
      hl.bind(mainMod .. " + M", hl.dsp.window.fullscreen({ mode = "maximized", action = "toggle" }))
      hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen({ mode = "maximized", action = "toggle" }))
      -- Tela cheia verdadeira (ocultando barras e margens)
      hl.bind(mainMod .. " + SHIFT + F", hl.dsp.window.fullscreen({ mode = "fullscreen", action = "toggle" }))
      hl.bind(mainMod .. " + V", hl.dsp.window.float({ action = "toggle" }))

      -- Atalhos do Noctalia Shell
      hl.bind(mainMod .. " + D", hl.dsp.exec_cmd(noctalia .. " ipc call launcher toggle"))
      hl.bind(mainMod .. " + S", hl.dsp.exec_cmd(noctalia .. " ipc call settings toggle"))
      hl.bind(mainMod .. " + Escape", hl.dsp.exec_cmd(noctalia .. " ipc call lockScreen lock"))
      hl.bind(mainMod .. " + ALT + L", hl.dsp.exec_cmd(noctalia .. " ipc call lockScreen lock"))
      hl.bind(mainMod .. " + W", hl.dsp.exec_cmd(noctalia .. " ipc call wallpaper toggle"))
      hl.bind(mainMod .. " + A", hl.dsp.exec_cmd(noctalia .. " ipc call launcher windows"))

      -- Movimentação de Foco (Setas e Vim Keys HJKL)
      hl.bind(mainMod .. " + Left",  hl.dsp.focus({ direction = "left" }))
      hl.bind(mainMod .. " + Right", hl.dsp.focus({ direction = "right" }))
      hl.bind(mainMod .. " + Up",    hl.dsp.focus({ direction = "up" }))
      hl.bind(mainMod .. " + Down",  hl.dsp.focus({ direction = "down" }))
      hl.bind(mainMod .. " + H",     hl.dsp.focus({ direction = "left" }))
      hl.bind(mainMod .. " + L",     hl.dsp.focus({ direction = "right" }))
      hl.bind(mainMod .. " + K",     hl.dsp.focus({ direction = "up" }))
      hl.bind(mainMod .. " + J",     hl.dsp.focus({ direction = "down" }))

      -- Troca de Lugar de Janelas / Swap (SUPER + SHIFT + Setas / HJKL)
      hl.bind(mainMod .. " + SHIFT + Left",  hl.dsp.window.move({ direction = "left" }))
      hl.bind(mainMod .. " + SHIFT + Right", hl.dsp.window.move({ direction = "right" }))
      hl.bind(mainMod .. " + SHIFT + Up",    hl.dsp.window.move({ direction = "up" }))
      hl.bind(mainMod .. " + SHIFT + Down",  hl.dsp.window.move({ direction = "down" }))
      hl.bind(mainMod .. " + SHIFT + H",     hl.dsp.window.move({ direction = "left" }))
      hl.bind(mainMod .. " + SHIFT + L",     hl.dsp.window.move({ direction = "right" }))
      hl.bind(mainMod .. " + SHIFT + K",     hl.dsp.window.move({ direction = "up" }))
      hl.bind(mainMod .. " + SHIFT + J",     hl.dsp.window.move({ direction = "down" }))

      -- Arrastar e Redimensionar Janelas com o Mouse
      hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
      hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

      -- Navegação entre Workspaces relativos (+1 e -1)
      hl.bind(mainMod .. " + bracketleft",  hl.dsp.focus({ workspace = "e-1" }))
      hl.bind(mainMod .. " + bracketright", hl.dsp.focus({ workspace = "e+1" }))
      hl.bind(mainMod .. " + Page_Up",      hl.dsp.focus({ workspace = "e-1" }))
      hl.bind(mainMod .. " + Page_Down",    hl.dsp.focus({ workspace = "e+1" }))
      hl.bind(mainMod .. " + mouse_down",   hl.dsp.focus({ workspace = "e+1" }))
      hl.bind(mainMod .. " + mouse_up",     hl.dsp.focus({ workspace = "e-1" }))

      -- Mover Janela Ativa para Workspace relativo (+1 e -1)
      hl.bind(mainMod .. " + SHIFT + bracketleft",  hl.dsp.window.move({ workspace = "e-1" }))
      hl.bind(mainMod .. " + SHIFT + bracketright", hl.dsp.window.move({ workspace = "e+1" }))
      hl.bind(mainMod .. " + SHIFT + Page_Up",      hl.dsp.window.move({ workspace = "e-1" }))
      hl.bind(mainMod .. " + SHIFT + Page_Down",    hl.dsp.window.move({ workspace = "e+1" }))
      hl.bind(mainMod .. " + SHIFT + mouse_down",   hl.dsp.window.move({ workspace = "e+1" }))
      hl.bind(mainMod .. " + SHIFT + mouse_up",     hl.dsp.window.move({ workspace = "e-1" }))

      -- Workspaces 1 a 9
      for i = 1, 9 do
          hl.bind(mainMod .. " + " .. i,                hl.dsp.focus({ workspace = i }))
          hl.bind(mainMod .. " + SHIFT + " .. i,        hl.dsp.window.move({ workspace = i }))
          hl.bind(mainMod .. " + CTRL + " .. i,         hl.dsp.window.move({ workspace = i, silent = true }))
      end
    '';

    systemd.user.tmpfiles.rules = [
      "L+ %h/.config/hypr/hyprland.lua - - - - /etc/hypr/hyprland.lua"
    ];

    # Agente de autenticação Polkit para sessões gráficas Wayland
    systemd.user.services.polkit-gnome-authentication-agent-1 = {
      description = "polkit-gnome-authentication-agent-1";
      wantedBy = [ "graphical-session.target" ];
      wants = [ "graphical-session.target" ];
      after = [ "graphical-session.target" ];
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
      };
    };

    environment.systemPackages = with pkgs; [
      wl-clipboard  
      polkit_gnome
      pavucontrol
      nvtopPackages.nvidia 
    ];

  };

}
