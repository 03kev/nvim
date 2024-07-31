vim.g.mapleader = " "

local key = vim.keymap -- for conciseness

key.set("i", "jj", "<ESC>", { desc = "Exit insert mode with jj" })

key.set("n", "<leader>nh", ":nohl<CR>", { desc = "Clear search highlights" })

-- increment/decrement numbers
key.set("n", "<leader>+", "<C-a>", { desc = "Increment number" }) -- increment
key.set("n", "<leader>-", "<C-x>", { desc = "Decrement number" }) -- decrement

-- window management
key.set("n", "<leader>sv", "<C-w>v", { desc = "Split window vertically" }) -- split window vertically
key.set("n", "<leader>sh", "<C-w>s", { desc = "Split window horizontally" }) -- split window horizontally
key.set("n", "<leader>se", "<C-w>=", { desc = "Make splitted windows equal size" }) -- make split windows equal width & height
key.set("n", "<leader>sc", "<cmd>close<CR>", { desc = "Close current splitted window" }) -- close current split window
key.set("n", "<leader>sH", "<C-w>k<C-w>K", { desc = "Change split window view to horizontal" })
key.set("n", "<leader>sV", "<C-w>k<C-w>H", { desc = "Change split window view to vertical" })

key.set("n", "<leader>to", "<cmd>tabnew<CR>", { desc = "Open new tab" }) -- open new tab
key.set("n", "<leader>tc", "<cmd>tabclose<CR>", { desc = "Close current tab" }) -- close current tab
key.set("n", "<leader>tn", "<cmd>tabn<CR>", { desc = "Go to next tab" }) --  go to next tab
key.set("n", "<leader>tp", "<cmd>tabp<CR>", { desc = "Go to previous tab" }) --  go to previous tab
key.set("n", "<leader>tf", "<cmd>tabnew %<CR>", { desc = "Open current buffer in new tab" }) --  move current buffer to new tab

-- Move to tab by number with Option + number
key.set("n", "<M-1>", "1gt", { desc = "Move to tab 1" })
key.set("n", "<M-2>", "2gt", { desc = "Move to tab 2" })
key.set("n", "<M-3>", "3gt", { desc = "Move to tab 3" })
key.set("n", "<M-4>", "4gt", { desc = "Move to tab 4" })
key.set("n", "<M-5>", "5gt", { desc = "Move to tab 5" })
key.set("n", "<M-6>", "6gt", { desc = "Move to tab 6" })
key.set("n", "<M-7>", "7gt", { desc = "Move to tab 7" })
key.set("n", "<M-8>", "8gt", { desc = "Move to tab 8" })
key.set("n", "<M-9>", "9gt", { desc = "Move to tab 9" })

-- copy to system clipboard
key.set("n", "Y", '"+y', { desc = "Copy to system clipboard" }) -- normal mode
key.set("v", "Y", '"+y', { desc = "Copy to system clipboard" }) -- visual mode

-- text navigation
key.set("n", "<A-l>", "w", { noremap = true, silent = true, desc = "Move cursor left by word in normal mode" })
key.set("n", "<A-h>", "b", { noremap = true, silent = true, desc = "Move cursor right by word in normal mode" })
key.set("n", "9", "$", { noremap = true, silent = true, desc = "Move to the end of the line" })
key.set("i", "<A-BS>", "<C-w>", { noremap = true, silent = true, desc = "Delete previous word in insert mode" })

-- redo command with shift+u
key.set("n", "<S-u>", "<C-r>", { desc = "Redo command" })

-- from terminal to normal mode
key.set("t", "<ESC><ESC>", "<C-\\><C-n>", { noremap = true, desc = "Terminal to normal mode" })
key.set("t", "<ESC>", "<ESC>", { noremap = true, desc = "For lazygit, provisional" }) -- for lazygit, to improve

-- execute terminal command
key.set("n", "<leader><S-t>", ":Terminal<CR>", { desc = "Execute Terminal command" })

-- open lazygit in a new tmux window
key.set(
  "n",
  "<leader>lt",
  "<cmd>!tmux new-window -c " .. vim.fn.getcwd() .. " -- lazygit <CR><CR>",
  { desc = "Lazy git in new tmux window" }
) -- opens lazygit in a new tmux window
