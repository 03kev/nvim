--------------------------------------------- NVIM DEFAULT ---------------------------------------------

-- set colors to line numbers Above, Current and Below in this order
-- ! LineNr doesn't currently work even by setting it behind, it's managed by the colorscheme plugin
vim.api.nvim_set_hl(0, 'LineNrAbove', { fg='#484848', bold=false })
vim.api.nvim_set_hl(0, 'LineNr', { fg='#6DBF26', bold=false })
vim.api.nvim_set_hl(0, 'LineNrBelow', { fg='#484848', bold=false })

-- Set the visual mode background color
vim.cmd([[highlight Visual guibg=#2a2727 gui=none]])

-- Change the color of comments 
vim.api.nvim_set_hl(0, 'Comment', { fg = '#843D3A', italic = true })

-- Change the color of search results
vim.cmd('highlight Search guifg=#000000 guibg=#C7C7C7') -- search highlight
vim.cmd('highlight IncSearch guifg=#000000 guibg=#FFFFFF') -- incremental search highlight 
vim.cmd('highlight CurSearch guifg=#000000 guibg=#6DBF26') -- current search result highlight


--------------------------------------------- NVIM TREE ---------------------------------------------

-- color of the nvim-tree indent markers (the lines and dots before files and folders)
vim.cmd([[highlight NvimTreeIndentMarker guifg=#575757]])

-- set the color and make bold for closed folders
vim.cmd([[highlight NvimTreeFolderIcon guifg=#6f6f6f]])
vim.cmd([[highlight NvimTreeFolderName guifg=#6f6f6f gui=bold]])
-- set the color and make bold for opened folders
vim.cmd([[highlight NvimTreeOpenedFolderIcon guifg=#6f6f6f]])
vim.cmd([[highlight NvimTreeOpenedFolderName guifg=#6f6f6f gui=bold]])

-- Change the color of unstaged git icons to red
vim.api.nvim_set_hl(0, 'NvimTreeGitDirty', { fg = '#EC6A5E' })
-- Change the color of staged git icons to green
vim.api.nvim_set_hl(0, 'NvimTreeGitNew', { fg = '#6DBF26' })


--------------------------------------------- TELESCOPE ---------------------------------------------

-- set Telescope border color to green
vim.cmd([[highlight TelescopeBorder guifg=#6DBF26]])
-- set Telescope matching text color
vim.cmd([[highlight TelescopeMatching guifg=#6DBF26]])
-- set Telescope selection colors to ensure readability
-- vim.cmd([[highlight TelescopeSelection guifg=##EFEBDB guibg=#6DBF26]])


--------------------------------------------- INDENT BLANKLINE ---------------------------------------------

-- set the color of the indent line and scope line
vim.cmd([[highlight Indentlinecolor guifg=#242424]])
vim.cmd([[highlight Indentscopelinecolor guifg=#3b3b3b]])


--------------------------------------------- TOGGLETERM ---------------------------------------------

-- Set the background color for floating terminal windows (doesn't work)
vim.cmd([[highlight NormalFloat guibg=#101010]])
vim.cmd([[highlight FloatBorder guibg=#101010]])


---------------------------------------------  ---------------------------------------------
