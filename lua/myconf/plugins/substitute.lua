return {
   "gbprod/substitute.nvim",
   event = { "BufReadPre", "BufNewFile" },
   config = function()
      local substitute = require("substitute")
      substitute.setup()

      local key = vim.keymap
      key.set("n", "s", substitute.operator, { desc = "Substitute with motion" })
      key.set("n", "ss", substitute.line, { desc = "Substitute line" })
      key.set("n", "S", substitute.eol, { desc = "Substitute to end of line" })
      key.set("x", "s", substitute.visual, { desc = "Substitute in visual mode" })
   end,
}
