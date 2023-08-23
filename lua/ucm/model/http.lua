-- [nfnl] Compiled from fnl/ucm/model/http.fnl by https://github.com/Olical/nfnl, do not edit.
local str = require("nfnl.string")
local curl = require("plenary.curl")
local utils = require("ucm.utils")
local endpoint = require("ucm.utils.endpoint")
local M = {}
local function url_encoded(project_or_branch)
  return project_or_branch:gsub("/", "%%2F")
end
local function get_service(root, service)
  local _1_ = root
  if ((_G.type(_1_) == "table") and (nil ~= (_1_).project) and (nil ~= (_1_).branch)) then
    local project = (_1_).project
    local branch = (_1_).branch
    return ("projects/" .. url_encoded(project) .. "/branches/" .. url_encoded(branch) .. "/" .. service)
  elseif true then
    local _ = _1_
    return utils.notify({msg = "get-service called without proper root (you need to pick a project and a branch)", root = root, service = service})
  else
    return nil
  end
end
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
M["get-definition"] = function(root, fqn, relative_to)
  return request(get_service(root, "getDefinition"), {names = fqn, relativeTo = relative_to})
end
M.projects = function()
  return request("projects")
end
M.branches = function(project)
  return request(("projects/" .. url_encoded(project) .. "/branches"))
end
M.list = function(root, path)
  local query
  if str["blank?"](path) then
    query = nil
  else
    query = {namespace = path}
  end
  return request(get_service(root, "list"), query)
end
M.find = function(query)
  return request("find", {query = query})
end
local function request_async(service, q, callback)
  return curl.get((endpoint.get() .. service), {query = q, callback = callback, raw = {"--max-time", 10}})
end
M["find-async"] = function(root, query, callback)
  return request_async(get_service(root, "find"), {query = query}, callback)
end
return M
