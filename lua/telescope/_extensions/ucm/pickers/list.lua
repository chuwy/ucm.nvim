-- [nfnl] Compiled from fnl/telescope/_extensions/ucm/pickers/list.fnl by https://github.com/Olical/nfnl, do not edit.
local actions = require("telescope.actions")
local action_set = require("telescope.actions.set")
local state = require("telescope.actions.state")
local pickers = require("telescope.pickers")
local entry_display = require("telescope.pickers.entry_display")
local finders = require("telescope.finders")
local conf = (require("telescope.config")).values
local model = require("ucm.model.init")
local payloads = require("ucm.model.payloads")
local http = require("ucm.model.http")
local render = require("ucm.render")
local ucm_state = require("ucm.state")
local utils = require("ucm.utils")
local display_items = {{width = 1}, {width = 48}, {remaining = true}}
local function insert(bufnr, item)
  actions.close(bufnr)
  local _1_ = item
  if ((_G.type(_1_) == "table") and ((_G.type((_1_).value) == "table") and (((_1_).value).tag == "TermObject") and ((_G.type(((_1_).value).contents) == "table") and (nil ~= (((_1_).value).contents).termName) and (nil ~= (((_1_).value).contents).termHash)))) then
    local name = (((_1_).value).contents).termName
    local hash = (((_1_).value).contents).termHash
    return vim.api.nvim_put(render.term(model["get-term"](name, hash, ucm_state["get-relative-to"]())), "", false, true)
  elseif ((_G.type(_1_) == "table") and ((_G.type((_1_).value) == "table") and (((_1_).value).tag == "TypeObject") and ((_G.type(((_1_).value).contents) == "table") and (nil ~= (((_1_).value).contents).typeName) and (nil ~= (((_1_).value).contents).typeHash)))) then
    local name = (((_1_).value).contents).typeName
    local hash = (((_1_).value).contents).typeHash
    return vim.api.nvim_put(render.type(model["get-type"](name, hash, ucm_state["get-relative-to"]())), "", false, true)
  elseif (nil ~= _1_) then
    local other = _1_
    return utils.notify(other)
  else
    return nil
  end
end
local function handle(current_picker, finder, bufnr, item)
  local _3_ = item
  if ((_G.type(_3_) == "table") and ((_G.type((_3_).value) == "table") and (((_3_).value).tag == "TypeObject"))) then
    return insert(bufnr, item)
  elseif ((_G.type(_3_) == "table") and ((_G.type((_3_).value) == "table") and (((_3_).value).tag == "TermObject"))) then
    return insert(bufnr, item)
  elseif ((_G.type(_3_) == "table") and ((_G.type((_3_).value) == "table") and (((_3_).value).tag == "PatchObject"))) then
    return nil
  elseif ((_G.type(_3_) == "table") and ((_G.type((_3_).value) == "table") and (((_3_).value).tag == "Subnamespace"))) then
    ucm_state["set-path"](item)
    return current_picker:refresh(finder, {["reset_prompt:"] = true, ["multi:"] = current_picker._multi})
  elseif (nil ~= _3_) then
    local other = _3_
    return utils.notify(other)
  else
    return nil
  end
end
local displayer = entry_display.create({separator = " ", items = display_items})
local function make_display(entry)
  return displayer(payloads["get-list-entry-display"](entry.value))
end
local function list_entry_maker(item)
  return {value = item, display = make_display, ordinal = payloads["get-list-entry-name"](item)}
end
local function attach_mappings(bufnr, _)
  local function _5_()
    return true
  end
  local function _6_()
    local selection = state.get_selected_entry()
    local current_picker = state.get_current_picker(bufnr)
    local finder = current_picker.finder
    return handle(current_picker, finder, bufnr, selection)
  end
  do end (action_set.select):replace_if(_5_, _6_)
  return true
end
local M = {}
M.picker = function(opts)
  local opts0 = (opts or {})
  local get
  local function _7_()
    return payloads["from-list-root-payload"](http.list(ucm_state["list-path-get"]()))
  end
  get = _7_
  return pickers.new(opts0, {prompt_title = "Namespaces", finder = finders.new_dynamic({fn = get, entry_maker = list_entry_maker}), attach_mappings = attach_mappings, sorter = conf.generic_sorter(opts0)})
end
return M
