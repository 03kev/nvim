local hl = vim.api.nvim_set_hl
local cmd = vim.cmd

local color_utils = require("myconf.color_utils")
local bright = color_utils.adjust_brightness

-- colors
local black1 = "#10100F"
local pitchblack = "#000000"
local white1 = "#EFECDB"
local white2 = "#DFDFDF"
local purewhite = "#FFFFFF"
local grey1 = "#484848"
local grey2 = "#5f5e56"
local grey3 = "#3F3F39"

local green1 = "#88BF39"
local orange1 = "#BF7F26"
local red1 = "#AB4E4E"
local blue1 = "#1639E6"
local blue2 = "#6183BB"
local pink1 = "#B2598B"
local lime1 = "#AABF26"
local yellow1 = "#C2AA22"

local test1 = "#FF00FF"
local test2 = "#00FFFF"
local test3 = "#FFFF00"

local line = "#1D1D19"
local visual = "#37362f"
-- local comment = "#996645"
local comment = "#825c44"
local cursor = "#c7c7c7"

-- default --

hl(0, "WinbarColor", { fg = grey2 }) -- winbar text
hl(0, "WinSeparator", { fg = grey2 }) -- winbar separator

hl(0, "LineNrAbove", { fg = grey1, bold = false }) -- line number above the current line
hl(0, "LineNr", { fg = green1, bold = false }) -- current line number
hl(0, "LineNrBelow", { fg = grey1, bold = false }) -- line number below the current line

hl(0, "CursorLine", { bg = line }) -- current line
hl(0, "Visual", { bg = visual, fg = "none" }) -- visual mode
hl(0, "Comment", { fg = comment, italic = true })

hl(0, "Search", { fg = white1, bg = grey2 }) -- search
hl(0, "IncSearch", { fg = black1, bg = purewhite }) -- incremental current search result
cmd([[highlight link CurSearch IncSearch]]) -- current search
-- nvim-hlslens
hl(0, "HlSearchLens", { fg = white1, bg = bright(grey2, 0.3) }) -- search lens
cmd([[highlight link HlSearchNear CurSearch]]) -- this ovverrides the default current search
cmd([[highlight link HlSearchLensNear CurSearch]]) -- current search lens
-- vim-visual-multi
hl(0, "VM_Extend", { fg = black1, bg = purewhite }) -- selection when extending
hl(0, "VM_Mono", { fg = black1, bg = bright(cursor, 0.72) }) -- multiple cursors when selecting
hl(0, "VM_Cursor", { fg = black1, bg = bright(cursor, 0.82) }) -- multiple cursors normal mode
hl(0, "VM_Insert", { fg = black1, bg = cursor }) -- multiple cursors insert mode
hl(0, "VM_Match", { fg = white1, bg = bright(grey3, 0.9) }) -- multiple cursors matches

vim.opt.guicursor = {
   "n-v-c-sm:block-Cursor/lCursor",
   "i-ci-ve:ver25-CursorInsert",
   "r-cr-o:hor20",
}
hl(0, "Cursor", { fg = "NONE", bg = cursor }) -- cursor
hl(0, "lCursor", { fg = "NONE", bg = cursor }) -- line cursor
hl(0, "CursorInsert", { fg = "NONE", bg = cursor }) -- insert cursor
hl(0, "TermCursor", { fg = black1, bg = cursor }) -- terminal cursor
hl(0, "TermCursorNC", { fg = white1, bg = bright(cursor, 0.4) }) -- terminal cursor not focused

hl(0, "MatchParen", { fg = white1, bg = blue1 }) -- matching parenthesis

hl(0, "TabLineFill", { bg = black1 })
hl(0, "TabLine", { bg = black1, fg = grey2 })
hl(0, "TabLineSel", { bg = black1, fg = white1 })

-- nvim-tree --

local folder = "#6f6f6f"

hl(0, "NvimTreeIndentMarker", { fg = grey1 })
hl(0, "NvimTreeFolderIcon", { fg = folder })
hl(0, "NvimTreeFolderName", { fg = folder, bold = true })
hl(0, "NvimTreeEmptyFolderName", { fg = "#503d2b", bold = true })
hl(0, "NvimTreeOpenedFolderIcon", { fg = folder })
hl(0, "NvimTreeOpenedFolderName", { fg = folder, bold = true })

hl(0, "NvimTreeGitDirtyIcon", { fg = red1 })
hl(0, "NvimTreeGitStagedIcon", { fg = green1 })
hl(0, "NvimTreeGitMergeIcon", { fg = blue2 })
hl(0, "NvimTreeGitRenamedIcon", { fg = green1 })
hl(0, "NvimTreeGitNewIcon", { fg = blue2 })
hl(0, "NvimTreeGitDeletedIcon", { fg = red1 })
hl(0, "NvimTreeGitIgnoredIcon", { fg = blue2 })

-- hl(0, "NvimTreeWinSeparator", { fg = grey1 })

-- telescope --

hl(0, "TelescopeBorder", { fg = green1 })
hl(0, "TelescopeMatching", { fg = green1 })
-- hl(0, "TelescopeSelection", { fg = '#EFEBDB', bg = '#6DBF26' })

vim.cmd([[
   " highlight TelescopePromptBorder guifg=#A7A691
   highlight TelescopeResultsBorder guifg=#A7A691
   highlight TelescopePreviewBorder guifg=#A7A691
   highlight TelescopePromptNormal guifg=#EFECDB
   highlight TelescopeResultsNormal guifg=#A7A691
   highlight TelescopePreviewNormal guifg=#A7A691
   " highlight TelescopePromptTitle guifg=#A7A691 gui=bold
   highlight TelescopeResultsTitle guifg=#A7A691 gui=bold
   highlight TelescopePreviewTitle guifg=#A7A691 gui=bold
   highlight TelescopeSelection guifg=#EFECDB guibg=#1A1A16 
   " highlight TelescopeMatching guifg=#EFECDB guibg=#1639E6
]])

-- indent-blankline --

hl(0, "Indentlinecolor", { fg = bright(grey1, 0.5) }) -- indent line color highlight
hl(0, "Indentscopelinecolor", { fg = grey1 }) -- indent scope line color highlight

-- diagnostic --

local err = "#B4837F"
local warn = "#978936"
local info = "#8f8f9f"
local hint = "#7f9f8f"

hl(0, "Error", { fg = err })

hl(0, "DiagnosticError", { fg = err, bg = "NONE" })
hl(0, "DiagnosticWarn", { fg = warn, bg = "NONE" })
hl(0, "DiagnosticInfo", { fg = info, bg = "NONE" })
hl(0, "DiagnosticHint", { fg = hint, bg = "NONE" })

hl(0, "DiagnosticVirtualTextError", { fg = err, bg = "NONE" })
hl(0, "DiagnosticVirtualTextWarn", { fg = warn, bg = "NONE" })
hl(0, "DiagnosticVirtualTextInfo", { fg = info, bg = "NONE" })
hl(0, "DiagnosticVirtualTextHint", { fg = hint, bg = "NONE" })
hl(0, "DiagnosticUnused", { fg = err, bg = "NONE" })

-- lazygit --

hl(0, "LazyGitFloat", { fg = grey2 })
hl(0, "LazyGitBorder", { fg = grey3 })

-- other --

hl(0, "Whitespace", { fg = orange1 })
hl(0, "NonText", { fg = orange1 })
hl(0, "SpecialKey", { fg = orange1 })
hl(0, "SpecialChar", { fg = orange1 })
hl(0, "Special", { fg = orange1 })

hl(0, "Function", { fg = white1, bold = false })
hl(0, "Keyword", { fg = grey1, bold = false })
hl(0, "Statement", { fg = grey1, bold = false })
hl(0, "Conditinal", { fg = grey1, bold = false })
hl(0, "Repeat", { fg = grey1, bold = false })
hl(0, "Label", { fg = grey1, bold = false })
hl(0, "Identifier", { fg = white1 })
hl(0, "Type", { fg = grey1 })

-- show color previews in this file

-- local function show_color_previews()
--   vim.api.nvim_buf_clear_namespace(0, -1, 0, -1)
--   local ns_id = vim.api.nvim_create_namespace("color_previews")
--   local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
--   local color_pattern = "local%s+(%w+)%s*=%s*['\"](#%x%x%x%x%x%x)['\"]"
--   for line_num, line in ipairs(lines) do
--     local name, value = line:match(color_pattern)
--     if name and value then
--       vim.api.nvim_buf_set_virtual_text(0, ns_id, line_num - 1, {
--         { "███", "ColorPreview" .. name }
--       }, {})
--       vim.api.nvim_set_hl(0, "ColorPreview" .. name, { fg = value })
--     end
--   end
-- end
-- vim.api.nvim_create_autocmd({"BufWritePost", "TextChanged", "TextChangedI", "BufReadPost"}, {
--   pattern = "*.lua",
--   callback = show_color_previews,
-- })
-- show_color_previews()
