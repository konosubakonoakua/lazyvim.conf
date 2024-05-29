return {
  {
    "williamboman/mason-lspconfig.nvim",
    opts = {
      ensure_installed = {},
      automatic_installation = false,
    },
  },
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      opts.inlay_hints.enabled = true
      -- filetypes for which you don't want to enable inlay hints
      opts.inlay_hints.exclude = {

      }
      return opts
    end
  },
}
