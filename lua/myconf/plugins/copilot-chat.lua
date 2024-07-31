return {
  "CopilotC-Nvim/CopilotChat.nvim",
  branch = "canary",
  dependencies = {
    { "zbirenbaum/copilot.lua" }, -- or github/copilot.vim
    { "nvim-lua/plenary.nvim" }, -- for curl, log wrapper
  },
  
  opts = {
    debug = true, -- Enable debugging
    -- See Configuration section for rest
  },

  vim.api.nvim_set_keymap("n", "<leader>cc", "<cmd>CopilotChatToggle<cr>", { noremap = true, silent = true }),
}
