local M = {}

function M.join_args(args)
   if not args or #args == 0 then
      return ""
   end
   local escaped = vim.tbl_map(vim.fn.shellescape, args)
   return table.concat(escaped, " ")
end

function M.system(cmd, opts)
   return vim.system(cmd, opts or {}):wait()
end

function M.jobstart(cmd, opts)
   return vim.fn.jobstart(cmd, opts or {})
end

function M.zsh_login(script)
   return M.system({ "zsh", "-lc", script })
end

function M.open_in_finder(path)
   return M.system({ "open", "-R", path })
end

function M.open_external(path)
   local opener
   if vim.fn.has("macunix") == 1 then
      opener = { "open", path }
   elseif vim.fn.has("win32") + vim.fn.has("win64") > 0 then
      opener = { "cmd.exe", "/c", "start", "", path }
   else
      opener = { "xdg-open", path }
   end
   return M.jobstart(opener, { detach = true })
end

return M
