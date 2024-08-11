return {
   "mg979/vim-visual-multi",
   init = function()
      vim.g.VM_silent_exit = 1
      vim.g.VM_theme = ""
      vim.g.VM_show_warnings = 0 -- disable warnings
      vim.g.VM_highlight_matches = "hi! link Search VM_Match" -- VM_Match defined in theme.lua

      vim.g.VM_mouse_mappings = 1 -- enable mouse mappings
      vim.g.VM_default_mappings = 0 -- disable default mappings

      vim.g.VM_leader = { default = "\\", visual = "\\", buffer = "z" }
      vim.g.VM_maps = {
         -- default mappings
         ["Exit"] = "<Esc>",
         ["Find Under"] = "<C-n>",
         ["Find Subword Under"] = "<C-n>",
         ["Add Cursor Down"] = "<C-Down>",
         ["Add Cursor Up"] = "<C-Up>",
         ["Select All"] = "\\A",
         ["Start Regex Search"] = "\\/",
         ["Add Cursor At Pos"] = "\\\\",
         ["Reselect Last"] = "\\gS",

         ["Mouse Cursor"] = "<C-LeftMouse>",
         ["Mouse Word"] = "<C-RightMouse>",
         ["Mouse Column"] = "<M-C-RightMouse>",

         -- visual mode mappings
         ["Visual All"] = "\\A",
         ["Visual Regex"] = "\\/",
         ["Visual Find"] = "\\f",
         ["Visual Cursors"] = "\\c",
         ["Visual Add"] = "\\a",
         ["Visual Subtract"] = "\\s", -- buffer mapping
         ["Visual Reduce"] = "\\r", -- buffer mapping

         -- buffer mappings
         ["Find Next"] = "n",
         ["Find Prev"] = "N",
         ["Goto Next"] = "]",
         ["Goto Prev"] = "[",
         ["Seek Next"] = "<C-f>",
         ["Seek Prev"] = "<C-b>",
         ["Skip Region"] = "q",
         ["Remove Region"] = "Q",
         ["Slash Search"] = "g/",
         ["Replace"] = "R",
         ["Toggle Multiline"] = "M",
         -- extended mode
         ["Surround"] = "S", -- requires vim-surround plugin
         ["Move Right"] = "<M-S-Right>",
         ["Move Left"] = "<M-S-Left>",
         -- insert mode and single region mode
         ["Next"] = "<Tab>",
         ["Prev"] = "<S-Tab>",

         -- operators
         ["Select Operator"] = "s",
         ["Find Operator"] = "m",

         -- special commands
         ["Increase"] = "<C-A>",
         ["Decrease"] = "<C-X>",
         ["gIncrease"] = "g<C-A>",
         ["gDecrease"] = "g<C-X>",
         ["Alpha-Increase"] = "\\<C-A>",
         ["Alpha-Decrease"] = "\\<C-X>",

         -- commands
         ["Transpose"] = "\\t",
         ["Align"] = "\\a",
         ["Align Char"] = "\\<",
         ["Align Regex"] = "\\>",
         ["Split Regions"] = "\\s",
         ["Filter Regions"] = "\\f",
         ["Transform Regions"] = "\\e",
         ["Rewrite Last Search"] = "\\r",
         ["Merge Regions"] = "\\m",
         ["Duplicate"] = "\\d",
         ["Shrink"] = "\\-",
         ["Enlarge"] = "\\+",
         ["One Per Line"] = "\\L",
         ["Numbers"] = "\\n",
         ["Numbers Append"] = "\\N",
         ["Run Normal"] = "\\z",
         ["Run Visual"] = "\\v",
         ["Run Ex"] = "\\x",
         ["Run Last Normal"] = "\\Z",
         ["Run Last Visual"] = "\\V",
         ["Run Last Ex"] = "\\X",
         ["Run Macro"] = "\\@",

         -- options and menus
         ["Tools Menu"] = "\\`",
         ["Case Conversion Menu"] = "\\C",
         ["Show Registers"] = '\\"',
         ["Toggle Whole Word"] = "\\w",
         ["Case Setting"] = "\\c",
         ["Toggle Mappings"] = "\\<Space>",
         ["Toggle Single Region"] = "\\<CR>",
      }
   end,

   config = function()
      -- vim.keymap.set("n", "<A-n>", "<Plug>(VM-Select-All)")
      -- vim.keymap.set("n", "<C-x>", "<Plug>(VM-Add-Cursor-At-Pos)")
   end,
}
