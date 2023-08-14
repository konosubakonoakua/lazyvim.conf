-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

if vim.g.neovide then
  vim.opt.guifont = { "Lilex Nerd Font Mono", "h9" }
  vim.g.neovide_scale_factor = 0.3
end

-- vim.g.python3_host_prog = "/usr/bin/python3"
vim.g.python3_host_prog = "/home/rfe1wx/App/miniconda3/envs/py38/bin/python3"
