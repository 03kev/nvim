local hl = vim.api.nvim_set_hl

-- colors
local black1 = "#10100F"
local line = "#1D1D19"
local white1 = "#EFECDB"
local grey1 = "#A7A691"
local grey2 = "#3F3F39"
local comment = "#996645"
local green1 = "#88BF39"
local orange1 = "#BF7F26"
local blue1 = "#1639E6"
local dark1 = "#7F7820"
local test1 = "#FF00FF"
local test2 = "#00FFFF"
local lime1 = "#AABF26"
local yellow1 = "#C2AA22"
local err = "#B4837F"
local pink1 = "#B2598B"

-- nvim default

-- set colors to line numbers Above, Current and Below in this order
hl(0, "LineNrAbove", { fg = "#484848", bold = false })
hl(0, "LineNr", { fg = green1, bold = false }) -- doesn't work
hl(0, "LineNrBelow", { fg = "#484848", bold = false })

-- Set the visual mode background color
vim.cmd([[highlight Visual guibg=#2a2727 gui=none]])

-- Change the color of comments
hl(0, "Comment", { fg = "#843D3A", italic = true })

-- Change the color of search results
vim.cmd("highlight Search guifg=#DDDDDD guibg=#575757") -- search highlight
vim.cmd("highlight IncSearch guifg=#000000 guibg=#F1F1F1") -- incremental search highlight
vim.cmd("highlight CurSearch guifg=#000000 guibg=#6DBF26") -- current search result highlight

-- Change the color of the cursor
vim.opt.guicursor = {
  "n-v-c-sm:block-Cursor/lCursor",
  "i-ci-ve:ver25-CursorInsert",
  "r-cr-o:hor20",
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
vim.cmd([[
  highlight NvimTreeGitDirtyIcom guifg=#6183BB
  highlight NvimTreeGitStagedIcon guifg=#6183BB
  highlight NvimTreeGitMergeIcon guifg=#6183BB
  highlight NvimTreeGitRenamedIcon guifg=#6183BB
  highlight NvimTreeGitNewIcon guifg=#6183BB
  highlight NvimTreeGitDeletedIcon guifg=#6183BB
  highlight NvimTreeGitIgnoredIcon guifg=#6183BB
]])

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

hl(0, "Error", { fg = err })

hl(0, "DiagnosticError", { fg = err, bg = black1 })
hl(0, "DiagnosticWarn", { fg = err, bg = black1 })
hl(0, "DiagnosticInfo", { fg = err, bg = black1 })
hl(0, "DiagnosticHint", { fg = err, bg = black1 })

hl(0, "LazyGitFloat", { fg = grey1 })
hl(0, "LazyGitBorder", { fg = grey2 })

hl(0, "DiagnosticVirtualTextError", { fg = err, bg = black1 })
hl(0, "DiagnosticVirtualTextWarn", { fg = err, bg = black1 })
hl(0, "DiagnosticVirtualTextInfo", { fg = err, bg = black1 })
hl(0, "DiagnosticVirtualTextHint", { fg = err, bg = black1 })
hl(0, "DiagnosticUnused", { fg = err, bg = black1 })
