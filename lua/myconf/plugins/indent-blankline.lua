-- indent blankline: this plugin adds indentation guides to Neovim

return {
  "lukas-reineke/indent-blankline.nvim",
  event = { "BufReadPre", "BufNewFile" },
  main = "ibl",
  opts = {
    indent = { 
      char = "│", -- char = "\u{250A}", 
      highlight = { "indentlinecolor" },
    }, 
    scope = { -- marked indent line for scope
      enabled = true,
      char = "│", -- ▏
      show_start = false, -- shows an underline on the first line of the scope
      show_end = false, -- shows an underline on the last line of the scope
      highlight = { "indentscopelinecolor" },
    },
  },

}