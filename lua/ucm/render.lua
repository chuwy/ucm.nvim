-- [nfnl] Compiled from fnl/ucm/render.fnl by https://github.com/Olical/nfnl, do not edit.
local nfnl = require("nfnl.core")
local utils = require("ucm.utils")
local colors = {TypeObject = "TelescopeResultsClass", TermObject = "TelescopeResultsVariable", Subnamespace = "TelescopeResultsConstant", SubnamespaceSize = "@comment"}
local icons = {TypeObject = "\238\174\185", TermObject = "\243\176\138\149", Subnamespace = "\239\146\135", SubnamespaceSize = "\243\177\158\170"}
local M = {}
M.trm = function(name)
  local t = "TermObject"
  return {{icons[t], colors[t]}, name}
end
M["trm-typed"] = function(name, tpe)
  local t = "TermObject"
  local type = table.concat(M.segments(tpe), " ")
  return {{icons[t], colors[t]}, name, {type, "@comment"}}
end
M.tpe = function(name)
  local t = "TypeObject"
  return {{icons[t], colors[t]}, name}
end
M["tpe-typed"] = function(name, tpe)
  local t = "TypeObject"
  local type = table.concat(M.segments(tpe), " ")
  return {{icons[t], colors[t]}, name, {type, "@comment"}}
end
M.namespace = function(name)
  local t = "Subnamespace"
  return {{icons[t], colors[t]}, name}
end
M.colored = function(s, tag)
  return {s, colors[tag]}
end
M.segments = function(segments)
  local function _1_(acc, cur)
    _G.assert((nil ~= cur), "Missing argument cur on /Users/chuwy/workspace/ucm.nvim/fnl/ucm/render.fnl:50")
    _G.assert((nil ~= acc), "Missing argument acc on /Users/chuwy/workspace/ucm.nvim/fnl/ucm/render.fnl:50")
    local _2_ = cur
    if ((_G.type(_2_) == "table") and ((_2_).segment == "\n")) then
      return vim.list_extend(acc, {""})
    elseif ((_G.type(_2_) == "table") and (nil ~= (_2_).segment)) then
      local seg = (_2_).segment
      return vim.list_extend(utils.init(acc), {(nfnl.last(acc) .. seg)})
    else
      return nil
    end
  end
  return nfnl.reduce(_1_, {""}, segments)
end
M.term = function(item)
  return M.segments(item.termDefinition.contents)
end
M.type = function(item)
  return M.segments(item.typeDefinition.contents)
end
return M
