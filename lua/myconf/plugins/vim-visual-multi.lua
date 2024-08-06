return {
  "mg979/vim-visual-multi",

  init = function()
    vim.g.VM_silent_exit = 1
    vim.g.VM_theme = ""

    vim.cmd("highlight highlightMatches guifg=#EFECDB guibg=#2a2a25")
    vim.g.VM_highlight_matches = "hi! link Search highlightMatches"

    vim.g.VM_mouse_mappings = 1
    vim.g.VM_default_mappings = 1
    vim.g.VM_maps = {
      ["Decrease"] = "",
    }
  end,

  config = function()
    -- vim.keymap.set("n", "<A-n>", "<Plug>(VM-Select-All)")
    -- vim.keymap.set("n", "<C-x>", "<Plug>(VM-Add-Cursor-At-Pos)")
  end,
}
