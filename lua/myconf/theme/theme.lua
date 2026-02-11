local cmd = vim.cmd
local api = vim.api
local hl = api.nvim_set_hl

local palettes = require("myconf.theme.palette")
local mode = require("configuration").ui.theme()

local color_utils = require("myconf.theme.color_utils")
local bright = color_utils.adjust_brightness

local function pal()
   return palettes[mode]
end

local function apply_theme()
   local m = mode
   local c = pal()

   vim.o.background = (m == "light") and "light" or "dark"

   -- default --

   hl(0, "WinbarColor", { fg = c.grey2 }) -- winbar text
   hl(0, "WinSeparator", { fg = c.grey1 }) -- winbar separator

   hl(0, "LineNrAbove", { fg = c.grey1, bold = false }) -- line number above the current line
   hl(0, "LineNr", { fg = c.green1, bold = false }) -- current line number
   hl(0, "LineNrBelow", { fg = c.grey1, bold = false }) -- line number below the current line

   hl(0, "CursorLine", { bg = c.line }) -- current line
   hl(0, "Visual", { bg = c.visual, fg = "none" }) -- visual mode
   hl(0, "Comment", { fg = c.comment, italic = true })

   if m == "dark" then
      hl(0, "YankHighlight", { bg = bright(c.visual, 1.25), fg = c.white1 })
   else
      hl(0, "YankHighlight", { bg = bright(c.visual, 0.92), fg = c.white1 })
   end

   hl(0, "Substitute", { fg = c.black1, bg = c.purewhite })

   if m == "light" then
      hl(0, "ColorColumn", { bg = bright(c.black1, 0.97) }) -- color column
   end

   if m == "dark" then
      hl(0, "Search", { fg = c.white1, bg = c.grey2 }) -- search
   else
      hl(0, "Search", { fg = c.white1, bg = bright(c.grey3, 1.23) }) -- search
   end

   hl(0, "IncSearch", { fg = c.black1, bg = c.purewhite }) -- incremental current search result
   cmd([[highlight link CurSearch IncSearch]]) -- current search

   -- nvim-hlslens
   if m == "dark" then
      hl(0, "HlSearchLens", { fg = c.white1, bg = bright(c.grey2, 0.3) }) -- search lens
   else
      hl(0, "HlSearchLens", { fg = c.pitchblack, bg = bright(c.grey3, 1) }) -- search lens
   end
   cmd([[highlight link HlSearchNear CurSearch]]) -- this ovverrides the default current search
   cmd([[highlight link HlSearchLensNear CurSearch]]) -- current search lens

   -- vim-visual-multi
   hl(0, "VM_Extend", { fg = c.black1, bg = c.purewhite }) -- selection when extending

   if m == "dark" then
      hl(0, "VM_Mono", { fg = c.black1, bg = bright(c.cursor, 0.72) }) -- multiple cursors when selecting
      hl(0, "VM_Cursor", { fg = c.black1, bg = bright(c.cursor, 0.82) }) -- multiple cursors normal mode
      hl(0, "VM_Match", { fg = c.white1, bg = bright(c.grey3, 0.9) }) -- multiple cursors matches
   else
      hl(0, "VM_Mono", { fg = c.black1, bg = bright(c.cursor, 1.22) }) -- multiple cursors when selecting
      hl(0, "VM_Cursor", { fg = c.black1, bg = bright(c.cursor, 1.32) }) -- multiple cursors normal mode
      hl(0, "VM_Match", { fg = c.white1, bg = bright(c.grey3, 1.4) }) -- multiple cursors matches
   end

   hl(0, "VM_Insert", { fg = c.black1, bg = c.cursor }) -- multiple cursors insert mode

   -- floating menu
   hl(0, "FloatNormal", { fg = c.black1 })
   hl(0, "FloatBorder", { fg = c.grey2 })
   hl(0, "FloatTitle", { fg = c.grey2 })
   hl(0, "FloatFooter", { fg = c.grey2 })

   -- popup menu
   local cmp_match_blue = (m == "dark") and bright(c.blue1, 1.2) or c.blue1

   hl(0, "Pmenu", { fg = c.white1, bg = "NONE" })
   hl(0, "PmenuSbar", { bg = "NONE" })
   hl(0, "PmenuSel", { fg = c.white1, bg = c.blue1 })
   hl(0, "PmenuKind", { fg = c.white1, bg = "NONE" })
   hl(0, "PmenuKindSel", { fg = c.white1, bg = c.blue1 })
   hl(0, "PmenuExtra", { fg = c.white1, bg = "NONE" })
   hl(0, "CmpItemAbbr", { fg = c.white1, bg = "NONE" })
   hl(0, "CmpItemAbbrMatch", { fg = cmp_match_blue, bold = true })
   hl(0, "CmpItemAbbrMatchFuzzy", { fg = cmp_match_blue, italic = true })
   hl(0, "CmpItemKind", { fg = c.orange1, bg = "NONE" })
   hl(0, "CmpItemMenu", { fg = c.comment, bg = "NONE", italic = true })

   vim.opt.guicursor = {
      "n-v-c-sm:block-Cursor/lCursor",
      "i-ci-ve:ver25-CursorInsert",
      "r-cr-o:hor20",
      "t:ver25-CursorInsert",
   }
   hl(0, "Cursor", { fg = "NONE", bg = c.cursor }) -- cursor
   hl(0, "lCursor", { fg = "NONE", bg = c.cursor }) -- line cursor
   hl(0, "CursorInsert", { fg = "NONE", bg = c.cursor }) -- insert cursor
   hl(0, "TermCursor", { fg = c.black1, bg = c.cursor }) -- terminal cursor

   if m == "dark" then
      hl(0, "TermCursorNC", { fg = c.white1, bg = bright(c.cursor, 0.4) }) -- terminal cursor not focused
   else
      hl(0, "TermCursorNC", { fg = c.white1, bg = bright(c.cursor, 1.4) }) -- terminal cursor not focused
   end

   if m == "dark" then
      hl(0, "MatchParen", { fg = c.white1, bg = c.blue1 }) -- matching parenthesis
   else
      hl(0, "MatchParen", { fg = c.black1, bg = c.blue1 }) -- matching parenthesis
   end

   hl(0, "TabLineFill", { bg = c.black1 })
   hl(0, "TabLine", { bg = c.black1, fg = c.grey2 })
   hl(0, "TabLineSel", { bg = c.black1, fg = c.white1 })

   -- nvim-tree --
   hl(0, "NvimTreeIndentMarker", { fg = c.grey1 })
   hl(0, "NvimTreeRootFolder", { fg = c.folder, bold = true, italic = true })
   hl(0, "NvimTreeFolderIcon", { fg = c.folder })
   hl(0, "NvimTreeFolderName", { fg = c.folder, bold = true })
   hl(0, "NvimTreeEmptyFolderName", { fg = c.nvimtree_empty_folder, bold = true })
   hl(0, "NvimTreeOpenedFolderIcon", { fg = c.folder })
   hl(0, "NvimTreeOpenedFolderName", { fg = c.folder, bold = true })

   hl(0, "NvimTreeGitDirtyIcon", { fg = c.red1 })
   hl(0, "NvimTreeGitStagedIcon", { fg = c.green1 })
   hl(0, "NvimTreeGitMergeIcon", { fg = c.blue2 })
   hl(0, "NvimTreeGitRenamedIcon", { fg = c.green1 })
   hl(0, "NvimTreeGitNewIcon", { fg = c.blue2 })
   hl(0, "NvimTreeGitDeletedIcon", { fg = c.red1 })
   hl(0, "NvimTreeGitIgnoredIcon", { fg = c.blue2 })

   -- telescope --
   hl(0, "TelescopeBorder", { fg = c.green1 })
   hl(0, "TelescopeMatching", { fg = c.green1 })

   cmd(("highlight TelescopePromptBorder guifg=%s"):format(c.telescope.border))
   cmd(("highlight TelescopeResultsBorder guifg=%s"):format(c.telescope.border))
   cmd(("highlight TelescopePreviewBorder guifg=%s"):format(c.telescope.border))
   cmd(("highlight TelescopePromptNormal guifg=%s"):format(c.telescope.prompt_normal_fg))
   cmd(("highlight TelescopeResultsNormal guifg=%s"):format(c.telescope.border))
   cmd(("highlight TelescopePreviewNormal guifg=%s"):format(c.telescope.border))
   cmd(("highlight TelescopeResultsTitle guifg=%s gui=bold"):format(c.telescope.border))
   cmd(("highlight TelescopePreviewTitle guifg=%s gui=bold"):format(c.telescope.border))
   cmd(("highlight TelescopeSelection guifg=%s guibg=%s"):format(c.telescope.selection_fg, c.telescope.selection_bg))
   cmd(("highlight TelescopeMatching guifg=%s guibg=%s"):format(c.telescope.matching_fg, c.telescope.matching_bg))

   -- indent-blankline --
   if m == "dark" then
      hl(0, "Indentlinecolor", { fg = bright(c.grey1, 0.5) }) -- indent line color highlight
      hl(0, "Indentscopelinecolor", { fg = c.grey1 }) -- indent scope line color highlight
   else
      hl(0, "Indentlinecolor", { fg = bright(c.grey1, 1.3) }) -- indent line color highlight
      hl(0, "Indentscopelinecolor", { fg = c.grey1 }) -- indent scope line color highlight
   end

   -- diagnostic --
   local err = c.diag.err
   local warn = c.diag.warn
   local info = c.diag.info
   local hint = c.diag.hint

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

   -- gitsigns --
   hl(0, "GitSignsChange", { fg = hint })
   hl(0, "GitSignsDelete", { fg = c.red1 })
   hl(0, "GitSignsChangeDelete", { fg = c.red1 })
   hl(0, "GitSignsTopdelete", { fg = c.red1 })
   hl(0, "GitSignsUntracked", { fg = info })

   -- lazygit --
   hl(0, "LazyGitFloat", { fg = c.white1 })
   hl(0, "LazyGitBorder", { fg = c.grey3 })

   -- light-only: Flash + CopilotSuggestion
   if m == "light" then
      hl(0, "FlashLabel", { fg = c.black1, bg = c.blue1, bold = true }) -- Highlight for labels
      hl(0, "FlashCurrent", { fg = c.black1, bg = c.purewhite }) -- Highlight for the current match
      hl(0, "FlashBackdrop", { fg = bright(c.grey3, 1.1), bg = "NONE" }) -- Highlight for the backdrop

      hl(0, "CopilotSuggestion", { fg = bright(c.grey1, 0.9) }) -- Cambia il colore dei suggerimenti di Copilot
   end

   -- other --
   hl(0, "Whitespace", { fg = c.orange1 })
   hl(0, "NonText", { fg = c.grey2 })
   hl(0, "SpecialKey", { fg = c.orange1 })
   hl(0, "SpecialChar", { fg = c.orange1 })
   hl(0, "Special", { fg = c.orange1 })

   hl(0, "Function", { fg = c.white1, bold = false })
   hl(0, "Keyword", { fg = c.grey1, bold = false })
   hl(0, "Statement", { fg = c.grey1, bold = false })
   hl(0, "Conditional", { fg = c.grey1, bold = false })
   hl(0, "Repeat", { fg = c.grey1, bold = false })
   hl(0, "Label", { fg = c.grey1, bold = false })
   hl(0, "Identifier", { fg = c.white1 })
   hl(0, "Type", { fg = c.grey1 })

   hl(0, "@markup.raw.markdown_inline", { bg = bright(c.black1, 4) })
end

-- Apply immediately and after any colorscheme is set (tokyonight, etc.)
local theme_group = api.nvim_create_augroup("MyTheme", { clear = true })
api.nvim_create_autocmd("ColorScheme", {
   group = theme_group,
   callback = apply_theme,
})
apply_theme()

-- custom language highlights (created once; read palette dynamically)
local ft_group = api.nvim_create_augroup("CustomHighlights", { clear = true })

api.nvim_create_autocmd("FileType", {
   group = ft_group,
   pattern = "c",
   callback = function()
      local c = pal()
      hl(0, "Label", { fg = c.test1 })
   end,
})

api.nvim_create_autocmd("FileType", {
   group = ft_group,
   pattern = "cpp",
   callback = function()
      local c = pal()
      hl(0, "SpecialChar", { fg = c.green1 })
      hl(0, "Special", { fg = c.grey1 })
   end,
})

api.nvim_create_autocmd("FileType", {
   group = ft_group,
   pattern = "go",
   callback = function()
      local c = pal()
      hl(0, "Special", { fg = c.green1 })
   end,
})
