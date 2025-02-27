return {
  "nvim-tree/nvim-tree.lua",
  -- dependencies = "nvim-tree/nvim-web-devicons",
  config = function()
    local nvimtree = require("nvim-tree")

    -- recommended settings from nvim-tree documentation
    vim.g.loaded_netrw = 1
    vim.g.loaded_netrwPlugin = 1

    nvimtree.setup({
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

    -- set shift+enter to cd into directory in nvim tree gui
    local function opts(desc)
      return {
        desc = 'nvim-tree: ' .. desc,
        buffer = bufnr,
        noremap = true,
        silent = true,
        nowait = true,
      }
    end
    local api = require('nvim-tree.api')
    vim.keymap.set('n', '<S-CR>', api.tree.change_root_to_node, opts('CD'))
    vim.keymap.set('n', '<S-BS>', api.tree.change_root_to_parent, opts('Up'))

    -- set keymaps
    local key = vim.keymap

    key.set("n", "<leader>ee", "<cmd>NvimTreeToggle<CR>", { desc = "Toggle file explorer" }) -- toggle file explorer
    key.set("n", "<leader>ef", "<cmd>NvimTreeFindFileToggle<CR>", { desc = "Toggle file explorer on current file" }) -- toggle file explorer on current file
    key.set("n", "<leader>ec", "<cmd>NvimTreeCollapse<CR>", { desc = "Collapse file explorer" }) -- collapse file explorer
    key.set("n", "<leader>er", "<cmd>NvimTreeRefresh<CR>", { desc = "Refresh file explorer" }) -- refresh file explorer
    key.set('n', '<leader>et', ':NvimTreeFindFile<CR>', { noremap = true, silent = true })
    
  end,
}
