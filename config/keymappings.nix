{self, ...}: {
  extraConfigLua = ''
    local function resize_height(delta)
      local n = (vim.v.count1 or 1) * delta
      vim.cmd("resize " .. ((n >= 0) and ("+" .. n) or tostring(n)))
    end
    
    local function resize_width(delta)
      local n = (vim.v.count1 or 1) * delta
      vim.cmd("vertical resize " .. ((n >= 0) and ("+" .. n) or tostring(n)))
    end
  '';
  
  keymaps = [
    {
      mode = [ "n" "i" ];
      key = "<C-s>";
      action = "<cmd>w<cr>";
      options = {
        desc = "Save file";
      };
    }
    {
      mode = "n";
      key = "<leader>q";
      action = "<cmd>q<cr>";
      options = {
        desc = "Quit Neovim";
      };
    }
    {
      mode = "n";
      key = "<leader>ws";
      action = "<cmd>split<cr>";
      options = {
        desc = "Horizontal Split";
      };
    }
    {
      mode = "n";
      key = "<leader>wv";
      action = "<cmd>vsplit<cr>";
      options = {
        desc = "Vertical Split";
      };
    }
    {
      mode = "n";
      key = "<C-h>";
      action = "<C-w>h";
      options = {
        desc = "Move to left window";
      };
    }
    {
      mode = "n";
      key = "<C-j>";
      action = "<C-w>j";
      options = {
        desc = "Move to lower window";
      };
    }
    {
      mode = "n";
      key = "<C-k>";
      action = "<C-w>k";
      options = {
        desc = "Move to upper window";
      };
    }
    {
      mode = "n";
      key = "<C-l>";
      action = "<C-w>l";
      options = {
        desc = "Move to right window";
      };
    }
    {
      mode = "n";
      key = "<C-Up>";
      action.__raw = "function() resize_height(2) end";
      options = {
        silent = true;
        desc = "Increase window height";
      };
    }
    {
      mode = "n";
      key = "<C-Down>";
      action.__raw = "function() resize_height(-2) end";
      options = {
        silent = true;
        desc = "Decrease window height";
      };
    }
    {
      mode = "n";
      key = "<C-Right>";
      action.__raw = "function() resize_width(3) end";
      options = {
        silent = true;
        desc = "Increase window width";
      };
    }
    {
      mode = "n";
      key = "<C-Left>";
      action.__raw = "function() resize_width(-3) end";
      options = {
        silent = true;
        desc = "Decrease window width";
      };
    }
  ];
}