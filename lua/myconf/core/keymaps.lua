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

-- system clipboard
key.set({ "n", "v" }, "Y", '"+y', { desc = "Yank to sys clipboard" })
key.set("n", "<S-p>", '"+p"', { desc = "Paste from sys clipboard" })

-- text navigation
key.set("n", "<A-l>", "w", { noremap = true, silent = true, desc = "Move cursor left by word in normal mode" })
key.set("n", "<A-h>", "b", { noremap = true, silent = true, desc = "Move cursor right by word in normal mode" })
-- key.set("n", "9", "$", { noremap = true, silent = true, desc = "Move to the end of the line" })
key.set("i", "<A-BS>", "<C-w>", { noremap = true, silent = true, desc = "Delete previous word in insert mode" })

-- redo command with shift+u
key.set("n", "<S-u>", "<C-r>", { desc = "Redo command" })

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

-- execute terminal command
key.set("n", "<leader><S-t>", ":Terminal<CR>", { desc = "Execute Terminal command" })

-- open lazygit in a new tmux window
key.set(
  "n",
  "<leader>lt",
  "<cmd>!tmux new-window -c " .. vim.fn.getcwd() .. " -- lazygit <CR><CR>",
  { desc = "Lazy git in new tmux window" }
) -- opens lazygit in a new tmux window

--

-- Define the InsertFilePathIntoCmdLine function
function InsertFilePathIntoCmdLine()
  local file_path = vim.fn.expand("%:p")
  -- Insert the file path
  vim.api.nvim_feedkeys(": " .. file_path, "n", true)
  -- Move the cursor to the beginning of the inserted file path
  for _ = 1, #file_path + 2 do
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Left>", true, false, true), "n", true)
  end
end
-- Set the key mapping
vim.api.nvim_set_keymap("n", "<leader>:", ":lua InsertFilePathIntoCmdLine()<CR>", { noremap = true, silent = false })

--

-- Lazy scrolling
local function lazy(keys)
  keys = vim.api.nvim_replace_termcodes(keys, true, false, true)
  return function()
    local old = vim.o.lazyredraw
    vim.o.lazyredraw = true
    vim.api.nvim_feedkeys(keys, "nx", false)
    vim.o.lazyredraw = old
  end
end
-- Set the key mapping for lazy function
vim.keymap.set("n", "<c-d>", lazy("<c-d>zz"), { desc = "Scroll down half screen" })
vim.keymap.set("n", "<c-u>", lazy("<c-u>zz"), { desc = "Scroll up half screen" })

-- vim.keymap.set("n", "<A-j>", "<c-e>", { desc = "Scroll down screen" })
-- vim.keymap.set("n", "<A-k>", "<c-y>", { desc = "Scroll up screen" })


-- Special G keymap

-- Function to check if there is a gap between the last line of the file and the bottom of the screen
local function has_gap()
    local last_line = vim.fn.line('$')
    local screen_height = vim.fn.winheight(0)
    local cursor_line = vim.fn.line('.')
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
vim.api.nvim_create_autocmd({"BufEnter", "WinEnter", "CursorMoved"}, {
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
