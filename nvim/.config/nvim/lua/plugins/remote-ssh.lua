return {
  "inhesrom/remote-ssh.nvim",
  branch = "master",
  dependencies = {
    "inhesrom/telescope-remote-buffer",
    "nvim-telescope/telescope.nvim",
    "nvim-lua/plenary.nvim",
    "neovim/nvim-lspconfig",
  },
  lazy = false,
  keys = {
    {
      "<leader>rO",
      function()
        local url = vim.fn.input("Remote file: ", "rsync://user@host//")
        if url ~= "" then vim.cmd("RemoteOpen " .. url) end
      end,
      desc = "Remote Open File",
    },
    {
      "<leader>rB",
      function()
        local url = vim.fn.input("Remote dir: ", "rsync://user@host//")
        if url ~= "" then vim.cmd("RemoteTreeBrowser " .. url) end
      end,
      desc = "Remote Browse",
    },
    {
      "<leader>rT",
      function()
        local cmd = vim.fn.input("TUI command: ", "")
        if cmd ~= "" then vim.cmd("RemoteTui " .. cmd) end
      end,
      desc = "Remote TUI",
    },
    { "<leader>rS", "<cmd>RemoteSync<cr>",    desc = "Remote Sync" },
    { "<leader>rC", "<cmd>RemoteClose<cr>",   desc = "Remote Close" },
    { "<leader>rH", "<cmd>RemoteHistory<cr>", desc = "Remote History" },
    { "<leader>rL", "<cmd>RemoteSSHLog<cr>",  desc = "Remote Log" },
  },
  config = function()
    require("telescope-remote-buffer").setup()

    require("remote-ssh").setup({
      capabilities = vim.lsp.protocol.make_client_capabilities(),
      filetype_to_server = {
        c          = "clangd",
        cpp        = "clangd",
        python     = "pylsp",
        rust       = "rust_analyzer",
        lua        = "lua_ls",
        go         = "gopls",
        typescript = "ts_ls",
        javascript = "ts_ls",
      },
    })
  end,
}
