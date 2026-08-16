return {
  {
    "akinsho/bufferline.nvim",
    event = "VeryLazy",
    keys = function()
      return {
        { "<leader>bj", "<cmd>BufferLinePick<cr>", desc = "Jump" },
        -- { "<leader>bp", "<cmd>BufferLineCyclePrev<cr>", desc = "Previous" },
        -- { "<leader>bn", "<cmd>BufferLineCycleNext<cr>", desc = "Next" },
        -- { "<leader>bp", "<cmd>BufferLineTogglePin<cr>", desc = "Toggle pin" },
        { "<leader>bE", "<cmd>BufferLinePickClose<cr>", desc = "Pick which buffer to close" },
        { "<leader>bh", "<cmd>BufferLineCloseLeft<cr>", desc = "Close all to the left" },
        { "<leader>bl", "<cmd>BufferLineCloseRight<cr>", desc = "Close all to the right" },
        -- { "<leader>bP", "<cmd>BufferLineGroupClose ungrouped<cr>", desc = "Delete non-pinned buffers" },
        { "<leader>bS", "<cmd>BufferLineSortByDirectory<cr>", desc = "Sort by directory" },
        { "<leader>bL", "<cmd>BufferLineSortByExtension<cr>", desc = "Sort by language" },
      }
    end,
    opts = {
      options = {
        diagnostics = "nvim_lsp",
        always_show_bufferline = false,
        diagnostics_indicator = function(_, _, diag)
          local icons = require("lazyvim.config").icons.diagnostics
          local ret = (diag.error and icons.Error .. diag.error .. " " or "")
            .. (diag.warning and icons.Warn .. diag.warning or "")
          return vim.trim(ret)
        end,
        offsets = {
          {
            filetype = "neo-tree",
            text = "Neo-tree",
            highlight = "Directory",
            text_align = "left",
          },
        },
      },
    },
  },
}
