local M = {}

local function tab_label(n)
   local buflist = vim.fn.tabpagebuflist(n)
   local winnr = vim.fn.tabpagewinnr(n)
   local bufname = vim.fn.bufname(buflist[winnr])
   if bufname == "" then
      return "[No Name]"
   end
   return vim.fn.fnamemodify(bufname, ":t")
end

function M.render()
   local current = vim.fn.tabpagenr()
   local total = vim.fn.tabpagenr("$")
   local chunks = {}

   for i = 1, total do
      if i == current then
         chunks[#chunks + 1] = "%#TabLineSel#"
      else
         chunks[#chunks + 1] = "%#TabLine#"
      end

      chunks[#chunks + 1] = "%" .. i .. "T"
      chunks[#chunks + 1] = " " .. tab_label(i) .. " "
   end

   chunks[#chunks + 1] = "%#TabLineFill#%T"
   if total > 1 then
      chunks[#chunks + 1] = "%=%#TabLine#%999XX"
   end

   return table.concat(chunks)
end

function M.setup()
   vim.o.tabline = "%!v:lua.require'myconf.core.ui.tabline'.render()"
end

return M
