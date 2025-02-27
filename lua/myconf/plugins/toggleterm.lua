return {
  'akinsho/toggleterm.nvim',
  config = function()
   
    function _G.set_terminal_keymaps(term)
      local opts = { noremap = true }
      if term.cmd ~= 'lazygit' then
        vim.api.nvim_buf_set_keymap(term.bufnr, 't', '<ESC><ESC>', [[<C-\><C-n>]], opts)
      end
      vim.api.nvim_buf_set_keymap(term.bufnr, 't', 'jk', [[<C-\><C-n>]], opts)
      vim.api.nvim_buf_set_keymap(term.bufnr, 't', '<C-h>', [[<C-\><C-n><C-W>h]], opts)
      vim.api.nvim_buf_set_keymap(term.bufnr, 't', '<C-j>', [[<C-\><C-n><C-W>j]], opts)
      vim.api.nvim_buf_set_keymap(term.bufnr, 't', '<C-k>', [[<C-\><C-n><C-W>k]], opts)
      vim.api.nvim_buf_set_keymap(term.bufnr, 't', '<C-l>', [[<C-\><C-n><C-W>l]], opts)
    end
    
    require('toggleterm').setup({
      on_open = set_terminal_keymaps,
    })
    
    local Terminal = require('toggleterm.terminal').Terminal
    
    function _lazygit_toggle()
      local lazygit = Terminal:new({
        cmd = 'lazygit',
        direction = 'float',
        cwd = function()
          return vim.fn.getcwd()
        end,
        float_opts = {
          border = 'double',
        },
        -- function to run on opening the terminal
        on_open = function(term)
          vim.cmd('startinsert!')
          vim.api.nvim_buf_set_keymap(term.bufnr, 'n', 'q', '<cmd>close<CR>', { noremap = true, silent = true })
        end,
        -- function to run on closing the terminal
        on_close = function(term)
          vim.cmd('startinsert!')
        end,
      })
      lazygit:open()
    end

    -- local key = vim.keymap
    -- key.set('n', 'tt', '<cmd>ToggleTerm<CR>', {noremap = true, silent = true, desc = 'Toggle Terminal'}),

  end,

  keys = {
    {
      '<Space>g',
      function()
        _lazygit_toggle()
      end,
      desc = 'LazyGit',
    },
  },
  cmd = 'ToggleTerm',

}
