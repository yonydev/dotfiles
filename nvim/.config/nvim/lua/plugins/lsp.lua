return {
  -- REMAPED LSP KEYBINDINGS
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        ["*"] = {
          keys = {
            { "K", "<cmd>Lspsaga hover_doc<CR>", has = "hover" },
            { "gr", "<cmd>Lspsaga finder ref<CR>", has = "references" },
          },
        },
      },
    },
  },
  -- {
  --   "VidocqH/lsp-lens.nvim",
  --   opts = {
  --     enable = true,
  --     include_declaration = false, -- Reference include declaration
  --     sections = { -- Enable / Disable specific request
  --       definition = false,
  --       references = true,
  --       implementation = true,
  --     },
  --     ignore_filetype = {
  --       "prisma",
  --     },
  --   },
  -- },
  -- {
  --   "mhanberg/output-panel.nvim",
  --   event = "VeryLazy",
  --   keys = {
  --     { "<leader>uo", "<cmd>OutputPanel<cr>", desc = "Toggle LSP output" },
  --   },
  --   config = true,
  -- },
  -- {
  --   "lvimuser/lsp-inlayhints.nvim",
  --   -- branch = "anticonceal",
  --   branch = "main",
  --   opts = {},
  --   lazy = true,
  --   init = function()
  --     vim.api.nvim_create_autocmd("LspAttach", {
  --       group = vim.api.nvim_create_augroup("LspAttach_inlayhints", {}),
  --       callback = function(args)
  --         if not (args.data and args.data.client_id) then
  --           return
  --         end
  --         local client = vim.lsp.get_client_by_id(args.data.client_id)
  --         require("lsp-inlayhints").on_attach(client, args.buf)
  --       end,
  --     })
  --   end,
  -- },
  {
    "nvimdev/lspsaga.nvim",
    lazy = true,
    event = { "LspAttach" },
    cmd = { "Lspsaga" },
    dependencies = {
      "neovim/nvim-lspconfig",
      "nvim-tree/nvim-web-devicons",
      "nvim-treesitter/nvim-treesitter",
    },
    opts = {
      ui = {
        title = false,
        border = "rounded",
      },
      outline = {
        keys = {
          expand_or_jump = "<cr>",
        },
      },
      finder = {
        keys = {
          vsplit = "v",
          split = "s",
          quit = { "q", "<esc>" },
          edit = { "<cr>" },
          close_in_preview = "q",
        },
      },
      definition = {
        edit = "<cr>",
        vsplit = "<C-v>",
        split = "<C-s>",
        tabe = "<C-t>",
      },
      -- breadcrumbs
      -- https://github.com/glepnir/lspsaga.nvim#lspsaga-symbols-in-winbar
      symbol_in_winbar = {
        enable = true,
      },
      beacon = {
        enable = false,
      },
      implement = {
        enable = false,
      },
      lightbulb = {
        enable = false,
        enable_in_insert = false,
      },
      -- diagnostic = {
      --   extend_relatedInformation = true,
      -- },
    },
  },
  {
    "ray-x/lsp_signature.nvim",
    event = { "VeryLazy" },
    opts = {
      hint_prefix = "🚀 ",
      floating_window = false,
    },
  },
  -- {
  --   "SmiteshP/nvim-navbuddy",
  --   dependencies = {
  --     "SmiteshP/nvim-navic",
  --     "MunifTanjim/nui.nvim",
  --   },
  --   opts = { lsp = { auto_attach = true } },
  --   keys = { { "<leader>vo", "<cmd>Navbuddy<cr>", desc = "NavBuddy" } },
  -- },
  {
    "OlegGulevskyy/better-ts-errors.nvim",
    event = { "LspAttach" },
    dependencies = { "MunifTanjim/nui.nvim" },
    opts = {
      keymaps = {
        toggle = "<leader>dd",
        go_to_definition = "<leader>dx",
      },
    },
  },
}
