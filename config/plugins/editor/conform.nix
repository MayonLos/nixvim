{
  plugins.conform-nvim = {
    enable = true;

    # 1. 懒加载配置
    lazyLoad = {
      enable = true;
      settings = {
        # 自动格式化触发：在写入文件前加载插件
        event = [ "BufWritePre" ];
        # 命令触发：执行此命令时加载
        cmd = [ "ConformInfo" ];
        # 快捷键触发：按下 <leader>lf 时加载并执行格式化
        keys = [
          {
            __unkeyed-1 = "<leader>lf";
            __unkeyed-2.__raw = ''
              function()
                require("conform").format({ async = true, lsp_fallback = true })
              end
            '';
            desc = "Format buffer (manual)";
          }
        ];
      };
    };

    # 2. 初始化全局变量防止 nil 错误
    luaConfig.pre = ''
      _G.slow_format_filetypes = {}
    '';

    settings = {
      formatters_by_ft = {
        lua = [ "stylua" ];
        python = [ "black" ];
        nix = [ "nixfmt" ];
        java = [ "google-java-format" ];
        c = [ "clang-format" ];
        cpp = [ "clang-format" ];
        bash = [ "shfmt" ];
        sh = [ "shfmt" ];
        "_" = [ "squeeze_blanks" "trim_whitespace" "trim_newlines" ];
      };

      # 自动保存格式化逻辑（引用全局变量 _G）
      format_on_save = ''
        function(bufnr)
          if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
            return
          end

          if _G.slow_format_filetypes[vim.bo[bufnr].filetype] then
            return
          end

          local function on_format(err)
            if err and err:match("timeout$") then
              _G.slow_format_filetypes[vim.bo[bufnr].filetype] = true
            end
          end

          return { timeout_ms = 200, lsp_fallback = true }, on_format
         end
      '';

      format_after_save = ''
        function(bufnr)
          if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
            return
          end

          if not _G.slow_format_filetypes[vim.bo[bufnr].filetype] then
            return
          end

          return { lsp_fallback = true }
        end
      '';
    };
  };

  # 3. 用户命令（用于临时禁用/启用自动格式化）
  userCommands = {
    FormatDisable = {
      command = "lua vim.g.disable_autoformat = true";
      desc = "Disable autoformat-on-save";
    };
    FormatEnable = {
      command = "lua vim.g.disable_autoformat = false";
      desc = "Enable autoformat-on-save";
    };
  };
}