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
      opts = {
      backdrop = 0.8, -- Adjust transparency level as needed
   },

}
