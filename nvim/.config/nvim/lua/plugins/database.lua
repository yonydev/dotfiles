-- Database connections for vim-dadbod-ui (installed via the lazyvim lang.sql extra).
-- Connection URLs live in ~/.env-secrets (sourced by .bashrc), never in this repo.
return {
  {
    "tpope/vim-dadbod",
    init = function()
      local connections = {
        { name = "finbox_local", var = "FINBOX_DB_LOCAL" },
        { name = "finbox_pi", var = "FINBOX_DB_PI" },
      }
      local dbs = {}
      for _, conn in ipairs(connections) do
        local url = vim.env[conn.var]
        if url and url ~= "" then
          table.insert(dbs, { name = conn.name, url = url })
        end
      end
      vim.g.dbs = dbs
    end,
  },
}
