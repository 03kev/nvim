local M = {}

function M.setup()
   local key = vim.keymap

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
end

return M
