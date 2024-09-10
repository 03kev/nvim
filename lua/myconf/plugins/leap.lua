return {
   "ggandor/leap.nvim",
   vim.keymap.set("n", "m", "<Plug>(leap)"),
   vim.keymap.set("n", "M", "<Plug>(leap-from-window)"),
   vim.keymap.set({ "x", "o" }, "m", "<Plug>(leap-forward)"),
   vim.keymap.set({ "x", "o" }, "M", "<Plug>(leap-backward)"),
}
