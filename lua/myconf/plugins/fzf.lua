return {
   "ibhagwan/fzf-lua",
   dependencies = { "nvim-tree/nvim-web-devicons" },
   config = function()
      local actions = require("fzf-lua.actions")

      require("fzf-lua").setup({
         "fzf-native",

         keymap = {
            builtin = {
               true,
            },
            fzf = {
               true,
               -- ["ctrl-c"] = "abort", -- Map 'q' to abort the fzf buffer
            },
         },
      })

      vim.keymap.set("n", "<c-P>", require("fzf-lua").files, { desc = "Fzf Files" })
   end,
}
