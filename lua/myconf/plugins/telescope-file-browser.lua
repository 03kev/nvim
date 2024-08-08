return {
   "jvgrootveld/telescope-zoxide",
   dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim", "nvim-lua/popup.nvim" },

   vim.keymap.set("n", "<space>ft", ":Telescope file_browser<CR>", { desc = "File browser" }),
}
