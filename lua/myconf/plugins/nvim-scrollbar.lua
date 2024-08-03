return {
  "petertriho/nvim-scrollbar",
  config = function()
    require("scrollbar").setup({
      handlers = {
        search = true,
      },
      excluded_filetypes = {
        "cmp_docs",
        "cmp_menu",
        "noice",
        "prompt",
        "TelescopePrompt",
        "lazygit",
      },
    })
  end,
}
