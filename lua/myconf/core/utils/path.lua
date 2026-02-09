local M = {}

function M.config_dir()
   return vim.fn.stdpath("config")
end

function M.cwd()
   return vim.fn.getcwd()
end

function M.current_file()
   return vim.fn.expand("%:p")
end

function M.current_dir()
   return vim.fn.expand("%:p:h")
end

function M.is_nvimtree_buffer()
   local name = vim.api.nvim_buf_get_name(0)
   return name:find("NvimTree_") ~= nil
end

return M
