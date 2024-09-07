return {
   "nvim-telescope/telescope.nvim",
   branch = "0.1.x",
   dependencies = {
      "nvim-lua/plenary.nvim",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
      "folke/todo-comments.nvim",
   },

   config = function()
      local telescope = require("telescope")
      local actions = require("telescope.actions")

      local fb_actions = require("telescope").extensions.file_browser.actions
      local transform_mod = require("telescope.actions.mt").transform_mod
      local z_utils = require("telescope._extensions.zoxide.utils")

      local trouble = require("trouble")
      local trouble_telescope = require("trouble.sources.telescope")

      -- or create your custom action
      local custom_actions = transform_mod({
         open_trouble_qflist = function(prompt_bufnr)
            trouble.toggle("quickfix")
         end,
      })

      telescope.setup({
         defaults = {
            path_display = { "smart" },
            color_devicons = true, -- colored icons
            mappings = {
               i = {
                  ["<C-k>"] = actions.move_selection_previous, -- move to prev result
                  ["<C-j>"] = actions.move_selection_next, -- move to next result

                  -- preview scrolling
                  ["<C-i>"] = actions.preview_scrolling_up,
                  ["<C-u>"] = actions.preview_scrolling_down, -- disable this to clear the input box

                  -- select multiple
                  ["<C-a>"] = actions.toggle_all,
                  ["<C-BS>"] = actions.toggle_selection,
                  -- ["<C-w>h"] = actions.select_horizontal,
                  -- ["<C-w>v"] = actions.select_vertical,
                  -- ["<C-w>t"] = actions.select_tab,

                  ["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
                  ["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,

                  ["<C-q>"] = actions.send_selected_to_qflist + custom_actions.open_trouble_qflist,
                  ["<C-t>"] = trouble_telescope.open,
                  -- ["<C-d>"] = actions.delete_buffer, -- close buffer with Ctrl+d in insert mode
                  ["<C-p>"] = require("telescope.actions.layout").toggle_preview, -- toggle preview in telescope
                  ["<c-d>"] = { "<C-u>", type = "command" }, -- delete prompt in insert mode
               },
               n = {
                  ["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
                  ["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
                  ["<C-a>"] = actions.toggle_all,
                  ["<C-BS>"] = actions.toggle_selection,
               },
            },

            -- Telescope vertical view
            layout_strategy = "vertical",
            layout_config = {
               vertical = {
                  preview_cutoff = -1,
                  height = 0.9,
                  prompt_position = "bottom",
                  width = 0.8,
               },
            },
         },

         pickers = {
            live_grep = {
               -- disable_devicons = true, -- disable file icons
               file_ignore_patterns = { "node_modules", ".git" }, -- ignore these directories
               additional_args = function(_)
                  return { "--hidden" } -- include hidden files
               end,
            },

            find_files = {
               -- disable_devicons = true, -- disable file icons
               file_ignore_patterns = { "node_modules", ".git" },
               find_command = { "fd", "--type", "f", "--hidden", "--exclude", ".DS_Store" }, -- use fd instead of find
            },

            oldfiles = {
               -- disable_devicons = true, -- disable file icons
               file_ignore_patterns = { "node_modules", ".git" },
            },

            grep_string = {
               -- disable_devicons = true, -- disable file icons
               file_ignore_patterns = { "node_modules", ".git" },
            },

            buffers = {
               mappings = {
                  i = {
                     ["<C-d>"] = function(prompt_bufnr) -- custom mapping to delete buffer
                        local action_state = require("telescope.actions.state")
                        local current_picker = action_state.get_current_picker(prompt_bufnr)
                        local selected_entry = action_state.get_selected_entry()
                        local bufnr_to_delete = selected_entry.bufnr
                        -- Close the selected buffer
                        vim.api.nvim_buf_delete(bufnr_to_delete, { force = true })
                        -- Remove the entry from the Telescope picker
                        current_picker:delete_selection(function(selection)
                           return selection.bufnr == bufnr_to_delete
                        end)
                     end, -- Custom mapping to delete buffer
                  },

                  n = {
                     ["<C-d>"] = function(prompt_bufnr) -- custom mapping to delete buffer
                        local action_state = require("telescope.actions.state")
                        local current_picker = action_state.get_current_picker(prompt_bufnr)
                        local selected_entry = action_state.get_selected_entry()
                        local bufnr_to_delete = selected_entry.bufnr
                        -- Close the selected buffer
                        vim.api.nvim_buf_delete(bufnr_to_delete, { force = true })
                        -- Remove the entry from the Telescope picker
                        current_picker:delete_selection(function(selection)
                           return selection.bufnr == bufnr_to_delete
                        end)
                     end, -- Custom mapping to delete buffer
                  },
               },
            },
         },

         extensions = {
            file_browser = {
               -- disable_devicons = true, -- disable file icons
               file_ignore_patterns = { "node_modules", ".git", ".DS_Store" },
               hidden = { file_browser = false, folder_browser = false },
               prompt_path = true,
               mappings = {
                  i = {
                     ["<C-h>"] = fb_actions.goto_home_dir, -- go to home directory in file browsing
                     ["<C-S-h>"] = fb_actions.toggle_hidden, -- toggle hidden files in file browsing
                  },
               },
            },

            zoxide = {
               prompt_title = "[ Walking on the shoulders of TJ ]",
               mappings = {
                  default = {
                     after_action = function(selection)
                        print("Update to (" .. selection.z_score .. ") " .. selection.path)
                     end,
                  },
                  ["<C-s>"] = {
                     before_action = function(selection)
                        print("before C-s")
                     end,
                     action = function(selection)
                        vim.cmd.edit(selection.path)
                     end,
                  },
                  -- Opens the selected entry in a new split
                  ["<C-q>"] = { action = z_utils.create_basic_command("split") },
               },
            },
         },
      })

      telescope.load_extension("fzf")
      telescope.load_extension("file_browser")
      telescope.load_extension("zoxide")

      -- set keymaps
      local keymap = vim.keymap -- for conciseness

      keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Fuzzy find files in cwd" })
      keymap.set("n", "<leader>fr", "<cmd>Telescope oldfiles<cr>", { desc = "Fuzzy find recent files" })
      keymap.set("n", "<leader>fs", "<cmd>Telescope live_grep<cr>", { desc = "Find string in cwd" })
      keymap.set("n", "<leader>fg", "<cmd>Telescope grep_string<cr>", { desc = "Find string under cursor in cwd" })
      keymap.set("n", "<leader>fh", "<cmd>TodoTelescope<cr>", { desc = "Find todos" })

      -- my custom commands and keymaps

      vim.api.nvim_create_user_command("GrepOpenFiles", function()
         require("telescope.builtin").live_grep({ grep_open_files = true })
      end, {}) -- search with telecope in opened files

      keymap.set( -- search with telescope in current file
         "n",
         "<leader>fc",
         "<cmd>lua require('telescope.builtin').live_grep({search_dirs={vim.fn.expand('%:p')}})<CR>",
         { desc = "Find string in current file" }
      )
      keymap.set("n", "<leader>fb", "<cmd>Telescope buffers<cr>", { desc = "Show open buffers" })
   end,
}
