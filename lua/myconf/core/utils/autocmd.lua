local M = {}

function M.group(name, opts)
   local cfg = opts or {}
   if cfg.clear == nil then
      cfg.clear = true
   end
   return vim.api.nvim_create_augroup(name, cfg)
end

function M.create(events, opts)
   return vim.api.nvim_create_autocmd(events, opts)
end

return M
