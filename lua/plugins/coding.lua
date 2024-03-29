local icon_kinds = require("lazyvim.config").icons.kinds

return {
  -- extend auto completion
  {
    "L3MON4D3/LuaSnip",
    keys = function()
      return {}
    end,
    opts = function(_, opts)
      opts.history = false
      opts.delete_check_events = "TextChanged"
    end,
  },
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-emoji",
    },
    ---@param opts cmp.ConfigSchema
    opts = function(_, opts)
      local has_words_before = function()
        unpack = unpack or table.unpack
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
      end

      local luasnip = require("luasnip")
      local cmp = require("cmp")

      opts.mapping = vim.tbl_extend("force", opts.mapping, {
        ["<Tab>"] = cmp.mapping(function(fallback)
          -- -- tweak tab behaviour, only use it for snip
          -- if cmp.visible() then
          --   -- You could replace select_next_item() with confirm({ select = true }) to get VS Code autocompletion behavior
          --   -- cmp.confirm({ select = true })
          --   cmp.select_next_item()
          --   -- You could replace the expand_or_jumpable() calls with expand_or_locally_jumpable()
          --   -- this way you will only jump inside the snippet region
          if luasnip.expand_or_locally_jumpable() then
            vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<Plug>luasnip-expand-or-jump", true, true, true), "")
            -- luasnip.expand_or_jump()
            -- elseif has_words_before() then
            --   cmp.complete()
          else
            fallback()
          end
        end, { "i", "s" }),
        ["<S-Tab>"] = cmp.mapping(function(fallback)
          -- if cmp.visible() then
          --   cmp.select_prev_item()
          if luasnip.jumpable(-1) then
            -- luasnip.jump(-1)
            vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<Plug>luasnip-jump-prev", true, true, true), "")
          else
            fallback()
          end
        end, { "i", "s" }),
      })
    end,
  },
  {
    "hrsh7th/nvim-cmp",
    opts = function(_, opts)
      local cmp = require("cmp")
      opts.completion.completeopt = "menu,menuone,noinsert"
      opts.mapping = vim.tbl_deep_extend("force", opts.mapping, {
        ["<UP>"] = cmp.mapping.scroll_docs(-4),
        ["<DOWN>"] = cmp.mapping.scroll_docs(4),

        ["<C-j>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
        ["<C-k>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
        ["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
        ["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),

        ["<CR>"] = cmp.mapping.confirm({ select = true }),
        ["<S-CR>"] = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true }),

        -- ["<C-Space>"] = cmp.mapping.complete(),

        ---- INFO: I need something else instead of `<C-e>` to abort cmp.
        ["<C-Space>"] = cmp.mapping({
          i = function()
            if cmp.visible() then -- pop-up menu is visible
              -- cmp.select_next_item()
              cmp.abort()
              cmp.close()
            else
              cmp.complete() -- open the pop-up menu
            end
          end,
        }),
        ["<C-e>"] = cmp.mapping.abort(),
        -- ["<C-y>"] = cmp.mapping.abort(),
        -- ["<C-o>"] = cmp.mapping.abort(), -- used to enter normal mode
        ["<C-c>"] = cmp.mapping.abort(),
        -- ["<C-i>"] = cmp.mapping.abort(), -- TODO: <C-i> remapping not working

        -- -- if no selection, enter a newline.
        -- ["<CR>"] = cmp.mapping({
        --   i = function(fallback)
        --     if cmp.visible() and cmp.get_active_entry() then
        --       cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false })
        --     else
        --       fallback()
        --     end
        --   end,
        --   s = cmp.mapping.confirm({ select = true }),
        --   c = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true }),
        -- }),
      })
    end,
  },
  {
    "hrsh7th/nvim-cmp",
    opts = function(_, opts)
      opts.window = {
        completion = {
          border = "none",
          scrollbar = nil,
          -- winhighlight = 'Normal:Normal,FloatBorder:FloatBorder,CursorLine:Visual,Search:None',
          col_offset = 0,
          side_padding = 0,
        }
      }
      ------ https://github.com/hrsh7th/nvim-cmp/wiki/Menu-Appearance
      opts.formatting.fields = { "kind", "abbr", "menu" }
      opts.formatting.format = function(_, item)
        -- item.menu = item.kind
        if icon_kinds[item.kind] then
          item.kind = " " .. icon_kinds[item.kind]-- .. " "
        end
        return item
      end
    end,
  },

  -- TODO: config mini.pairs
  -- auto pairs
  {
    "echasnovski/mini.pairs",
    event = "VeryLazy",
    -- opts = {},
    init = function()
      require("mini.pairs").setup({
        mappings = {
          -- -- Don't add closing pair if cursor is in front of closing character
          -- ["("] = { action = "open", pair = "()", neigh_pattern = "[^\\][^%)]" },
          -- ["["] = { action = "open", pair = "[]", neigh_pattern = "[^\\][^%]]" },
          -- ["{"] = { action = "open", pair = "{}", neigh_pattern = "[^\\][^%}]" },
        },
      })
    end,
  },
}
