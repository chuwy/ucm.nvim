-- [nfnl] Compiled from fnl/ucm/model/init.fnl by https://github.com/Olical/nfnl, do not edit.
local http = require("ucm.model.http")
local utils = require("ucm.utils")
local M = {}
M["get-term"] = function(name, hash)
  return ((http["get-definition"](name)).termDefinitions)[hash]
end
M["get-type"] = function(name, hash)
  local definitions = (http["get-definition"](name)).typeDefinitions
  local function _1_(key)
    _G.assert((nil ~= key), "Missing argument key on /Users/chuwy/workspace/ucm.nvim/fnl/ucm/model/init.fnl:14")
    return utils["starts-with"](key, hash)
  end
  return utils["find-by-key"](definitions, _1_)
end
return M
