{
  plugins.dressing = {
    enable = true;
    settings = {
      input = {
        enabled = true;
        border = "rounded";
        start_in_insert = true;
        relative = "cursor";
        mappings = {
          n = {
            "<Esc>" = "Close";
            "<CR>" = "Confirm";
          };
          i = {
            "<C-c>" = "Close";
            "<CR>" = "Confirm";
          };
        };
      };
      select = {
        enabled = true;
        fzf = {
          window = {
            width = 0.5;
            height = 0.4;
          };
        };
      };
    };
  };
}
