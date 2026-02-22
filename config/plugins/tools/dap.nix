{ pkgs, lib, ... }:
let
  pythonWithDebugpy = lib.getExe (pkgs.python3.withPackages (ps: [ ps.debugpy ]));
  cProgramResolver = ''
    function()
      local cwd = string.format("%s/", vim.fn.getcwd())
      return vim.fn.input("Path to executable: ", cwd, "file")
    end
  '';
  cArgsResolver = ''
    function()
      local args = vim.fn.input("Enter args: ")
      return vim.split(args, " ", { trimempty = true })
    end
  '';
  pythonResolver = ''
    function()
      local cwd = vim.fn.getcwd()
      local candidates = {
        cwd .. "/.venv/bin/python",
        cwd .. "/venv/bin/python",
        cwd .. "/.venv/Scripts/python.exe",
        cwd .. "/venv/Scripts/python.exe",
      }

      for _, path in ipairs(candidates) do
        if vim.fn.executable(path) == 1 then
          return path
        end
      end

      return "${pythonWithDebugpy}"
    end
  '';

  mkDapMap =
    key: luaBody: desc:
    {
      mode = "n";
      inherit key;
      action.__raw = ''
        function()
          ${luaBody}
        end
      '';
      options = {
        silent = true;
        inherit desc;
      };
    };
in
{
  extraPackages = [
    # Provide the `codelldb` executable on PATH for nvim-dap-lldb.
    pkgs.vscode-extensions.vadimcn.vscode-lldb.adapter
  ];

  plugins = {
    dap = {
      enable = true;
      adapters.executables = {
        debugpy = {
          command = pythonWithDebugpy;
          args = [
            "-m"
            "debugpy.adapter"
          ];
        };
        python = {
          command = pythonWithDebugpy;
          args = [
            "-m"
            "debugpy.adapter"
          ];
        };
      };
      adapters.servers.lldb = {
        port = "$\{port}";
        executable = {
          command = "codelldb";
          args = [
            "--port"
            "$\{port}"
          ];
          detached = true;
        };
      };

      configurations = {
        c = [
          {
            type = "lldb";
            request = "launch";
            name = "C: Launch";
            cwd = "$\{workspaceFolder}";
            stopOnEntry = false;
            program.__raw = cProgramResolver;
          }
          {
            type = "lldb";
            request = "launch";
            name = "C: Launch (+args)";
            cwd = "$\{workspaceFolder}";
            stopOnEntry = false;
            program.__raw = cProgramResolver;
            args.__raw = cArgsResolver;
          }
        ];

        cpp = [
          {
            type = "lldb";
            request = "launch";
            name = "C++: Launch";
            cwd = "$\{workspaceFolder}";
            stopOnEntry = false;
            program.__raw = cProgramResolver;
          }
          {
            type = "lldb";
            request = "launch";
            name = "C++: Launch (+args)";
            cwd = "$\{workspaceFolder}";
            stopOnEntry = false;
            program.__raw = cProgramResolver;
            args.__raw = cArgsResolver;
          }
        ];

        python = [
          {
            type = "debugpy";
            request = "launch";
            name = "Python: Current File";
            program = "$\{file}";
            cwd = "$\{workspaceFolder}";
            console = "integratedTerminal";
            justMyCode = true;
            pythonPath.__raw = pythonResolver;
          }
          {
            type = "debugpy";
            request = "launch";
            name = "Python: Module";
            module.__raw = "function() return vim.fn.input('Module name: ') end";
            cwd = "$\{workspaceFolder}";
            console = "integratedTerminal";
            justMyCode = true;
            pythonPath.__raw = pythonResolver;
          }
          {
            type = "debugpy";
            request = "launch";
            name = "Python: Pytest Current File";
            module = "pytest";
            args = [
              "$\{file}"
              "-q"
            ];
            cwd = "$\{workspaceFolder}";
            console = "integratedTerminal";
            justMyCode = false;
            pythonPath.__raw = pythonResolver;
          }
        ];
      };

      signs = {
        dapBreakpoint = {
          text = "●";
          texthl = "DiagnosticError";
        };
        dapBreakpointCondition = {
          text = "◆";
          texthl = "DiagnosticWarn";
        };
        dapLogPoint = {
          text = "◆";
          texthl = "DiagnosticInfo";
        };
        dapStopped = {
          text = "▶";
          texthl = "DiagnosticWarn";
          linehl = "DapStoppedLine";
        };
      };
    };

    dap-ui = {
      enable = true;
      settings = {
        floating.border = "rounded";
        render.max_value_lines = 60;
      };
    };

    dap-lldb = {
      enable = true;
      settings.codelldb_path = "codelldb";
    };

    dap-virtual-text = {
      enable = true;
      settings = {
        commented = true;
        highlight_changed_variables = true;
        only_first_definition = true;
      };
    };
  };

  keymaps = [
    # VSCode-like function keys
    (mkDapMap "<F5>" "require('dap').continue()" "Debug: Start/Continue")
    (mkDapMap "<S-F5>" "require('dap').terminate()" "Debug: Stop")
    (mkDapMap "<F9>" "require('dap').toggle_breakpoint()" "Debug: Toggle Breakpoint")
    (mkDapMap "<F10>" "require('dap').step_over()" "Debug: Step Over")
    (mkDapMap "<F11>" "require('dap').step_into()" "Debug: Step Into")
    (mkDapMap "<S-F11>" "require('dap').step_out()" "Debug: Step Out")
    (mkDapMap "<F7>" "require('dapui').toggle()" "Debug: Toggle UI")

    # Leader fallbacks and extra debugging helpers
    (mkDapMap "<leader>dc" "require('dap').continue()" "DAP Continue")
    (mkDapMap "<leader>dq" "require('dap').terminate()" "DAP Terminate")
    (mkDapMap "<leader>du" "require('dapui').toggle()" "DAP UI Toggle")
    (mkDapMap "<leader>db" "require('dap').toggle_breakpoint()" "DAP Toggle Breakpoint")
    (
      mkDapMap
        "<leader>dB"
        "require('dap').set_breakpoint(vim.fn.input('Breakpoint condition: '))"
        "DAP Conditional Breakpoint"
    )
    (
      mkDapMap
        "<leader>dl"
        "require('dap').set_breakpoint(nil, nil, vim.fn.input('Log point message: '))"
        "DAP Log Point"
    )
    (mkDapMap "<leader>do" "require('dap').step_over()" "DAP Step Over")
    (mkDapMap "<leader>di" "require('dap').step_into()" "DAP Step Into")
    (mkDapMap "<leader>dO" "require('dap').step_out()" "DAP Step Out")
    (mkDapMap "<leader>dr" "require('dap').repl.toggle()" "DAP REPL Toggle")
  ];

  extraConfigLua = ''
    local dap = require("dap")
    local dapui = require("dapui")

    -- Highlight the full line while paused on a breakpoint/step.
    vim.api.nvim_set_hl(0, "DapStoppedLine", { link = "CursorLine", default = true })

    -- Auto open UI when debugging starts.
    dap.listeners.before.attach.dapui_auto_open = function()
      dapui.open()
    end
    dap.listeners.before.launch.dapui_auto_open = function()
      dapui.open()
    end

    -- Auto close UI when debugging ends.
    dap.listeners.before.event_terminated.dapui_auto_close = function()
      dapui.close()
    end
    dap.listeners.before.event_exited.dapui_auto_close = function()
      dapui.close()
    end
  '';
}
