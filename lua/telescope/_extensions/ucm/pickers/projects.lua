-- [nfnl] Compiled from fnl/telescope/_extensions/ucm/pickers/projects.fnl by https://github.com/Olical/nfnl, do not edit.
local actions = require("telescope.actions")
local state = require("telescope.actions.state")
local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = (require("telescope.config")).values
local ucm_state = require("ucm.state")
local http = require("ucm.model.http")
local payloads = require("ucm.model.payloads")
local branches = require("telescope._extensions.ucm.pickers.branches")
local function attach_mappings(bufnr, _)
  local function _1_()
    local selection = state.get_selected_entry()
    ucm_state["set-project"](payloads["get-project-name"](selection.value))
    actions.close(bufnr)
    return branches:picker({}):find()
  end
  do end (actions.select_default):replace(_1_)
  return true
end
local function entry_maker(project)
  local project_name = payloads["get-project-name"](project)
  return {value = project, display = project_name, ordinal = project_name}
end
local M = {}
M.picker = function(opts)
  local opts0 = (opts or {})
  return pickers.new(opts0, {prompt_title = "Unison Projects", finder = finders.new_table({results = http.projects(), entry_maker = entry_maker}), attach_mappings = attach_mappings, sorter = conf.generic_sorter(opts0)})
end
return M
