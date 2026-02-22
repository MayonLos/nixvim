{ ... }:

{
  plugins.sidekick = {
    enable = true;
    settings = {
      cli = {
        mux = {
          backend = "tmux";
          enabled = true;
        };
        win.keys = {
          # Fast way to jump from sidekick terminal back to editor window.
          back_to_editor = {
            __unkeyed-1 = "<c-o>";
            __unkeyed-2 = "blur";
            mode = "nt";
            desc = "Sidekick Back To Editor";
          };

          # Extra navigation keys that work in terminal/normal mode.
          nav_left_alt = {
            __unkeyed-1 = "<a-h>";
            __unkeyed-2 = "nav_left";
            mode = "nt";
            expr = true;
            desc = "Sidekick Navigate Left";
          };
          nav_down_alt = {
            __unkeyed-1 = "<a-j>";
            __unkeyed-2 = "nav_down";
            mode = "nt";
            expr = true;
            desc = "Sidekick Navigate Down";
          };
          nav_up_alt = {
            __unkeyed-1 = "<a-k>";
            __unkeyed-2 = "nav_up";
            mode = "nt";
            expr = true;
            desc = "Sidekick Navigate Up";
          };
          nav_right_alt = {
            __unkeyed-1 = "<a-l>";
            __unkeyed-2 = "nav_right";
            mode = "nt";
            expr = true;
            desc = "Sidekick Navigate Right";
          };
        };
        tools = {
          claude = {
            cmd = [ "claude" ];
          };
          codex = {
            cmd = [
              "codex"
              "--search"
            ];
          };
          copilot = {
            cmd = [
              "copilot"
              "--banner"
            ];
          };
        };
      };
    };

    luaConfig.post = ''
      local config = require("sidekick.config")
      config.cli.tools = {
        claude = config.cli.tools.claude,
        codex = config.cli.tools.codex,
        copilot = config.cli.tools.copilot,
      }
    '';
  };

  keymaps = [
    {
      mode = "n";
      key = "<leader>aa";
      action = "<cmd>Sidekick cli toggle<cr>";
      options.desc = "Sidekick CLI Toggle";
    }
    {
      mode = "n";
      key = "<leader>as";
      action.__raw = ''
        function()
          local cli = require("sidekick.cli")
          vim.ui.select({ "codex", "claude", "copilot" }, { prompt = "Sidekick Tool" }, function(choice)
            if choice then
              cli.toggle({ name = choice, focus = true })
            end
          end)
        end
      '';
      options.desc = "Sidekick CLI Select (3 Tools)";
    }
    {
      mode = "n";
      key = "<leader>ap";
      action = "<cmd>Sidekick cli prompt<cr>";
      options.desc = "Sidekick CLI Prompt";
    }
    {
      mode = "n";
      key = "<leader>ad";
      action = "<cmd>Sidekick cli close<cr>";
      options.desc = "Sidekick CLI Close";
    }
    {
      mode = "n";
      key = "<leader>af";
      action.__raw = "function() require('sidekick.cli').send({ msg = '{file}', name = 'codex' }) end";
      options.desc = "Sidekick Send File";
    }
    {
      mode = [
        "n"
        "x"
      ];
      key = "<leader>at";
      action.__raw = "function() require('sidekick.cli').send({ msg = '{this}', name = 'codex' }) end";
      options.desc = "Sidekick Send This";
    }
    {
      mode = "x";
      key = "<leader>av";
      action.__raw = "function() require('sidekick.cli').send({ msg = '{selection}', name = 'codex' }) end";
      options.desc = "Sidekick Send Selection";
    }
    {
      mode = "n";
      key = "<leader>au";
      action = "<cmd>Sidekick nes update<cr>";
      options.desc = "Sidekick NES Update";
    }
    {
      mode = "n";
      key = "<leader>aj";
      action.__raw = "function() require('sidekick').nes_jump_or_apply() end";
      options.desc = "Sidekick NES Jump/Apply";
    }
  ];
}
