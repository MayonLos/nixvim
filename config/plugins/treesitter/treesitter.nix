{ pkgs, ... }: {
  plugins.treesitter = {
    enable = true;

    grammarPackages = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
      c
      cpp
      python
      nix
      lua
      vim
      vimdoc    
      markdown
      markdown_inline
      bash     
      java
    ];

    settings = {
      highlight = {
        enable = true;
      };
      indent = {
        enable = true;
      };
    };

    nixvimInjections = true;
  };
}