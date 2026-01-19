{pkgs, ...}:

{
  extraPlugins = with pkgs.vimPlugins; [
    heirline-nvim
  ];

  extraConfigLua = ''
    local heirline = require('heirline')
    local conditions = require('heirline.conditions')
    local utils = require('heirline.utils')

    local colors = require('onedark.colors')

    local function truncate(s, n)
      if not s or s == "" or #s <= n then
        return s or ""
      end
      return s:sub(1, math.max(n - 3, 1)) .. "…"
    end

    local Space = { provider = " " }
    local Align = { provider = "%=" }

    local Mode = {
      init = function(self)
        self.mode = vim.fn.mode(1)
      end,
      static = {
        mode_map = {
          n = { "󰰆", "NORMAL", colors.blue },
          i = { "󰰅", "INSERT", colors.green },
          v = { "󰰈", "VISUAL", colors.mauve },
          V = { "󰰉", "V-LINE", colors.mauve },
          ["\22"] = { "󰰊", "V-BLOCK", colors.mauve },
          c = { "󰞷", "CMD", colors.peach },
          t = { "󰓫", "TERM", colors.yellow },
          R = { "󰛔", "REPL", colors.red },
        },
      },
      provider = function(self)
        local m = self.mode_map[self.mode] or { "󰜅", self.mode, colors.surface1 }
        return ("  %s %s  "):format(m[1], m[2])
      end,
      hl = function(self)
        local m = self.mode_map[self.mode] or { "", "", colors.surface1 }
        return { fg = colors.black, bg = m[3], bold = true }
      end,
      update = { "ModeChanged", pattern = "*:*" },
    }

    local FileName = {
      provider = function()
        local filename = vim.fn.expand("%:t")
        if filename == "" then return "[No Name]" end
        return truncate(filename, 30)
      end,
      hl = { fg = colors.text },
    }

    local Git = {
      condition = conditions.is_git_repo,
      init = function(self)
        self.status_dict = vim.b.gitsigns_status_dict
        self.has_changes = self.status_dict.added ~= 0 or 
                          self.status_dict.removed ~= 0 or 
                          self.status_dict.changed ~= 0
      end,
      {
        provider = function(self)
          return " 󰘬 " .. self.status_dict.head
        end,
        hl = { fg = colors.lavender, bold = true },
      },
      {
        condition = function(self)
          return self.has_changes
        end,
        provider = function(self)
          local count = self.status_dict
          return string.format(" +%s ~%s -%s", count.added or 0, count.changed or 0, count.removed or 0)
        end,
        hl = { fg = colors.subtext1 },
      },
      update = { "User", pattern = "GitSignsUpdate" },
    }

    local LSP = {
      condition = conditions.lsp_attached,
      update = { "LspAttach", "LspDetach" },
      provider = function()
        local names = {}
        for _, server in pairs(vim.lsp.get_clients({ bufnr = 0 })) do
          if server.name ~= "null-ls" and server.name ~= "copilot" then
            table.insert(names, server.name)
          end
        end
        return " 󰒋 " .. table.concat(names, "·")
      end,
      hl = { fg = colors.sapphire, bold = true },
    }

    local Position = {
      provider = function()
        local line = vim.fn.line(".")
        local col = vim.fn.col(".")
        local total = vim.fn.line("$")
        local percent = math.floor(line / total * 100)
        return (" 󰍎 %d:%d  %d%% "):format(line, col, percent)
      end,
      hl = { fg = colors.blue, bold = true },
    }

    local ScrollBar = {
      static = {
        sbar = { "▁", "▂", "▃", "▄", "▅", "▆", "▇", "█" }
      },
      provider = function(self)
        local curr_line = vim.api.nvim_win_get_cursor(0)[1]
        local lines = vim.api.nvim_buf_line_count(0)
        local i = math.floor((curr_line - 1) / lines * #self.sbar) + 1
        return " " .. self.sbar[i]
      end,
      hl = { fg = colors.peach },
    }

    local Navic = {
        condition = function() return require("nvim-navic").is_available() end,
        static = {
            type_hl = {
                File = "Directory",
                Module = "@include",
                Namespace = "@namespace",
                Package = "@include",
                Class = "@structure",
                Method = "@method",
                Property = "@property",
                Field = "@field",
                Constructor = "@constructor",
                Enum = "@field",
                Interface = "@type",
                Function = "@function",
                Variable = "@variable",
                Constant = "@constant",
                String = "@string",
                Number = "@number",
                Boolean = "@boolean",
                Array = "@field",
                Object = "@type",
                Key = "@keyword",
                Null = "@comment",
                EnumMember = "@field",
                Struct = "@structure",
                Event = "@keyword",
                Operator = "@operator",
                TypeParameter = "@type",
            },
            enc = function(line, col, winnr)
                return bit.bor(bit.lshift(line, 16), bit.lshift(col, 6), winnr)
            end,
            dec = function(c)
                local line = bit.rshift(c, 16)
                local col = bit.band(bit.rshift(c, 6), 1023)
                local winnr = bit.band(c, 63)
                return line, col, winnr
            end
        },
        init = function(self)
            local data = require("nvim-navic").get_data() or {}
            local children = {}

            local max_levels = 3
            if #data > max_levels then
              table.insert(children, {
                provider = ".. > ",
                hl = { fg = colors.grey or "gray" },
              })
              local sliced_data = {}
              for i = #data - max_levels + 1, #data do
                table.insert(sliced_data, data[i])
              end
              data = sliced_data
            end

            for i, d in ipairs(data) do
              local pos = self.enc(d.scope.start.line, d.scope.start.character, self.winnr)
              local child = {
                {
                  provider = d.icon,
                  hl = self.type_hl[d.type],
                },
                {
                  provider = truncate(d.name:gsub("%%", "%%%%"):gsub("%s*->%s*", ""), 12),
                  on_click = {
                    minwid = pos,
                    callback = function(_, minwid)
                      local line, col, winnr = self.dec(minwid)
                      vim.api.nvim_win_set_cursor(vim.fn.win_getid(winnr), {line, col})
                    end,
                    name = "heirline_navic",
                  },
                },
              }
              if #data > 1 and i < #data then
                table.insert(child, {
                  provider = " > ",
                  hl = { fg = colors.grey or "gray" },
                })
              end
              table.insert(children, child)
            end
            self.child = self:new(children, 1)
        end,
        provider = function(self)
            return self.child:eval()
        end,
          update = { 'CursorMoved', 'LspAttach', 'BufEnter' }
    }

    local StatusLine = {
      Mode,
      Space,
      FileName,
      Space,
      Git,
      Space,
      Navic,
      Align,
      LSP,
      Space,
      Position,
      ScrollBar,
    }

    heirline.setup({
      statusline = StatusLine,
      opts = {
        colors = colors,
      },
    })
  '';
}