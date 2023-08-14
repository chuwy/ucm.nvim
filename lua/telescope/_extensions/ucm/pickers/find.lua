-- [nfnl] Compiled from fnl/telescope/_extensions/ucm/pickers/find.fnl by https://github.com/Olical/nfnl, do not edit.
local actions = require("telescope.actions")
local action_set = require("telescope.actions.set")
local state = require("telescope.actions.state")
local pickers = require("telescope.pickers")
local entry_display = require("telescope.pickers.entry_display")
local conf = (require("telescope.config")).values
local model = require("ucm.model.init")
local payloads = require("ucm.model.payloads")
local http = require("ucm.model.http")
local render = require("ucm.render")
local ucm_state = require("ucm.state")
local utils = require("ucm.utils")
local debouncer = require("ucm.utils.debouncer")
local display_items = {{width = 1}, {width = 48}, {remaining = true}}
local function insert(bufnr, item)
  actions.close(bufnr)
  local _1_ = item
  if ((_G.type(_1_) == "table") and ((_G.type((_1_).namedTerm) == "table") and (nil ~= ((_1_).namedTerm).termName) and (nil ~= ((_1_).namedTerm).termHash))) then
    local name = ((_1_).namedTerm).termName
    local hash = ((_1_).namedTerm).termHash
    return vim.api.nvim_put(render.term(model["get-term"](name, hash, ucm_state["list-path-get"]())), "", false, true)
  elseif ((_G.type(_1_) == "table") and ((_G.type((_1_).namedType) == "table") and (nil ~= ((_1_).namedType).typeName) and (nil ~= ((_1_).namedType).typeHash))) then
    local name = ((_1_).namedType).typeName
    local hash = ((_1_).namedType).typeHash
    return vim.api.nvim_put(render.type(model["get-type"](name, hash, ucm_state["list-path-get"]())), "", false, true)
  elseif (nil ~= _1_) then
    local other = _1_
    return utils.notify(other)
  else
    return nil
  end
end
local function handle(bufnr, item)
  local value = item.value
  local _3_ = value
  if ((_G.type(_3_) == "table") and true and ((_G.type((_3_)[2]) == "table") and (((_3_)[2]).tag == "FoundTermResult") and (nil ~= ((_3_)[2]).contents))) then
    local _ = (_3_)[1]
    local contents = ((_3_)[2]).contents
    return insert(bufnr, contents)
  elseif ((_G.type(_3_) == "table") and true and ((_G.type((_3_)[2]) == "table") and (((_3_)[2]).tag == "FoundTypeResult") and (nil ~= ((_3_)[2]).contents))) then
    local _ = (_3_)[1]
    local contents = ((_3_)[2]).contents
    return insert(bufnr, contents)
  elseif (nil ~= _3_) then
    local other = _3_
    return utils.notify({msg = "find.handle match failed", value = other})
  else
    return nil
  end
end
local displayer = entry_display.create({separator = " ", items = display_items})
local function make_display(entry)
  return displayer(payloads["get-find-entry-display"](entry.value))
end
local function entry_maker(item)
  return {value = item, display = make_display, ordinal = payloads["get-find-entry-name"](item)}
end
local function attach_mappings(bufnr, _)
  local function _5_()
    return true
  end
  local function _6_()
    local selection = state.get_selected_entry()
    return handle(bufnr, selection)
  end
  do end (action_set.select):replace_if(_5_, _6_)
  return true
end
local M = {}
local function safe_iterate(body)
  local success_3f, result = pcall(vim.json.decode, body)
  local function _7_()
    if success_3f then
      return result
    else
      return {}
    end
  end
  return ipairs(_7_())
end
local function async_fn(on_result, on_complete)
  local relative_to = ucm_state["get-relative-to"]()
  if (relative_to == nil) then
    utils.notify("You project/branch are not selected. The search can be very slow. Pick one with `Telescope ucm list`")
  else
  end
  local function _9_(prompt)
    _G.assert((nil ~= prompt), "Missing argument prompt on /Users/chuwy/workspace/ucm.nvim/fnl/telescope/_extensions/ucm/pickers/find.fnl:63")
    local process_body
    local function _10_(res)
      _G.assert((nil ~= res), "Missing argument res on /Users/chuwy/workspace/ucm.nvim/fnl/telescope/_extensions/ucm/pickers/find.fnl:64")
      for key, value in safe_iterate(res.body) do
        on_result(key, value)
      end
      return on_complete()
    end
    process_body = _10_
    if (#prompt < 3) then
      return nil
    else
      return http["find-async"](prompt, ucm_state["get-relative-to"](), process_body)
    end
  end
  return _9_
end
M.picker = function(opts)
  local opts0 = (opts or {})
  return pickers.new(opts0, {prompt_title = "Find", finder = debouncer.async_finder({async_fn = async_fn, entry_maker = entry_maker}), attach_mappings = attach_mappings, sorter = conf.generic_sorter(opts0)})
end
return M
