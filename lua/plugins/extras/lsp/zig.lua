return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, { "zig" })
      end
    end,
  },
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, { "zls", "codelldb" })
      end
    end,
  },
  {
    "ziglang/zig.vim",
    version = false,
    ft = { "zig" },
    init = function()
      vim.g.zig_fmt_autosave = 0 -- handled by lsp
    end,
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        zls = {
          settings = {
            semantic_tokens = "full",
            warn_style = true,
            highlight_global_var_declarations = true,
            -- NOTE: never seen an inlay hint
            -- and I don't know what record_session does
            -- nor dangerous_comptime_experiments_do_not_enable...
            enable_inlay_hints = true,
            inlay_hints_show_builtin = true,
            -- inlay_hints_exclude_single_argument = true,
            -- inlay_hints_hide_redundant_param_names = true,
            -- inlay_hints_hide_redundant_param_names_last_token = true,
            -- dangerous_comptime_experiments_do_not_enable = true,
            -- record_session = true,
          },
        },
      },
    },
  },
  {
    "mfussenegger/nvim-dap",
    opts = function()
      local dap = require("dap")
      dap.configurations["zig"] = {
        {
          type = "codelldb",
          request = "launch",
          name = "Run Zig program",
          program = function()
            vim.cmd("make")
            local command = "fd . -t x zig-out/bin/"
            local bin_location = io.popen(command, "r")

            if bin_location ~= nil then
              return vim.fn.getcwd() .. "/" .. bin_location:read("*a"):gsub("[\n\r]", "")
            else
              return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
            end
          end,
          cwd = "${workspaceFolder}",
          stopOnEntry = false,
        },
        {
          type = "codelldb",
          request = "attach",
          name = "Attach to process",
          processId = require("dap.utils").pick_process,
          cwd = "${workspaceFolder}",
        },
      }
    end,
  },
  {
    "nvim-neotest/neotest",
    optional = true,
    dependencies = {
      "lawrence-laz/neotest-zig",
    },
    opts = {
      adapters = {
        ["neotest-zig"] = {},
      },
    },
  },
}
