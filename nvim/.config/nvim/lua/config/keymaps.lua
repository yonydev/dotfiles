-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local function map(mode, lhs, rhs, opts)
  local keys = require("lazy.core.handler").handlers.keys
  ---@cast keys LazyKeysHandler
  -- do not create the keymap if a lazy keys handler exists
  if not keys.active[keys.parse({ lhs, mode = mode }).id] then
    opts = opts or {}
    opts.silent = opts.silent ~= false
    vim.keymap.set(mode, lhs, rhs, opts)
  end
end

vim.keymap.set("n", "<leader>r", "<nop>", { desc = "+remote" })

-- Fast Enter
map("i", "jj", "<ESC>", { noremap = true, silent = true })

-- No Highlight
map("n", "<leader>h", "<cmd>nohlsearch<CR>", { noremap = true, silent = true })

-- Gitsigns hunk navigation
map("n", "<leader>ghj", function()
  require("gitsigns").nav_hunk("next")
end, { desc = "Next Hunk" })
map("n", "<leader>ghk", function()
  require("gitsigns").nav_hunk("prev")
end, { desc = "Prev Hunk" })
