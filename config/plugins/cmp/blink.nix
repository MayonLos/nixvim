{
  plugins.blink-cmp = {
    enable = true;
    settings = {
      keymap = {
        preset = "enter";
        "<C-space>" = [
          "show"
          "show_documentation"
          "hide_documentation"
        ];
        "<C-e>" = [
          "cancel"
          "fallback"
        ];
        "<Up>" = [
          "select_prev"
          "fallback"
        ];
        "<Down>" = [
          "select_next"
          "fallback"
        ];
        "<C-b>" = [
          "scroll_documentation_up"
          "fallback"
        ];
        "<C-f>" = [
          "scroll_documentation_down"
          "fallback"
        ];
        "<Tab>" = [
          "select_next"
          "fallback"
        ];
        "<S-Tab>" = [
          "select_prev"
          "fallback"
        ];
        "<C-k>" = [
          "show_signature"
          "hide_signature"
          "fallback"
        ];
      };
      completion = {
        menu = {
          border = "none";
          draw = {
            gap = 1;
            treesitter = [ "lsp" ];
            columns = [
              {
                __unkeyed-1 = "label";
              }
              {
                __unkeyed-1 = "kind_icon";
                __unkeyed-2 = "kind";
                gap = 1;
              }
              { __unkeyed-1 = "source_name"; }
            ];
          };
        };
        trigger = {
          show_in_snippet = false;
        };
        documentation = {
          auto_show = true;
          window = {
            border = "single";
          };
        };
        accept = {
          auto_brackets = {
            enabled = false;
          };
        };
      };
    };
  };
}
