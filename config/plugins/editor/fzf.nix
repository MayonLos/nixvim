{
  plugins.fzf-lua = {
    enable = true;
    lazyLoad.settings = {
      cmd = "FzfLua";
      keys = [
        { __unkeyed-1 = "<leader>ff"; __unkeyed-2 = "<cmd>FzfLua files<cr>"; desc = "Find Files"; }
        { __unkeyed-1 = "<leader>fg"; __unkeyed-2 = "<cmd>FzfLua live_grep<cr>"; desc = "Live Grep"; }
        { __unkeyed-1 = "<leader>fb"; __unkeyed-2 = "<cmd>FzfLua buffers<cr>"; desc = "Buffers"; }
        { __unkeyed-1 = "<leader>fr"; __unkeyed-2 = "<cmd>FzfLua oldfiles<cr>"; desc = "Recent Files"; }
        { __unkeyed-1 = "<leader>fh"; __unkeyed-2 = "<cmd>FzfLua helptags<cr>"; desc = "Help"; }
        { __unkeyed-1 = "<leader>f."; __unkeyed-2 = "<cmd>FzfLua blines<cr>"; desc = "Buffer Lines"; }
        { __unkeyed-1 = "<leader>fs"; __unkeyed-2.__raw = "function() _G.select_onedark_style() end"; desc = "Select OneDark Style"; }
      ];
    };
    settings = {
      winopts = {
        border = "rounded";
        hls = {
          normal         = "NormalFloat"; 
          border         = "FloatBorder"; 
          title          = "FloatTitle";  
          preview_normal = "NormalFloat";
          preview_border = "FloatBorder";
        };
      };
      file_icon_padding = " ";
      files = {
        prompt = "Files❯ ";
        file_icons = true;
        git_icons = true;
      };
      previewers = {
        bat = {
          cmd = "bat";
          args = "--style=numbers,changes --color always";
        };
      };
    };
  };

  extraConfigLua = ''
    -- OneDark Dynamic Style Switcher
    local onedark = require("onedark")
    local style_file = vim.fn.stdpath("data") .. "/onedark-style"
    local STYLES = { "dark", "darker", "cool", "deep", "warm", "warmer", "light" }

    -- Read and apply saved style from disk
    local function apply_saved_style()
      local file = io.open(style_file, "r")
      if not file then return end
      
      local style = file:read("*line")
      file:close()
      
      if style and vim.tbl_contains(STYLES, style) then
        onedark.setup({ style = style })
        onedark.load()
      end
    end

    -- Interactive style selector with fzf-lua
    _G.select_onedark_style = function()
      local ok, fzf = pcall(require, "fzf-lua")
      if not ok then 
        vim.notify("fzf-lua is required for style selection", vim.log.levels.WARN)
        return 
      end

      fzf.fzf_exec(STYLES, {
        prompt = "OneDark Style ❯ ",
        actions = {
          ["default"] = function(selected)
            if not selected or #selected == 0 then return end
            
            local new_style = selected[1]
            
            -- Persist to disk
            local file = io.open(style_file, "w")
            if file then
              file:write(new_style)
              file:close()
            else
              vim.notify("Failed to save style preference", vim.log.levels.ERROR)
              return
            end
            
            -- Apply immediately without restart
            onedark.setup({ style = new_style })
            onedark.load()
            
            vim.notify(
              string.format("Applied '%s' style", new_style), 
              vim.log.levels.INFO
            )
          end,
        },
      })
    end

    -- Auto-apply saved style on startup
    vim.schedule(apply_saved_style)
  '';
}