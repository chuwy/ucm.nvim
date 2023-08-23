-- [nfnl] Compiled from fnl/ucm/model/http.fnl by https://github.com/Olical/nfnl, do not edit.
local str = require("nfnl.string")
local curl = require("plenary.curl")
local utils = require("ucm.utils")
local endpoint = require("ucm.utils.endpoint")
local M = {}
local function request(service, q)
  local url = (endpoint.get() .. service)
  local res = curl.get(url, {query = q})
  return vim.json.decode(res.body)
end
M["get-term"] = function(hash)
  return request(("definitions/terms/by-hash/" .. utils["strip-hash"](hash) .. "/summary"))
end
M["get-type"] = function(hash)
  return request(("definitions/types/by-hash/" .. utils["strip-hash"](hash) .. "/summary"))
end
M["get-definition"] = function(fqn, relative_to)
  return request("getDefinition", {names = fqn, relativeTo = relative_to})
end
M.projects = function()
  return request("projects")
end
M.branches = function(project)
  return request(("projects/" .. project:gsub("/", "%%2F") .. "/branches"))
end
M.list = function(path, relative_to)
  local query
  if str["blank?"](path) then
    query = nil
  else
    query = {namespace = path, relativeTo = relative_to}
  end
  return request("list", query)
end
M.find = function(query)
  return request("find", {query = query})
end
local function request_async(service, q, callback)
  return curl.get((endpoint.get() .. service), {query = q, callback = callback, raw = {"--max-time", 10}})
end
M["find-async"] = function(query, relative_to, callback)
  return request_async("find", {query = query, relativeTo = relative_to}, callback)
end
return M
