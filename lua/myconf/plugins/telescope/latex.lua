local M = {}

local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")
local builtin = require("telescope.builtin")

local function tex_glob_args()
   return { "--glob", "*.tex", "--glob", "!build/**" }
end

local function with_back_to_menu(opts)
   opts = opts or {}

   local original_attach = opts.attach_mappings

   opts.attach_mappings = function(prompt_bufnr, map)
      local function back_to_menu()
         actions.close(prompt_bufnr)
         vim.schedule(function()
            M.latex_picker()
         end)
      end

      map("i", "<C-q>", back_to_menu)

      if original_attach then
         return original_attach(prompt_bufnr, map)
      end

      return true
   end

   return opts
end

local function search_labels()
   builtin.grep_string(with_back_to_menu({
      prompt_title = "LaTeX Labels",
      search = [[\label{]],
      use_regex = false,
      additional_args = tex_glob_args,
   }))
end

local function search_refs()
   builtin.live_grep(with_back_to_menu({
      prompt_title = "LaTeX References",
      default_text = [[\\(ref|autoref|eqref|figsubref)\{]],
      additional_args = tex_glob_args,
   }))
end

local function search_inputs()
   builtin.grep_string(with_back_to_menu({
      prompt_title = "LaTeX Inputs",
      search = [[\input{]],
      use_regex = false,
      additional_args = tex_glob_args,
   }))
end

local function search_includes()
   builtin.grep_string(with_back_to_menu({
      prompt_title = "LaTeX Includes",
      search = [[\include{]],
      use_regex = false,
      additional_args = tex_glob_args,
   }))
end

local function search_sections()
   builtin.live_grep(with_back_to_menu({
      prompt_title = "LaTeX Sections",
      default_text = [[\\(part|chapter|section|subsection|subsubsection|paragraph)\*?\{]],
      additional_args = tex_glob_args,
   }))
end

local function search_commands()
   builtin.live_grep(with_back_to_menu({
      prompt_title = "LaTeX Commands & Environments",
      default_text = [[\\(newcommand|renewcommand|providecommand|newenvironment|renewenvironment|NewDocumentCommand|RenewDocumentCommand|ProvideDocumentCommand|NewDocumentEnvironment|RenewDocumentEnvironment)\*?\{]],
      additional_args = function()
         return { "--glob", "*.tex", "--glob", "!build/**", "--pcre2" }
      end,
   }))
end

local function search_math_blocks()
   builtin.live_grep(with_back_to_menu({
      prompt_title = "LaTeX Math Blocks",
      default_text = [[\\begin\{(equation\*?|align\*?|gather\*?|multline\*?)\}|\\\[|\$\$]],
      additional_args = function()
         return { "--glob", "*.tex", "--glob", "!build/**", "--pcre2" }
      end,
   }))
end

function M.latex_picker()
   local items = {
      { label = "Labels", action = search_labels },
      { label = "References", action = search_refs },
      { label = "Inputs", action = search_inputs },
      { label = "Includes", action = search_includes },
      { label = "Sections", action = search_sections },
      { label = "Commands", action = search_commands },
      { label = "Math blocks", action = search_math_blocks },
   }

   pickers
      .new({}, {
         prompt_title = "LaTeX Picker",
         finder = finders.new_table({
            results = items,
            entry_maker = function(entry)
               return {
                  value = entry,
                  display = entry.label,
                  ordinal = entry.label,
               }
            end,
         }),
         sorter = conf.generic_sorter({}),
         attach_mappings = function(prompt_bufnr, map)
            local function run_selection()
               local selection = action_state.get_selected_entry()
               if not selection then
                  return
               end

               actions.close(prompt_bufnr)
               selection.value.action()
            end

            map("i", "<CR>", run_selection)
            map("n", "<CR>", run_selection)

            return true
         end,
      })
      :find()
end

return M
