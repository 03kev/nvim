--------------------------------------------- NVIM DEFAULT ---------------------------------------------

-- set colors to line numbers Above, Current and Below in this order
-- ! LineNr doesn't currently work even by setting it behind, it's managed by the colorscheme plugin
vim.api.nvim_set_hl(0, "LineNrAbove", { fg = "#484848", bold = false })
vim.api.nvim_set_hl(0, "LineNr", { fg = "#6DBF26", bold = false })
vim.api.nvim_set_hl(0, "LineNrBelow", { fg = "#484848", bold = false })

-- Set the visual mode background color
vim.cmd([[highlight Visual guibg=#2a2727 gui=none]])

-- Change the color of comments
vim.api.nvim_set_hl(0, "Comment", { fg = "#843D3A", italic = true })

-- Change the color of search results
vim.cmd("highlight Search guifg=#DDDDDD guibg=#575757") -- search highlight
vim.cmd("highlight IncSearch guifg=#000000 guibg=#F1F1F1") -- incremental search highlight
vim.cmd("highlight CurSearch guifg=#000000 guibg=#6DBF26") -- current search result highlight

-- Change the color of the cursor
vim.opt.guicursor = {
  "n-v-c-sm:block-Cursor/lCursor",
  "i-ci-ve:ver25-CursorInsert",
  "r-cr-o:hor20"
}

-- cursor, line cursor, insert cursor, terminal cursor, terminal cursor not focused
vim.cmd([[
  highlight Cursor guifg=NONE guibg=#c7c7c7 gui=nocombine
  highlight lCursor guifg=NONE guibg=#c7c7c7 gui=nocombine
  highlight CursorInsert guifg=NONE guibg=#c7c7c7 gui=nocombine
  highlight TermCursor guifg=#c7c7c7 guibg=#1f1f1f
  highlight TermCursorNC guifg=#1a1a1a guibg=#515151
]])


--------------------------------------------- NVIM TREE ---------------------------------------------

-- color of the nvim-tree indent markers (the lines and dots before files and folders)
vim.cmd([[highlight NvimTreeIndentMarker guifg=#575757]])

-- set the color and make bold for closed folders
vim.cmd([[highlight NvimTreeFolderIcon guifg=#6f6f6f]])
vim.cmd([[highlight NvimTreeFolderName guifg=#6f6f6f gui=bold]])
-- set the color and make bold for opened folders
vim.cmd([[highlight NvimTreeOpenedFolderIcon guifg=#6f6f6f]])
vim.cmd([[highlight NvimTreeOpenedFolderName guifg=#6f6f6f gui=bold]])

-- set the color of the git icons
    vim.cmd [[
      highlight NvimTreeGitDirty guifg=#6183BB
      highlight NvimTreeGitStaged guifg=#6183BB
      highlight NvimTreeGitMerge guifg=#6183BB
      highlight NvimTreeGitRenamed guifg=#6183BB
      highlight NvimTreeGitNew guifg=#6183BB
      highlight NvimTreeGitDeleted guifg=#6183BB
      highlight NvimTreeGitIgnored guifg=#6183BB
    ]]

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
