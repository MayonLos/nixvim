{ pkgs, ... }:

{
  plugins.copilot-lua = {
    enable = true;
    lazyLoad.settings.events = "InsertEnter";
    settings = {
      copilot_node_command = "${pkgs.nodejs}/bin/node";
      suggestion = {
        enabled = true;
        auto_trigger = true;
        hide_during_completion = true;
        debounce = 75;
        keymap.accept = false;
      };
    };
  };

  extraConfigLua = ''
    vim.keymap.set('i', '<Tab>', function()
      if require("copilot.suggestion").is_visible() then
        require("copilot.suggestion").accept()
      else
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Tab>", true, false, true), "n", false)
      end
    end)
  '';
}