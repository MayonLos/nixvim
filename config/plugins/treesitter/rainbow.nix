{
  plugins.rainbow-delimiters = {
    enable = true;
    strategy = {
      "" = "global";
      nix.__raw = ''
        function()
          if vim.fn.line('$') > 1000 then
            return nil
          end
          return require('rainbow-delimiters').strategy['local']
        end
      '';
    };
  };
}