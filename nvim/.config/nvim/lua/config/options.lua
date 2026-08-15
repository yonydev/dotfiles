-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
require('config.remote_clipboard').setup()
vim.opt.relativenumber = true
vim.g.autoformat = false

local options = {
  scrolloff = 12,
  sidescrolloff = 8,
}

for k, v in pairs(options) do
  vim.opt[k] = v
end

