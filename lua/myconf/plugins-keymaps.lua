local key = vim.keymap -- for conciseness

-- open command line with current buffer's path
local function opts(desc)
  return {
    desc = 'nvim-tree: ' .. desc,
    buffer = bufnr,
    noremap = true,
    silent = true,
    nowait = true,
  }
end
local api = require('nvim-tree.api')
-- key.set('n', '<leader>.', api.node.run.cmd, opts('Run Command'))
