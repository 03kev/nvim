return {
   "nvim-tree/nvim-tree.lua",
   -- dependencies = "nvim-tree/nvim-web-devicons",
   config = function()
      local nvimtree = require("nvim-tree")
      local key = vim.keymap

      -- recommended settings from nvim-tree documentation
      vim.g.loaded_netrw = 1
      vim.g.loaded_netrwPlugin = 1

      local function custom_on_attach(bufnr)
         local api = require("nvim-tree.api")
         local function opts(desc)
            return {
               desc = "nvim-tree: " .. desc,
               buffer = bufnr,
               noremap = true,
               silent = true,
               nowait = true,
            }
         end
         api.config.mappings.default_on_attach(bufnr) -- load default mappings

         key.del("n", "<C-]>", { buffer = bufnr })
         key.set("n", "<S-CR>", api.tree.change_root_to_node, opts("CD"))
         key.set("n", "<S-BS>", api.tree.change_root_to_parent, opts("Up"))
         key.set("n", "h", api.node.navigate.parent_close, opts("Up"))
         key.set("n", "l", api.node.open.edit, opts("Up"))
      end

      nvimtree.setup({
         on_attach = custom_on_attach,

         view = {
            width = 35,
            relativenumber = true,
         },

         update_cwd = true, -- update nvim-tree root to cwd
         update_focused_file = { -- update the focused file on `nvim-tree`
            enable = true,
            -- update_cwd = true, -- if the file is not under the root, update the cwd and nvim-tree to the root
         },

         renderer = {
            add_trailing = true,
            indent_width = 2,
            full_name = true,
            root_folder_label = function()
               return "../"
            end,
            indent_markers = {
               enable = true,
            },
            icons = {
               show = {
                  file = false,
                  folder = false,
                  git = true,
                  hidden = false,
               },
               glyphs = {
                  folder = {
                     arrow_closed = "\u{2013}", -- closed folder
                     arrow_open = "\u{00B7}", -- opened folder
                     default = "", -- icon for closed folders
                     open = "", -- icon for opened folders
                  },
                  git = {
                     unstaged = "✗",
                     staged = "✓",
                     unmerged = "",
                     renamed = "➜",
                     untracked = "?",
                     deleted = "-",
                     ignored = "◌",
                  },
               },
            },
         },

         -- disable window_picker for explorer to work well with window splits
         actions = {
            open_file = {
               window_picker = {
                  enable = false,
               },
            },
         },
         filters = {
            custom = { ".DS_Store", "node_modules", ".git" },
         },
         git = {
            ignore = false,
         },
      })

      -- set keymaps
      key.set("n", "<leader>ee", "<cmd>NvimTreeToggle<CR>", { desc = "Toggle file explorer" }) -- toggle file explorer
      key.set("n", "<leader>ef", "<cmd>NvimTreeFocus<CR>", { desc = "Focus file explorer" }) -- toggle file explorer on current file
      -- key.set("n", "<leader>ec", "<cmd>NvimTreeCollapse<CR>", { desc = "Collapse file explorer" }) -- collapse file explorer
      key.set("n", "<leader>er", "<cmd>NvimTreeRefresh<CR>", { desc = "Refresh file explorer" }) -- refresh file explorer
      key.set(
         "n",
         "<leader>et",
         "<cmd>NvimTreeFindFile<CR>",
         { noremap = true, silent = true, desc = "Find file in file explorer" }
      )
   end,
}
