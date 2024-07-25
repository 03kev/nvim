return {
  "nvim-telescope/telescope-file-browser.nvim",
  dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },

  vim.keymap.set("n", "<leader>tz", require("telescope").extensions.zoxide.list),
}
