return {
   "03kev/copilot.lua",
   cmd = "Copilot",
   event = "InsertEnter",

   dependencies = {
      "copilotlsp-nvim/copilot-lsp",
   },

   config = function()
      require("copilot").setup({
         panel = {
            enabled = true,
            auto_refresh = false,
            keymap = {
               jump_prev = "[[",
               jump_next = "]]",
               accept = "<CR>",
               refresh = "gr",
               open = "<M-CR>",
            },
            layout = {
               position = "bottom",
               ratio = 0.4,
            },
         },
         suggestion = {
            enabled = true,
            auto_trigger = true,
            hide_during_completion = true,
            debounce = 75,
            trigger_on_accept = true,
            keymap = {
               accept = "<Tab>",
               accept_word = false,
               accept_line = false,
               next = "<M-]>",
               prev = "<M-[>",
               dismiss = "<C-]>",
               toggle_auto_trigger = false,
            },
         },
         filetypes = {
            yaml = false,
            markdown = true,
            help = false,
            gitcommit = false,
            gitrebase = false,
            hgcommit = false,
            svn = false,
            cvs = false,
            ["."] = false,
         },
         copilot_node_command = "node",
         server_opts_overrides = {},
      })

      vim.keymap.set("n", "<leader>ci", "<cmd>Copilot toggle<CR>", {
         desc = "Toggle Copilot inline suggestions",
         noremap = true,
         silent = true,
      })
   end,
}
