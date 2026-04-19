return {
  "stevearc/dressing.nvim",
  event = "VeryLazy",
  config = function()
    require("dressing").setup({
      input = {
        enabled = true,
        border = "rounded",
        win_options = {
          winblend = 0,
        },
      },
      select = {
        enabled = true,
        backend = { "telescope", "builtin" }, -- Telescope first, fallback to builtin
        builtin = {
          border = "rounded",
          win_options = {
            winblend = 0,
          },
        },
      },
    })
  end,
}
