{
  plugins.multicursors = {
    enable = true;
    lazyLoad.settings = {
      keys = [
        {
          __unkeyed-1 = "<C-d>";
          __unkeyed-2 = "<cmd>MCstart<cr>";
          mode = [ "n" "v" ];
          desc = "Start MultiCursor";
        }
      ];
    };
    settings = {
      hint_config = {
        float_opts = {
          border = "rounded";
          style = "minimal";
        };
        position = "bottom-right";
      };

      generate_hints = {
        normal = true;
        insert = true;
        extend = true;
        config = {
          column_count = 1;      
          max_hint_length = 25;
        };
      };
    };
  };

  highlight = {
    MultiCursor = {
      bg = "#3b4252";
      fg = "#81a1c1";
      underline = true;
    };
    MultiCursorMain = {
      bg = "#4c566a";
      fg = "#eceff4";
      bold = true;
    };
  };
}