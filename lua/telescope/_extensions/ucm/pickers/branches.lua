-- [nfnl] Compiled from fnl/telescope/_extensions/ucm/pickers/branches.fnl by https://github.com/Olical/nfnl, do not edit.
local actions = require("telescope.actions")
local state = require("telescope.actions.state")
local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = (require("telescope.config")).values
local ucm = require("ucm")
local ucm_state = require("ucm.state")
local utils = require("ucm.utils")
local http = require("ucm.model.http")
local payloads = require("ucm.model.payloads")
local function attach_mappings(bufnr, _)
  local function _1_()
    local selection = state.get_selected_entry()
    local branch = payloads["get-branch-name"](selection.value)
    actions.close(bufnr)
    ucm_state["set-branch"](branch)
    ucm["save-state"]()
    return utils.notify(("Working on " .. ucm_state["get-project-branch-path"]()))
  end
  do end (actions.select_default):replace(_1_)
  return true
end
local function entry_maker(branch)
  local branch_name = payloads["get-branch-name"](branch)
  return {value = branch, display = branch_name, ordinal = branch_name}
end
local M = {}
M.picker = function(opts)
  local opts0 = (opts or {})
  local project = ucm_state["get-project"]()
  if (project == nil) then
    local function _2_(_)
      return utils.notify("You must pick a project first: `:Telescope ucm projects`")
    end
    return {find = _2_}
  else
    return pickers.new(opts0, {prompt_title = ("Branches of " .. project), finder = finders.new_table({results = http.branches(project), entry_maker = entry_maker}), attach_mappings = attach_mappings, sorter = conf.generic_sorter(opts0)})
  end
end
return M
