local prompts = {
   -- Code related prompts
   Explain = "Please explain how the following code works.",
   Review = "Please review the following code and provide suggestions for improvement.",
   Tests = "Please explain how the selected code works, then generate unit tests for it.",
   Refactor = "Please refactor the following code to improve its clarity and readability.",
   FixCode = "Please fix the following code to make it work as intended.",
   FixError = "Please explain the error in the following text and provide a solution.",
   BetterNamings = "Please provide better names for the following variables and functions.",
   Documentation = "Please provide documentation for the following code.",
   -- Text related prompts
   Summarize = "Please summarize the following text.",
   Spelling = "Please correct any grammar and spelling errors in the following text.",
   Wording = "Please improve the grammar and wording of the following text.",
   Concise = "Please rewrite the following text to make it more concise.",
}

return {
   "CopilotC-Nvim/CopilotChat.nvim",
   branch = "main",
   dependencies = {
      { "zbirenbaum/copilot.lua" }, -- or github/copilot.vim
      { "nvim-lua/plenary.nvim" }, -- for curl, log wrapper
   },

   opts = {
      debug = false,
      question_header = "## User ",
      answer_header = "## Copilot ",
      error_header = "## Error ",
      prompts = prompts,
      auto_follow_cursor = false,
      mappings = {
         -- Use tab for completion
         complete = {
            detail = "Use @<Tab> or /<Tab> for options.",
            insert = "<Tab>",
         },
         -- Close the chat
         close = {
            normal = "q",
            insert = "<C-c>",
         },
         -- Reset the chat buffer
         reset = {
            normal = "<C-r>",
            insert = "<C-r>",
         },
         -- Submit the prompt to Copilot
         submit_prompt = {
            normal = "<CR>",
            insert = "<C-CR>",
         },
         -- Accept the diff
         accept_diff = {
            normal = "<C-y>",
            insert = "<C-y>",
         },
         -- Yank the diff in the response to register
         yank_diff = {
            normal = "gy",
         },
         -- Show the diff
         show_diff = {
            normal = "gd",
         },
         -- Show the prompt
         show_info = {
            normal = "gp",
         },
         -- Show the user selection
         show_context = {
            normal = "gs",
         },
      },
   },

   config = function(_, opts)
      local chat = require("CopilotChat")
      local select = require("CopilotChat.select")

      -- Use unnamed register for the selection
      opts.selection = select.unnamed

      -- Override the git prompts message
      opts.prompts.Commit = {
         prompt = "Write commit message for the change with commitizen convention",
         selection = select.gitdiff,
      }
      opts.prompts.CommitStaged = {
         prompt = "Write commit message for the change with commitizen convention",
         selection = function(source)
            return select.gitdiff(source, true)
         end,
      }

      chat.setup(opts)

      -- CMP integration
      opts.chat_autocomplete = true

      vim.api.nvim_create_user_command("CopilotChatVisual", function(args)
         chat.ask(args.args, { selection = select.visual })
      end, { nargs = "*", range = true })

      -- Inline chat with Copilot
      vim.api.nvim_create_user_command("CopilotChatInline", function(args)
         chat.ask(args.args, {
            selection = select.visual,
            window = {
               layout = "float",
               title = " Copilot Chat ",
               relative = "editor",
               width = 0.5,
               height = 0.5,
               row = 2,
            },
         })
      end, { nargs = "*", range = true })

      -- Restore CopilotChatBuffer
      vim.api.nvim_create_user_command("CopilotChatBuffer", function(args)
         chat.ask(args.args, { selection = select.buffer })
      end, { nargs = "*", range = true })

      -- Custom buffer for CopilotChat
      vim.api.nvim_create_autocmd("BufEnter", {
         pattern = "copilot-*",
         callback = function()
            vim.opt_local.relativenumber = true
            vim.opt_local.number = true

            -- Get current filetype and set it to markdown if the current filetype is copilot-chat
            local ft = vim.bo.filetype
            if ft == "copilot-chat" then
               vim.bo.filetype = "markdown"
            end
         end,
      })

      -- Autocmd to equalize window sizes after opening the Copilot chat window
      vim.api.nvim_create_autocmd("BufWinEnter", {
         pattern = "copilot-chat",
         callback = function()
            vim.cmd("wincmd =")
         end,
      })

      -- Set the statusline to show the current line number in the Copilot chat buffer
      vim.cmd([[
        augroup SpecificFileSettings
          autocmd!
          autocmd BufEnter * if expand('%:t') == 'copilot-chat' | let &stc='%=%{v:relnum?v:relnum:v:lnum} ' | endif
        augroup END
      ]])
   end,

   keys = {
      -- Show help actions with telescope
      {
         "<leader>cch",
         function()
            local actions = require("CopilotChat.actions")
            require("CopilotChat.integrations.telescope").pick(actions.help_actions())
         end,
         desc = "CopilotChat - Help actions",
      },
      -- Show prompts actions with telescope
      {
         "<leader>ccp",
         function()
            local actions = require("CopilotChat.actions")
            require("CopilotChat.integrations.telescope").pick(actions.prompt_actions())
         end,
         mode = { "n", "v" },
         desc = "CopilotChat - Prompt actions",
      },
      -- Quick chat
      {
         "<leader>ccq",
         function()
            local input = vim.fn.input("Quick Chat: ")
            if input ~= "" then
               vim.cmd("CopilotChatBuffer " .. input)
            end
         end,
         desc = "CopilotChat - Quick chat",
      },
      -- Chat with Copilot in visual mode
      {
         "<leader>ccv",
         -- ":CopilotChatVisual",
         function()
            vim.cmd("CopilotChatVisual")
         end,
         mode = "x",
         desc = "CopilotChat - Open in vertical split",
      },
      {
         "<leader>cci",
         ":CopilotChatInline<cr>",
         -- mode = "x",
         desc = "CopilotChat - Inline chat",
      },
      -- Custom input for CopilotChat
      {
         "<leader>ccx",
         function()
            local input = vim.fn.input("Ask Copilot: ")
            if input ~= "" then
               vim.cmd("CopilotChat " .. input)
            end
         end,
         desc = "CopilotChat - Ask input",
      },
      {
         "<leader>ccc",
         "<cmd>CopilotChatToggle<cr>",
         desc = "CopilotChat - Toggle chat",
         noremap = true,
         silent = true,
         mode = { "n", "v" },
      },
      {
         "<leader>cca",
         function()
            vim.cmd("CopilotChatBuffer")
         end,
         desc = "CopilotChat - Select all and open",
      },
      -- Debug
      { "<leader>ccd", "<cmd>CopilotChatDebugInfo<cr>", desc = "CopilotChat - Debug Info" },
   },
}
