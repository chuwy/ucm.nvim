-- [nfnl] Compiled from fnl/ucm/utils.fnl by https://github.com/Olical/nfnl, do not edit.
local str = require("nfnl.string")
local M = {}
M.notify = function(x)
  return require("notify")(vim.inspect(x))
end
local function strip_prefix(seg, prefix)
  if (prefix == nil) then
    return seg
  else
    if M["starts-with"](seg, (prefix .. ".")) then
      return seg:sub((#prefix + 1))
    else
      return seg
    end
  end
end
M["starts-with"] = function(s, suffix)
  return ((suffix == "") or (s:sub(1, #suffix) == suffix))
end
M["find-by-key"] = function(tbl, pred)
  for key, val in pairs(tbl) do
    if pred(key) then
      return val
    else
    end
  end
  return nil
end
M.init = function(xs)
  if (#xs < 2) then
    return {}
  else
    return vim.list_slice(xs, 1, (#xs - 1))
  end
end
M["split-string"] = function(str0, sep)
  local t = {}
  for str1 in string.gmatch(str0, ("([^" .. sep .. "]+)")) do
    table.insert(t, str1)
  end
  return t
end
M["strip-hash"] = function(hash)
  return hash:sub(2)
end
return M
