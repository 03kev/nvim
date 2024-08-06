return {
  "gbprod/substitute.nvim",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local subs = require("substitute")

    subs.setup()

    local key = vim.keymap

    key.set("n", "s", subs.operator, { desc = "Substitute with motion" })
    key.set("n", "ss", subs.line, { desc = "Substitute line" })
    key.set("n", "S", subs.eol, { desc = "Substitute to end of line" })
    key.set("x", "s", subs.visual, { desc = "Substitute in visual mode" })
  end,
}
