return {
   "mrjones2014/smart-splits.nvim",
   config = function()
      local smart_splits = require("smart-splits")

      require("smart-splits").setup({
         ignored_buftypes = {
            "nofile",
            "quickfix",
            "prompt",
         },
         ignored_filetypes = {
            "NvimTree",
         },

         default_amount = 3,
         at_edge = "split",
         float_win_behavior = "previous",
         move_cursor_same_row = false,
         cursor_follows_swapped_bufs = true,

         resize_mode = {
            quit_key = "<ESC>",
            resize_keys = { "h", "j", "k", "l" },
            silent = false,
            hooks = {
               on_enter = nil,
               on_leave = nil,
            },
         },
         ignored_events = {
            "BufEnter",
            "WinEnter",
         },
         multiplexer_integration = nil,
         disable_multiplexer_nav_when_zoomed = true,
         kitty_password = nil,
         log_level = "info",
      })

      local key = vim.keymap

      key.set("n", "<A-h>", smart_splits.resize_left)
      key.set("n", "<A-j>", smart_splits.resize_down)
      key.set("n", "<A-k>", smart_splits.resize_up)
      key.set("n", "<A-l>", smart_splits.resize_right)
      -- moving between splits
      key.set("n", "<C-h>", smart_splits.move_cursor_left)
      key.set("n", "<C-j>", smart_splits.move_cursor_down)
      key.set("n", "<C-k>", smart_splits.move_cursor_up)
      key.set("n", "<C-l>", smart_splits.move_cursor_right)
      key.set("n", "<C-\\>", smart_splits.move_cursor_previous)
      key.set("n", "<C-c>", "<C-w>c")
      -- swapping buffers between windows
      key.set("n", "<leader><leader>h", smart_splits.swap_buf_left)
      key.set("n", "<leader><leader>j", smart_splits.swap_buf_down)
      key.set("n", "<leader><leader>k", smart_splits.swap_buf_up)
      key.set("n", "<leader><leader>l", smart_splits.swap_buf_right)
   end,
}
