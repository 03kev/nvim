vim.g.mapleader = " "

local key = vim.keymap

key.set("n", "<leader>nh", ":nohl<CR>", { desc = "Clear search highlights" })

key.set("n", "<c-a>", "ggVG", { desc = "Select all" })
key.set("i", "<c-a>", "<Esc>ggVG", { desc = "Select all" })

key.set("n", "<Tab>", "a<Tab><Esc>", { noremap = true, silent = true }) -- same as <c-i>

-- move lines
key.set("n", "<M-u>", ":m .+1<CR>==", { desc = "Move line down" })
key.set("n", "<M-i>", ":m .-2<CR>==", { desc = "Move line up" })
key.set("v", "<C-M-u>", ":m '>+1<CR>gv=gv", { desc = "Move slection down" })
key.set("v", "<C-M-i>", ":m '<-2<CR>gv=gv", { desc = "Move slection up" })

-- window management
key.set("n", "<leader>sv", "<C-w>v", { desc = "Split window vertically" })
key.set("n", "<leader>sh", "<C-w>s", { desc = "Split window horizontally" })
key.set("n", "<leader>se", "<C-w>=", { desc = "Make splitted windows equal size" })
key.set("n", "<leader>sc", "<cmd>close<CR>", { desc = "Close current splitted window" })
key.set("n", "<leader>sH", "<C-w>k<C-w>K", { desc = "Change split window view to horizontal" })
key.set("n", "<leader>sV", "<C-w>k<C-w>H", { desc = "Change split window view to vertical" })

key.set("n", "<leader>to", "<cmd>tabnew<CR>", { desc = "Open new tab" })
key.set("n", "<leader>tc", "<cmd>tabclose<CR>", { desc = "Close current tab" })
key.set("n", "<leader>tn", "<cmd>tabn<CR>", { desc = "Go to next tab" })
key.set("n", "<leader>tp", "<cmd>tabp<CR>", { desc = "Go to previous tab" })
key.set("n", "<leader>tf", "<cmd>tabnew %<CR>", { desc = "Open current buffer in new tab" })

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

-- add line in normal mode
key.set("n", "gO", "<Cmd>call append(line('.') - 1, repeat([''], v:count1))<CR>", { desc = "Add line above" })
key.set("n", "go", "<Cmd>call append(line('.'),     repeat([''], v:count1))<CR>", { desc = "Add line below" })

-- system clipboard
key.set({ "n", "v" }, "Y", '"+y', { desc = "Yank to sys clipboard" })
key.set({ "n", "v" }, "<M-S-y>", '"+y$', { desc = "Yank to sys clipboard to end of line" })
key.set({ "n", "v" }, "<M-y>", "y$", { desc = "Yank to end of line" })
key.set({ "n", "v" }, "<S-p>", '"+p"', { desc = "Paste from sys clipboard" })

key.set({ "n", "v" }, "<leader>d", '"_d', { desc = "Delete without yank" })
key.set("x", "<leader>p", '"_dP', { desc = "Paste without yank" })
key.set("x", "<leader>P", '"_d"+P', { desc = "Paste replace from sys" })

-- select last pasted text
key.set("n", "gp", "`[v`]", { noremap = true, desc = "Select last pasted text" })

-- text navigation
key.set("i", "<A-BS>", "<C-w>", { noremap = true, silent = true, desc = "Delete previous word in insert mode" })
key.set("n", "J", "jj", { noremap = true, silent = true, desc = "Move down" }) -- this replaces the default join line
key.set("n", "K", "kk", { noremap = true, silent = true, desc = "Move up" })

-- redo command with shift+u
key.set("n", "<S-u>", "<C-r>", { desc = "Redo" })

--

-- from terminal to normal mode (not in lazygit)
vim.api.nvim_create_autocmd("TermOpen", {
   pattern = "*",
   callback = function()
      if vim.fn.expand("%:t") ~= "lazygit" and vim.bo.buftype == "terminal" and vim.bo.filetype ~= "lazygit" then
         vim.api.nvim_buf_set_keymap(
            0,
            "t",
            "<ESC><ESC>",
            "<C-\\><C-n>",
            { noremap = true, desc = "Terminal to normal mode" }
         )
      end
   end,
})

key.set("n", "<leader><S-t>", ":Terminal<CR>", { desc = "Execute Terminal command" })

key.set(
   "n",
   "<leader>lt",
   "<cmd>!tmux new-window -c " .. vim.fn.getcwd() .. " -- lazygit <CR><CR>",
   { desc = "Lazy git in new tmux window" }
) -- opens lazygit in a new tmux window

function InsertFilePathIntoCmdLine()
   local file_path = vim.fn.expand("%:p")
   -- Insert the file path
   vim.api.nvim_feedkeys(": " .. file_path, "n", true)
   -- Move the cursor to the beginning of the inserted file path
   for _ = 1, #file_path + 2 do
      vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Left>", true, false, true), "n", true)
   end
end
key.set("n", "<leader>:", ":lua InsertFilePathIntoCmdLine()<CR>", { noremap = true, silent = false })

-- Special G keymap

-- Function to check if there is a gap between the last line of the file and the bottom of the screen
local function has_gap()
   local last_line = vim.fn.line("$")
   local screen_height = vim.fn.winheight(0)
   local cursor_line = vim.fn.line(".")
   return (last_line - cursor_line) < screen_height
end

-- Function to update the keymap based on the gap
local function update_keymap()
   local buftype = vim.bo.buftype
   local filetype = vim.bo.filetype
   if buftype == "" and not has_gap() then
      vim.api.nvim_buf_set_keymap(0, "n", "G", "G<c-e><c-e>", { noremap = true, silent = true, desc = "Last line" })
   else
      pcall(vim.api.nvim_buf_del_keymap, 0, "n", "G") -- normal mode G in special buffer or if there is a gap
   end
end

-- Special G keymap for normal files
vim.api.nvim_create_autocmd({ "BufEnter", "WinEnter", "CursorMoved" }, {
   pattern = "*",
   callback = update_keymap,
})

vim.api.nvim_create_autocmd("TermOpen", { -- normal mode G in terminal
   pattern = "*",
   callback = function()
      vim.api.nvim_buf_set_keymap(0, "n", "G", "G", { noremap = true, silent = true, desc = "Last line" })
   end,
})

-- Handle the case when Neovim is first opened with NvimTree or other special buffers
vim.api.nvim_create_autocmd("VimEnter", {
   pattern = "*",
   callback = update_keymap,
})

-- Remove the special keymap when leaving the window
vim.api.nvim_create_autocmd("WinLeave", {
   pattern = "*",
   callback = function()
      pcall(vim.api.nvim_buf_del_keymap, 0, "n", "G")
   end,
})

-- disable arrow keys and mouse
key.set("n", "<ScrollWheelUp>", "")
key.set("n", "<S-ScrollWheelUp>", "")
key.set("n", "<C-ScrollWheelUp>", "")
key.set("n", "<ScrollWheelDown>", "")
key.set("n", "<S-ScrollWheelDown>", "")
key.set("n", "<C-ScrollWheelDown>", "")
key.set("n", "<ScrollWheelLeft>", "")
key.set("n", "<S-ScrollWheelLeft>", "")
key.set("n", "<C-ScrollWheelLeft>", "")
key.set("n", "<ScrollWheelRight>", "")
key.set("n", "<S-ScrollWheelRight>", "")
key.set("n", "<C-ScrollWheelRight>", "")
vim.opt.mouse = ""
key.set("n", "<Up>", "")
key.set("n", "<Down>", "")
key.set("n", "<Left>", "")
key.set("n", "<Right>", "")
key.set("v", "<Up>", "")
key.set("v", "<Down>", "")
key.set("v", "<Left>", "")
key.set("v", "<Right>", "")
key.set("i", "<Up>", "")
key.set("i", "<Down>", "")
key.set("i", "<Left>", "")
key.set("i", "<Right>", "")
