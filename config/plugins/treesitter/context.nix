{
  plugins.treesitter-context = {
    enable = true;
    lazyLoad.settings.events = [ "BufReadPost" "BufNewFile" ];
    
    settings = {
      max_lines = 3; 
      trim_scope = "inner";
      mode = "topline";
      separator = "─";
      min_window_height = 20;
      line_numbers = true;
      zindex = 20;
    };
  };

  keymaps = [
    {
      mode = "n";
      key = "[c";
      action = "<cmd>lua require('treesitter-context').go_to_context()<CR>";
      options = { silent = true; desc = "Jump to context (Upwards)"; };
    }
  ];
}