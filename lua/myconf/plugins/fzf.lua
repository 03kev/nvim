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

      vim.keymap.set("n", "<leader>zf", require("fzf-lua").files, { desc = "Fzf Files", noremap = true, silent = true })
      vim.keymap.set("n", "<leader>zs", require("fzf-lua").live_grep, { desc = "Fzf Live Grep", noremap = true, silent = true })
      vim.keymap.set("n", "<leader>zb", require("fzf-lua").builtin, { desc = "Fzf Builtin", noremap = true, silent = true })
   end,
}
