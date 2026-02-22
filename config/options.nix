{ self, pkgs, ... }:
{
  globalOpts = {
    #line number
    number = true;
    relativenumber = true;

    #enable true color support
    termguicolors = true;

    #enable mouse support
    mouse = "a";

    #search settings
    ignorecase = true;
    smartcase = true;

    #tabs and indentation
    expandtab = true;
    shiftwidth = 4;
    tabstop = 4;
    softtabstop = 4;
    smartindent = true;

    #list
    list = true;
    listchars.__raw = "{ tab = '» ', trail = '·', nbsp = '␣' }";

    #clipboard
    clipboard = "unnamedplus";

    #set encoding
    encoding = "utf-8";
    fileencoding = "utf-8";

    #save undo history
    undofile = true;
    swapfile = true;
    backup = false;
    autoread = true;

    #highlight current line
    cursorline = true;

    #set scrolloff
    scrolloff = 8;
    ruler = true;
  };

  globals.mapleader = " ";

    clipboard = {
    providers = {
      # Wayland 桌面（Hyprland / GNOME Wayland / Sway 等）
      wl-copy.enable = true;

      # X11 桌面（Xorg）
      xclip.enable = true;
    };
  };

  extraConfigLua = ''
local normal = vim.api.nvim_get_hl(0, { name = "Normal" })
local hl_float = vim.api.nvim_get_hl(0, { name = "NormalFloat" })
vim.api.nvim_set_hl(0, "NormalFloat", { fg = hl_float.fg, bg = "NONE" })
vim.api.nvim_set_hl(0, "FloatBorder", { fg = normal.fg, bg = "NONE", bold = true })
vim.api.nvim_set_hl(0, "TreesitterContext", { link = "NormalFloat" })
vim.api.nvim_set_hl(0, "TreesitterContextSeparator", { fg = "#3b4261" })
vim.api.nvim_set_hl(0, "MatchParen", { bold = true, underline = true })

local restore_cursor_group = vim.api.nvim_create_augroup("RestoreCursorPosition", { clear = true })
vim.api.nvim_create_autocmd("BufReadPost", {
  group = restore_cursor_group,
  callback = function(args)
    local mark = vim.api.nvim_buf_get_mark(args.buf, '"')
    local line_count = vim.api.nvim_buf_line_count(args.buf)
    if mark[1] > 0 and mark[1] <= line_count then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})
  '';
}
