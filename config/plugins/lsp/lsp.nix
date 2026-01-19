{ lib, pkgs, ... }:
{
  plugins = {
    lsp-lines.enable = true;

    lsp = {
      enable = true;
      inlayHints = true;

      servers = {
        clangd = {
          enable = true;
          cmd = [
            "clangd"
            "--background-index"
            "--clang-tidy"
          ];
        };
        nixd = {
          enable = true;
          settings.formatting.command = [ "${lib.getExe pkgs.nixfmt}" ];
        };
        lua_ls.enable = true;
        pyright.enable = true;
        jdtls.enable = true;
        marksman.enable = true;
        bashls.enable = true;
      };

      keymaps = {
        lspBuf = {
          "gd" = "definition";
          "gD" = "references";
          "gt" = "type_definition";
          "gi" = "implementation";
          "K" = "hover";
          "<leader>rn" = "rename";
          "<leader>ca" = "code_action";
        };

        diagnostic = {
          "[d" = "goto_prev";
          "]d" = "goto_next";
        };
      };
    };
  };

  keymaps = [
    {
      mode = "n";
      key = "<leader>lr";
      action = "<CMD>LspRestart<Enter>";
      options.desc = "Restart LSP";
    }
    {
      mode = "n";
      key = "<leader>lx";
      action = "<CMD>LspStop<Enter>";
      options.desc = "Stop LSP";
    }
  ];

  extraConfigLua = ''
    vim.diagnostic.config({
      virtual_text = false,
      virtual_lines = true, 
    })
  '';
}
