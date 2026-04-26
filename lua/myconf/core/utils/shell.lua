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

function M.reveal_path(path)
   if not path or path == "" then
      return nil
   end

   local target = vim.fn.fnamemodify(path, ":p")

   if vim.fn.has("macunix") == 1 then
      return M.jobstart({ "open", "-R", target }, { detach = true })
   end

   if vim.fn.has("win32") + vim.fn.has("win64") > 0 then
      if vim.fn.isdirectory(target) == 1 then
         return M.jobstart({ "explorer.exe", target }, { detach = true })
      end

      return M.jobstart({ "explorer.exe", "/select," .. target }, { detach = true })
   end

   local dir = target
   if vim.fn.isdirectory(target) == 0 then
      dir = vim.fs.dirname(target) or vim.fn.fnamemodify(target, ":p:h")
   end

   return M.jobstart({ "xdg-open", dir }, { detach = true })
end

function M.open_in_finder(path)
   return M.reveal_path(path)
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
