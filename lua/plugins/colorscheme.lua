return {
  -- TODO: tweak colorscheme
  {
    "konosubakonoakua/oxocarbon.nvim",
    -- "nyoom-engineering/oxocarbon.nvim",
    lazy = false,
    priority = 1000,
    version = false,
  },
  {
    "scottmckendry/cyberdream.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("cyberdream").setup({
        -- Recommended - see "Configuring" below for more config options
        transparent = true,
        italic_comments = true,
        hide_fillchars = true,
        borderless_telescope = true,
      })
    end,
  },
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
  },
  {
    "projekt0n/github-nvim-theme",
    lazy = false,
    priority = 1000,
  },
  {
    "catppuccin/nvim",
    lazy = false,
    name = "catppuccin",
    priority = 1000,
    config = function()
      require("catppuccin").setup({
        color_overrides = {
          mocha = {
            rosewater = "#efc9c2",
            flamingo  = "#ebb2b2",
            pink      = "#f2a7de",
            mauve     = "#b889f4",
            red       = "#ea7183",
            maroon    = "#ea838c",
            peach     = "#f39967",
            yellow    = "#eaca89",
            green     = "#96d382",
            teal      = "#78cec1",
            sky       = "#91d7e3",
            sapphire  = "#68bae0",
            blue      = "#739df2",
            lavender  = "#a0a8f6",
            text      = "#b5c1f1",
            subtext1  = "#a6b0d8",
            subtext0  = "#959ec2",
            overlay2  = "#848cad",
            overlay1  = "#717997",
            overlay0  = "#63677f",
            surface2  = "#505469",
            surface1  = "#3e4255",
            surface0  = "#2c2f40",
            base      = "#1a1c2a",
            mantle    = "#141620",
            crust     = "#0e0f16",
          },
        },
      })
    end,
  },
  {
    "Mofiqul/adwaita.nvim",
    version = false,
    lazy = false,
    priority = 1000,
    config = function()
      vim.g.adwaita_darker = true
      vim.g.adwaita_disable_cursorline = false
      vim.g.adwaita_transparent = true
      -- vim.cmd("colorscheme adwaita")
    end,
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "oxocarbon",
    },
  },
}
