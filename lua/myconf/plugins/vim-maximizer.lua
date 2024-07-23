-- Plugin for maximizing and restoring windows in Neovim.

return {
  "szw/vim-maximizer",
  keys = {
    { "<leader>sm", "<cmd>MaximizerToggle<CR>", desc = "Maximize or minimize a splitted window" },
  },
}
