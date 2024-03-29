-- https://github.com/nvim-neo-tree/neo-tree.nvim/wiki/Recipes
-- https://github.com/nvim-neo-tree/neo-tree.nvim/wiki/Visual-Customizations
--
-- Network
-- https://github.com/miversen33/netman.nvim#neo-tree
--
-- How to get the current path of a neo-tree buffer
-- https://github.com/nvim-neo-tree/neo-tree.nvim/discussions/319
--
--
local icons = require("util.icons").todo
local events = require("neo-tree.events")

return {
  -- PERF: when using / to search, will aborting early if matched with flash
  {
    "s1n7ax/nvim-window-picker",
    name = "window-picker",
    version = "2.*",
    config = function()
      require("window-picker").setup({
        filter_rules = {
          include_current_win = false,
          autoselect_one = true,
          -- filter using buffer options
          bo = {
            -- if the file type is one of following, the window will be ignored
            filetype = { "neo-tree", "neo-tree-popup", "notify" },
            -- if the buffer type is one of following, the window will be ignored
            buftype = { "terminal", "quickfix" },
          },
        },
        hint = "floating-big-letter",
      })
    end,
  },

  -- TODO: config neo-tree
  -- when neo-tree win lost focus,
  -- dont redraw on large folder with many opend dir
  {
    "nvim-neo-tree/neo-tree.nvim",
    -- branch = "v3.x",
    branch = "main",
    -- "konosubakonoakua/neo-tree.nvim",
    -- branch = "main",
    cmd = "Neotree",
    keys = {
      -- region fix file following issue
      {
        "<leader>e",
        require("util.plugins.neotree").neotree_reveal_root,
        -- "<cmd>Neotree toggle show<cr>",
        desc = "Explorer NeoTree (root dir)",
      },
      {
        "<leader>E",
        require("util.plugins.neotree").neotree_reveal_cwd,
        -- "<cmd>Neotree toggle show<cr>",
        desc = "Explorer NeoTree (cwd)",
      },
      -- endregion fix file following issue
      {
        "<leader>ge",
        function()
          require("neo-tree.command").execute({ source = "git_status", toggle = true })
        end,
        desc = "Git explorer",
      },
      {
        "<leader>be",
        function()
          require("neo-tree.command").execute({ source = "buffers", toggle = true })
        end,
        desc = "Buffer explorer",
      },
      {
        "<leader>ce", "<cmd>Neotree document_symbols<cr>", desc = "Neotree (Symbols)",
      },
      {
        -- TODO: not working if already on the neotree window,
        -- consider record the last file buffer which needs to be revealed in <leader>e
        -- currently stop using auto-follow
        "<leader>fe", function ()
          -- TODO: quit if not on a realfile or use history
          require('neo-tree.command').execute({
            action = "show",
            source = "filesystem",
            position = "left",
            -- reveal_file = reveal_file,
            dir = LazyVim.root(),
            -- reveal_force_cwd = true,
            -- toggle = true,
          })
          -- FIXME: don't close opend folders
          -- show_only_explicitly_opened() can be disabled
          require("neo-tree.sources.filesystem.init").follow(nil, true)
          -- -- FIXME: cannot focus on file
          -- vim.cmd([[
          --   Neotree reveal
          -- ]])
          require('neo-tree.command').execute({
            action = "reveal",
            source = "filesystem",
            position = "left",
            dir = LazyVim.root(),
            -- toggle = true,
          })
        end,
        mode = 'n',
        desc="Open neo-tree at current file or working directory"
      }
    },
    deactivate = function()
      vim.cmd([[Neotree close]])
    end,
    init = function()
      if vim.fn.argc(-1) == 1 then
        local stat = vim.loop.fs_stat(tostring(vim.fn.argv(0)))
        if stat and stat.type == "directory" then
          require("neo-tree")
        end
      end
    end,
    opts = {
      use_popups_for_input = false,
      sources = {
        "filesystem",
        "buffers",
        "git_status",
        "document_symbols"
      },
      open_files_do_not_replace_types = {
        "terminal",
        "Trouble",
        "trouble",
        "qf",
        "Outline"
      },
      filesystem = {
        bind_to_cwd = false,
        follow_current_file = { enabled = true }, -- BUG: not working on windows
        use_libuv_file_watcher = true,
        find_command = "fd",
        find_args = {
          fd = {
            "--exclude",
            ".git",
            "--exclude",
            "node_modules",
          },
        },
      },
      window = {
        mappings = require("util.plugins.neotree").mappings
      },
      default_component_configs = {
        indent = {
          with_expanders = true, -- if nil and file nesting is enabled, will enable expanders
          expander_collapsed = "",
          expander_expanded = "",
          expander_highlight = "NeoTreeExpander",
        },
      },
    },
    config = function(_, opts)
      local function on_move(data)
        LazyVim.lsp.on_rename(data.source, data.destination)
      end

      -- region neo-tree event_handlers
      opts.event_handlers = opts.event_handlers or {}
      vim.list_extend(opts.event_handlers, {
        { event = events.FILE_MOVED, handler = on_move },
        { event = events.FILE_RENAMED, handler = on_move },
      })
      -- extend default handlers with user defined ones
      vim.list_extend(opts.event_handlers,
        require("util.plugins.neotree").neotree_event_handlers)
      -- endregion neo-tree event_handlers
      require("neo-tree").setup(opts)
      vim.api.nvim_create_autocmd("TermClose", {
        pattern = "*lazygit",
        callback = function()
          if package.loaded["neo-tree.sources.git_status"] then
            require("neo-tree.sources.git_status").refresh()
          end
        end,
      })
    end,
  },
  --]]

  -- here only using whichkey for reminding
  -- using 'keymap.lua' or other files to register actual keys
  {
    "folke/which-key.nvim",
    opts = {
      plugins = { spelling = true },
      defaults = {
        mode = { "n", "v" },
        ["gz"] = {},
        ["<leader>l"] = { name = "placeholder" }, -- TODO: remap <leader>l
        ["<leader>L"] = { name = "placeholder" }, -- TODO: remap <leader>L
        ["<leader>;"] = { name = "+utils" },
        ["<leader><leader>"] = { name = "+FzfLua" },
        ["<leader>T"] = { name = "+Test" },
        ["<leader>t"] = { name = "+Telescope" },
      },
    },
  },

  -- Automatically highlights other instances of the word under your cursor.
  -- This works with LSP, Treesitter, and regexp matching to find the other
  -- instances.
  -- change some telescope options and a keymap to browse plugin files
  {
    "nvim-telescope/telescope.nvim",
    version = false, -- telescope did only one release, so use HEAD for now
    config = function(_, opts)
      -- PERF: default is "smart", performance killer
      opts.defaults.path_display = { "absolute" }
      opts.defaults.layout_config = {
        width = 999,
        height = 999,
        -- vertical = { width = 1.0, height = 1.0 }
      }
      -- stylua: ignore start
      -- TODO: add keymap to delete selected buffers, maybe need a keymap to select all
      opts.defaults.mappings = {
        i = {
          ["<C-j>"] = function(...) return require("telescope.actions").move_selection_next(...) end,
          ["<C-k>"] = function(...) return require("telescope.actions").move_selection_previous(...) end,
          ["<C-n>"] = function(...) return require("telescope.actions").move_selection_next(...) end,
          ["<C-p>"] = function(...) return require("telescope.actions").move_selection_previous(...) end,
          ["<A-p>"] = function(...) return require("telescope.actions.layout").toggle_preview(...) end,
        },
        n = {
          ["<A-p>"] = function(...) return require("telescope.actions.layout").toggle_preview(...) end,
        },
      }
      -- stylua: ignore end
      local telescope = require("telescope")
      telescope.setup(opts)
    end,
  },

  -- todo-comments
  -- TODO: ###
  -- FIX: ###
  -- HACK: ###
  -- WARN: ###
  -- PERF: ###
  -- NOTE: ###
  -- TEST: ###
  {
    "folke/todo-comments.nvim",
    version = false,
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      signs = true, -- show icons in the signs column
      sign_priority = 8, -- sign priority
      -- keywords recognized as todo comments
      -- found icons on https://www.nerdfonts.com/cheat-sheet
      keywords = {
        FIX = { icon = icons.bug, color = "error", alt = { "FIXME", "BUG", "FIXIT", "ISSUE" } },
        TODO = { icon = icons.todo, color = "info" },
        HACK = { icon = icons.hack, color = "#F86F03" },
        WARN = { icon = icons.warn, color = "warning", alt = { "WARNING", "XXX" } },
        PERF = { icon = icons.perf, alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
        NOTE = { icon = icons.note, color = "hint", alt = { "INFO" } },
        TEST = { icon = icons.test, color = "#2CD3E1", alt = { "TESTING", "PASSED", "FAILED" } },
      },
      gui_style = {
        fg = "NONE", -- The gui style to use for the fg highlight group.
        bg = "BOLD", -- The gui style to use for the bg highlight group.
      },
      merge_keywords = true, -- when true, custom keywords will be merged with the defaults
      -- highlighting of the line containing the todo comment
      -- * before: highlights before the keyword (typically comment characters)
      -- * keyword: highlights of the keyword
      -- * after: highlights after the keyword (todo text)
      highlight = {
        multiline = true, -- enable multine todo comments
        multiline_pattern = "^.", -- lua pattern to match the next multiline from the start of the matched keyword
        multiline_context = 10, -- extra lines that will be re-evaluated when changing a line
        before = "", -- "fg" or "bg" or empty
        keyword = "wide", -- "fg", "bg", "wide", "wide_bg", "wide_fg" or empty. (wide and wide_bg is the same as bg, but will also highlight surrounding characters, wide_fg acts accordingly but with fg)
        after = "fg", -- "fg" or "bg" or empty
        pattern = [[.*<(KEYWORDS)\s*:]], -- pattern or table of patterns, used for highlighting (vim regex)
        comments_only = true, -- uses treesitter to match keywords in comments only
        max_line_len = 400, -- ignore lines longer than this
        exclude = {}, -- list of file types to exclude highlighting
      },
      -- list of named colors where we try to extract the guifg from the
      -- list of highlight groups or use the hex color if hl not found as a fallback
      colors = {
        -- error   = { "DiagnosticError", "ErrorMsg", "#DC2626" },
        -- warning = { "DiagnosticWarn", "WarningMsg", "#FBBF24" },
        -- info    = { "DiagnosticInfo", "#2563EB" },
        -- hint    = { "DiagnosticHint", "#10B981" },
        -- default = { "Identifier", "#7C3AED" },
        -- test    = { "Identifier", "#FF00FF" }
        error = { "#DC2626" },
        warning = { "#FBBF24" },
        info = { "#2563EB" },
        hint = { "#10B981" },
        default = { "#7C3AED" },
        test = { "#FF00FF" },
      },
      search = {
        command = "rg",
        args = {
          "--color=never",
          "--no-heading",
          "--with-filename",
          "--line-number",
          "--column",
        },
        -- regex that will be used to match keywords.
        -- don't replace the (KEYWORDS) placeholder
        pattern = [[\b(KEYWORDS):]], -- ripgrep regex
        -- pattern = [[\b(KEYWORDS)\b]], -- match without the extra colon. You'll likely get false positives
      },
    },
  },

  -- search/replace in multiple files
  {
    "nvim-pack/nvim-spectre",
    version = false,
    cmd = "Spectre",
    opts = { open_cmd = "noswapfile vnew" },
    -- stylua: ignore
  },

}
