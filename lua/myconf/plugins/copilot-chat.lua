return {
  "CopilotC-Nvim/CopilotChat.nvim",
  branch = "canary",
  dependencies = {
    { "zbirenbaum/copilot.lua" }, -- or github/copilot.vim
    { "nvim-lua/plenary.nvim" }, -- for curl, log wrapper
  },
  
  opts = {
    debug = false, -- Enable debugging
    -- See Configuration section for rest
  },

  vim.api.nvim_set_keymap("n", "<leader>cc", "<cmd>CopilotChatToggle<cr>", { noremap = true, silent = true }),
  vim.api.nvim_set_keymap("v", "<leader>cc", "<cmd>CopilotChatToggle<cr>", { noremap = true, silent = true }),
}