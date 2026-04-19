return {
   "olimorris/codecompanion.nvim",
   dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
   },
   opts = {
      strategies = {
         chat = {
            adapter = "copilot",
         },
         inline = {
            adapter = "copilot",
         },
         agent = {
            adapter = "copilot",
         },
      },

      display = {
         chat = {
            window = {
               layout = "vertical",
               width = 0.40,
            },
         },
      },

      opts = {
         log_level = "ERROR",
      },
   },
   config = function(_, opts)
      require("copilot").setup({
         suggestion = { enabled = false },
         panel = { enabled = false },
      })

      require("codecompanion").setup(opts)

      local keymap = vim.keymap.set
      local silent = { noremap = true, silent = true }

      -- Chat
      keymap("n", "<leader>ac", "<cmd>CodeCompanionChat Toggle<cr>", silent)
      keymap("v", "<leader>ac", "<cmd>CodeCompanionChat Add<cr>", silent)

      -- Inline assistant
      keymap("n", "<leader>aa", "<cmd>CodeCompanionActions<cr>", silent)
      keymap("v", "<leader>aa", "<cmd>CodeCompanionActions<cr>", silent)

      -- Prompt rapido inline sul codice selezionato
      keymap("v", "<leader>ai", "<cmd>CodeCompanion<cr>", silent)
   end,
}
