local M = {}

local function with_preserved_registers(fn)
   local saved_unnamed = vim.fn.getreg('"')
   local saved_unnamed_type = vim.fn.getregtype('"')
   local saved_zero = vim.fn.getreg("0")
   local saved_zero_type = vim.fn.getregtype("0")

   fn()

   vim.fn.setreg('"', saved_unnamed, saved_unnamed_type)
   vim.fn.setreg("0", saved_zero, saved_zero_type)
end

function M.setup()
   local key = vim.keymap

   key.set("n", "<leader>nh", ":nohl<CR>", { desc = "Clear search highlights" })

   key.set("n", "<c-a>", "ggVG$", { desc = "Select all" })
   key.set("i", "<c-a>", "<Esc>ggVG$", { desc = "Select all" })

   -- move lines
   key.set("n", "<M-u>", ":m .+1<CR>==", { desc = "Move line down" })
   key.set("n", "<M-i>", ":m .-2<CR>==", { desc = "Move line up" })
   key.set("v", "<M-u>", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
   key.set("v", "<M-i>", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

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
   key.set("n", "Y", function()
      with_preserved_registers(function()
         vim.cmd.normal({ args = { '"+yy' }, bang = true })
      end)
   end, { desc = "Yank to sys clipboard" })
   key.set("x", "Y", function()
      with_preserved_registers(function()
         vim.cmd.normal({ args = { '"+y' }, bang = true })
      end)
   end, { desc = "Yank to sys clipboard" })
   key.set({ "n", "v" }, "<S-p>", '"+p', { desc = "Paste from sys clipboard" })

   key.set({ "v" }, "\\d", '"_d', { desc = "Delete without yank" })
   key.set("x", "\\p", '"_dP', { desc = "Paste without yank" })
   key.set("x", "\\P", '"_d"+P', { desc = "Paste replace from sys" })

   -- select last pasted text
   key.set("n", "gp", "`[v`]", { noremap = true, desc = "Select last pasted text" })

   -- text navigation
   key.set("i", "<A-BS>", "<C-w>", { noremap = true, silent = true, desc = "Delete previous word in insert mode" })
   -- key.set("n", "J", "jj", { noremap = true, silent = true, desc = "Move down" })
   -- key.set("n", "K", "kk", { noremap = true, silent = true, desc = "Move up" })

   key.set("n", "<S-u>", "<C-r>", { desc = "Redo" })

   key.set("n", "\\r", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], { desc = "Replace word under cursor" })
end

return M
