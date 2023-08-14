-- [nfnl] Compiled from fnl/ucm/state.fnl by https://github.com/Olical/nfnl, do not edit.
local utils = require("ucm.utils")
local payloads = require("ucm.model.payloads")
local function parse_project_branch(path)
  local sliced = vim.list_slice(utils["split-string"](path, "."), 1, 4)
  local _1_ = sliced
  if ((_G.type(_1_) == "table") and ((_1_)[1] == "__projects") and (nil ~= (_1_)[2]) and ((_1_)[3] == "branches") and (nil ~= (_1_)[4])) then
    local project = (_1_)[2]
    local branch = (_1_)[4]
    return {project = project, branch = branch}
  elseif ((_G.type(_1_) == "table") and ((_1_)[1] == "__projects") and (nil ~= (_1_)[2]) and ((_1_)[3] == "branches")) then
    local project = (_1_)[2]
    return {project = project, branch = nil}
  elseif ((_G.type(_1_) == "table") and ((_1_)[1] == "__projects") and (nil ~= (_1_)[2])) then
    local project = (_1_)[2]
    return {project = project, branch = nil}
  elseif true then
    local _ = _1_
    return {project = nil, branch = nil}
  else
    return nil
  end
end
local M = {}
M["list-path"] = {}
M["project-branch"] = {}
M["get-relative-to"] = function()
  local _3_ = M["project-branch"]
  if ((_G.type(_3_) == "table") and ((_3_).project == nil) and ((_3_).branch == nil)) then
    return nil
  elseif ((_G.type(_3_) == "table") and (nil ~= (_3_).project) and ((_3_).branch == nil)) then
    local project = (_3_).project
    return ("__projects." .. project)
  elseif ((_G.type(_3_) == "table") and (nil ~= (_3_).project) and (nil ~= (_3_).branch)) then
    local project = (_3_).project
    local branch = (_3_).branch
    return ("__projects." .. project .. ".branches." .. branch)
  else
    return nil
  end
end
M["list-path-root?"] = function()
  return (M["list-path"] == {})
end
M["get-branch"] = function()
  if (M["project-branch"] == nil) then
    return nil
  else
    return (M["project-branch"]).branch
  end
end
M["list-path-get"] = function()
  return table.concat(M["list-path"], ".")
end
M["list-path-get-fqn"] = function(name)
  return table.concat(vim.list_extend(M["list-path"], {name}), ".")
end
M["set-path"] = function(selection)
  local value = selection.value
  local name = payloads["get-list-entry-name"](value)
  if (name == "..") then
    table.remove(M["list-path"])
  else
    if (M["list-path"] ~= {}) then
      table.insert(M["list-path"], name)
    else
    end
  end
  local project_branch = parse_project_branch(M["list-path-get"]())
  M["project-branch"] = project_branch
  return nil
end
return M
