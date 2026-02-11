return {
   "kdheepak/lazygit.nvim",
   cmd = {
      "LazyGit",
      "LazyGitConfig",
      "LazyGitCurrentFile",
      "LazyGitFilter",
      "LazyGitFilterCurrentFile",
   },

   -- optional for floating window border decoration
   dependencies = {
      "nvim-lua/plenary.nvim",
   },

   keys = {
      { "<leader>lg", "<cmd>LazyGit<cr>", desc = "Open lazy git" },
   },
   init = function()
      -- lazygit.nvim reads global vars (no Lua setup function)
      vim.g.lazygit_floating_window_winblend = 0
   end,

}
