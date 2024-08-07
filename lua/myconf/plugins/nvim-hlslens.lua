-- nvim-hlslens helps you better glance at matched information, seamlessly jump between matched instances

return {
  "kevinhwang91/nvim-hlslens",
  config = function()
    local hlslens = require("hlslens")

    hlslens.setup({
      calm_down = true, -- disable when moving the cursor out of the match

      -- needed to enable the search handler for scrollbar - nvim-scrollbar
      build_position_cb = function(plist, _, _, _)
        require("scrollbar.handlers.search").handler.show(plist.start_pos)
      end,

      override_lens = function(render, posList, nearest, idx, relIdx)
        local sfw = vim.v.searchforward == 1
        local indicator, text, chunks
        local absRelIdx = math.abs(relIdx)
        if absRelIdx > 1 then
          indicator = ("%d%s"):format(absRelIdx, sfw ~= (relIdx > 1) and "N" or "n")
        elseif absRelIdx == 1 then
          indicator = sfw ~= (relIdx == 1) and "N" or "n"
        else
          indicator = ""
        end

        local lnum, col = unpack(posList[idx])
        if nearest then
          local cnt = #posList
          if indicator ~= "" then
            text = (" %d/%d "):format(idx, cnt)
            -- text = (" %s %d/%d "):format(indicator, idx, cnt)
          else
            text = (" %d/%d "):format(idx, cnt)
          end
          chunks = { { "  " }, { text, "HlSearchLensNear" } }
        else
          text = (" %s %d "):format(indicator, idx)
          chunks = { { "  " }, { text, "HlSearchLens" } }
        end
        render.setVirt(0, lnum - 1, col - 1, chunks, nearest)
      end,
    })

    local kopts = { noremap = true, silent = true }

    vim.api.nvim_set_keymap("n", "n", [[*<Cmd>lua require('hlslens').start()<CR>]], kopts)
    -- vim.api.nvim_set_keymap(
    --   "n",
    --   "N",
    --   [[<Cmd>execute('normal! ' . v:count1 . 'N')<CR><Cmd>lua require('hlslens').start()<CR>]],
    --   kopts
    -- )
    vim.api.nvim_set_keymap("n", "*", [[*<Cmd>lua require('hlslens').start()<CR>]], kopts)
    vim.api.nvim_set_keymap("n", "#", [[#<Cmd>lua require('hlslens').start()<CR>]], kopts)
    vim.api.nvim_set_keymap("n", "g*", [[g*<Cmd>lua require('hlslens').start()<CR>]], kopts)
    vim.api.nvim_set_keymap("n", "g#", [[g#<Cmd>lua require('hlslens').start()<CR>]], kopts)

    -- vim.api.nvim_set_keymap("n", "<Leader>l", "<Cmd>noh<CR>", kopts)

    -- hide scrollbar search when leaving command line mode - nvim-scrollbar
    vim.cmd([[
      augroup scrollbar_search_hide
        autocmd!
        autocmd CmdlineLeave : lua require('scrollbar.handlers.search').handler.hide()
      augroup END
    ]])

    -- nvim-hlslens integration with vim-visual-multi
    if hlslens then
      local overrideLens = function(render, posList, nearest, idx, relIdx)
        local _ = relIdx
        local lnum, col = unpack(posList[idx])

        local text, chunks
        if nearest then
          text = (" %d/%d "):format(idx, #posList)
          chunks = { { "  ", "Ignore" }, { text, "HlSearchLensNear" } }
        else
          text = (" %d "):format(idx)
          chunks = { { "  ", "Ignore" }, { text, "HlSearchLens" } }
        end
        render.setVirt(0, lnum - 1, col - 1, chunks, nearest)
      end
      local lensBak
      local config = require("hlslens.config")
      local gid = vim.api.nvim_create_augroup("VMlens", {})
      vim.api.nvim_create_autocmd("User", {
        pattern = { "visual_multi_start", "visual_multi_exit" },
        group = gid,
        callback = function(ev)
          if ev.match == "visual_multi_start" then
            lensBak = config.override_lens
            config.override_lens = overrideLens
            config.calm_down = false -- to fix
          else
            config.override_lens = lensBak
          end
          hlslens.start()
        end,
      })
    end
  end,
}
