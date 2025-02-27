return {
   "nvim-telescope/telescope-file-browser.nvim",
   dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },

   vim.keymap.set("n", "<leader>fz", require("telescope").extensions.zoxide.list, { desc = "Zoxide Paths" }),
}
