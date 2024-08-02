return {
  "github/copilot.vim",

  config = function()
    -- accept copilot suggestions with <Tab> in copilot-chat buffer
    vim.api.nvim_create_autocmd("BufEnter", {
      pattern = "copilot-chat",
      callback = function()
        vim.api.nvim_buf_set_keymap(0, "i", "<Tab>", 'copilot#Accept("\\<CR>")', {
          expr = true,
          noremap = true,
          silent = true,
          replace_keycodes = false,
        })
      end,
    })
  end,
}
