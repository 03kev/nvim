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
            },
         },

         winopts = {
            backdrop = false,
         },
      })

      vim.keymap.set("n", "<leader>zf", require("fzf-lua").files, { desc = "Fzf Files", noremap = true, silent = true })
      vim.keymap.set(
         "n",
         "<leader>zs",
         require("fzf-lua").live_grep,
         { desc = "Fzf Live Grep", noremap = true, silent = true }
      )
      vim.keymap.set(
         "n",
         "<leader>zb",
         require("fzf-lua").builtin,
         { desc = "Fzf Builtin", noremap = true, silent = true }
      )

      -- double escape to exit fzf
      vim.api.nvim_create_autocmd("FileType", {
         pattern = "fzf",
         callback = function()
            -- vim.api.nvim_buf_set_keymap(0, "t", "<esc><esc>", "<c-c>", { noremap = true, silent = true })
            vim.api.nvim_buf_set_keymap(0, "n", "<esc>", "i<c-c>", { noremap = true, silent = true })
         end,
      })
   end,
}
