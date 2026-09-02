-- Make snacks terminals inherit Normal instead of NormalFloat,
-- so the toggled terminal matches the editor background (themes like
-- aether paint NormalFloat with an opaque darker float color).
return {
  {
    "folke/snacks.nvim",
    opts = {
      styles = {
        terminal = {
          wo = { winhighlight = "Normal:Normal,NormalNC:NormalNC" },
        },
      },
    },
  },
}
