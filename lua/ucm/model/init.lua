-- [nfnl] Compiled from fnl/ucm/model/init.fnl by https://github.com/Olical/nfnl, do not edit.
local http = require("ucm.model.http")
local utils = require("ucm.utils")
local M = {}
M["get-term"] = function(root, name, hash, relative_to)
  return ((http["get-definition"](root, name, relative_to)).termDefinitions)[hash]
end
M["get-type"] = function(root, name, hash, relative_to)
  local definitions = (http["get-definition"](root, name, relative_to)).typeDefinitions
  local function _1_(key)
    _G.assert((nil ~= key), "Missing argument key on /Users/chuwy/workspace/ucm.nvim/fnl/ucm/model/init.fnl:14")
    return utils["starts-with"](key, hash)
  end
  return utils["find-by-key"](definitions, _1_)
end
return M
