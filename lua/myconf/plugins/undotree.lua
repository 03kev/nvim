return {
    "mbbill/undotree",
    config = function()
        local keymap = vim.keymap -- for conciseness

        keymap.set('n', '<leader>ut', ':UndotreeToggle<CR>', { desc = "Toggle UndoTree", silent = true })
        keymap.set('n', '<leader>uf', ':UndotreeFocus<CR>', { desc = "Focus UndoTree", silent = true })
    end
}