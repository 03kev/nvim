return {
   "github/copilot.vim",

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
               position = "bottom", -- | top | left | right
               ratio = 0.4,
            },
         },
         suggestion = {
            enabled = true,
            auto_trigger = false,
            hide_during_completion = true,
            debounce = 75,
            keymap = {
               accept = "<M-l>",
               accept_word = false,
               accept_line = false,
               next = "<M-]>",
               prev = "<M-[>",
               dismiss = "<C-]>",
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
         copilot_node_command = "node", -- Node.js version must be > 18.x
         server_opts_overrides = {},
      })

      -- accept copilot suggestions with <Tab> in copilot-chat buffer
      vim.api.nvim_create_autocmd("BufEnter", {
         pattern = "copilot-chat",
         callback = function()
            vim.api.nvim_buf_set_keymap(0, "i", "<Tab>", 'copilot#Accept("\\<CR>")', {
               expr = true,
               noremap = true,
               silent = true,
               replace_keycodes = false,
            })
         end,
      })

      -- Toggle Copilot inline suggestions with <leader>ci
      vim.api.nvim_set_keymap("n", "<leader>ci", ":Copilot toggle<CR>", {
         desc = "Toggle Copilot inline suggestions",
         noremap = true,
         silent = true,
      })
   end,
}
