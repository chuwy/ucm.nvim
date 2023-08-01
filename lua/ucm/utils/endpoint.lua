-- [nfnl] Compiled from fnl/ucm/utils/endpoint.fnl by https://github.com/Olical/nfnl, do not edit.
local str = require("nfnl.string")
local curl = require("plenary.curl")
local config = require("ucm.config")
local utils = require("ucm.utils")
local function endswith(s, suffix)
  return (str["blank?"](suffix) or (s:sub((0 - #suffix)) == suffix))
end
local M = {}
M.get = function()
  local endpoint = M._endpoint
  local known
  if endpoint then
    known = endpoint
  else
    known = config.endpoint
  end
  if (known == nil) then
    return known
  else
    if endswith(known, "/") then
      return known
    else
      return (known .. "/")
    end
  end
end
M.set = function(s)
  local link
  if s.args then
    link = s.args
  else
    link = s
  end
  local result
  if endswith(link, "/") then
    result = link
  else
    result = (link .. "/")
  end
  M._endpoint = result
  return nil
end
M["check-endpoint"] = function(endpoint, callback)
  if (endpoint == nil) then
    return vim.ui.input({prompt = "endpoint is missing! Please, provide an URI (you can get it via ucm `api`): "}, M["check-endpoint-url"](callback))
  else
    return nil
  end
end
M["check-endpoint-url"] = function(callback)
  local function _7_(endpoint)
    _G.assert((nil ~= endpoint), "Missing argument endpoint on /Users/chuwy/workspace/ucm.nvim/fnl/ucm/utils/endpoint.fnl:34")
    local function _8_(r)
      _G.assert((nil ~= r), "Missing argument r on /Users/chuwy/workspace/ucm.nvim/fnl/ucm/utils/endpoint.fnl:35")
      if ((r.status == 200) and (r.exit == 0)) then
        M.set(endpoint)
        return callback()
      else
        return utils.notify(("The endpoint " .. endpoint .. " is invalid. Try resetting it with :UcmSetApi"))
      end
    end
    return curl.get(endpoint, {callback = _8_})
  end
  return _7_
end
M.wrap = function(f, ...)
  local args = {...}
  local function _10_()
    return f(args)
  end
  return M["check-endpoint"](M.get(), _10_)
end
return M
