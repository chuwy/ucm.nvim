-- [nfnl] Compiled from fnl/ucm/state.fnl by https://github.com/Olical/nfnl, do not edit.
local payloads = require("ucm.model.payloads")
local M = {}
M["list-path"] = {}
M["project-branch"] = {}
M["get-relative-to"] = function()
  local _1_ = M["project-branch"]
  if ((_G.type(_1_) == "table") and ((_1_).project == nil) and ((_1_).branch == nil)) then
    return nil
  elseif ((_G.type(_1_) == "table") and (nil ~= (_1_).project) and ((_1_).branch == nil)) then
    local project = (_1_).project
    return ("__projects." .. project)
  elseif ((_G.type(_1_) == "table") and (nil ~= (_1_).project) and (nil ~= (_1_).branch)) then
    local project = (_1_).project
    local branch = (_1_).branch
    return ("__projects." .. project .. ".branches." .. branch)
  else
    return nil
  end
end
M["get-project-branch"] = function()
  return M["project-branch"]
end
M["list-path-root?"] = function()
  return (M["list-path"] == {})
end
M["get-project-branch-path"] = function()
  local _3_ = M["project-branch"]
  if ((_G.type(_3_) == "table") and ((_3_).project == nil) and ((_3_).branch == nil)) then
    return nil
  elseif ((_G.type(_3_) == "table") and (nil ~= (_3_).project) and ((_3_).branch == nil)) then
    local project = (_3_).project
    return project
  elseif ((_G.type(_3_) == "table") and (nil ~= (_3_).project) and (nil ~= (_3_).branch)) then
    local project = (_3_).project
    local branch = (_3_).branch
    return (project .. "/" .. branch)
  else
    return nil
  end
end
M["get-project"] = function()
  if (M["project-branch"] == nil) then
    return nil
  else
    return (M["project-branch"]).project
  end
end
M["get-branch"] = function()
  if (M["project-branch"] == nil) then
    return nil
  else
    return (M["project-branch"]).branch
  end
end
M["set-project"] = function(project_name)
  if (project_name ~= M["get-project"]()) then
    M["project-branch"] = {project = project_name, branch = nil}
    M["list-path"] = {}
    return nil
  else
    return nil
  end
end
M["set-branch"] = function(branch_name)
  if (branch_name ~= M["get-branch"]()) then
    M["project-branch"].branch = branch_name
    M["list-path"] = {}
    return nil
  else
    return nil
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
    return table.remove(M["list-path"])
  else
    if (M["list-path"] ~= {}) then
      return table.insert(M["list-path"], name)
    else
      return nil
    end
  end
end
return M
