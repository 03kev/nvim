return {
    "nvim-telescope/telescope-file-browser.nvim",
    dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },

    vim.keymap.set("n", "<space>ft", ":Telescope file_browser<CR>", { desc = "File browser" }),
}