-- [nfnl] Compiled from fnl/ucm/model/payloads.fnl by https://github.com/Olical/nfnl, do not edit.
local utils = require("ucm.utils")
local render = require("ucm.render")
local M = {}
M["get-find-entry-display"] = function(entry)
  local _1_ = entry
  if ((_G.type(_1_) == "table") and true and ((_G.type((_1_)[2]) == "table") and ((_G.type(((_1_)[2]).contents) == "table") and ((_G.type((((_1_)[2]).contents).namedTerm) == "table") and (nil ~= ((((_1_)[2]).contents).namedTerm).termName) and (nil ~= ((((_1_)[2]).contents).namedTerm).termType))))) then
    local _ = (_1_)[1]
    local name = ((((_1_)[2]).contents).namedTerm).termName
    local tpe = ((((_1_)[2]).contents).namedTerm).termType
    return render["trm-typed"](name, tpe)
  elseif ((_G.type(_1_) == "table") and true and ((_G.type((_1_)[2]) == "table") and ((_G.type(((_1_)[2]).contents) == "table") and ((_G.type((((_1_)[2]).contents).namedType) == "table") and (nil ~= ((((_1_)[2]).contents).namedType).typeName)) and ((_G.type((((_1_)[2]).contents).typeDef) == "table") and (nil ~= ((((_1_)[2]).contents).typeDef).contents))))) then
    local _ = (_1_)[1]
    local name = ((((_1_)[2]).contents).namedType).typeName
    local tpe = ((((_1_)[2]).contents).typeDef).contents
    return render["tpe-typed"](name, tpe)
  elseif (nil ~= _1_) then
    local other = _1_
    return utils.notify(other)
  else
    return nil
  end
end
M["get-find-entry-name"] = function(entry)
  local _3_ = entry
  if ((_G.type(_3_) == "table") and true and ((_G.type((_3_)[2]) == "table") and ((_G.type(((_3_)[2]).contents) == "table") and ((_G.type((((_3_)[2]).contents).namedTerm) == "table") and (nil ~= ((((_3_)[2]).contents).namedTerm).termName) and (nil ~= ((((_3_)[2]).contents).namedTerm).termType))))) then
    local _ = (_3_)[1]
    local name = ((((_3_)[2]).contents).namedTerm).termName
    local t = ((((_3_)[2]).contents).namedTerm).termType
    return name
  elseif ((_G.type(_3_) == "table") and true and ((_G.type((_3_)[2]) == "table") and ((_G.type(((_3_)[2]).contents) == "table") and ((_G.type((((_3_)[2]).contents).namedType) == "table") and (nil ~= ((((_3_)[2]).contents).namedType).typeName))))) then
    local _ = (_3_)[1]
    local name = ((((_3_)[2]).contents).namedType).typeName
    return (name .. " type")
  elseif (nil ~= _3_) then
    local other = _3_
    return utils.notify(other)
  else
    return nil
  end
end
M["up-namespace"] = {contents = {namespaceName = "..", namespaceHash = nil, namespaceSize = nil}, tag = "Subnamespace"}
M["from-list-root-payload"] = function(list)
  local _5_ = list
  if ((_G.type(_5_) == "table") and (nil ~= (_5_).namespaceListingChildren) and (nil ~= (_5_).namespaceListingFQN) and true) then
    local namespaceListingChildren = (_5_).namespaceListingChildren
    local namespaceListingFQN = (_5_).namespaceListingFQN
    local _namespaceListingHash = (_5_).namespaceListingHash
    if (namespaceListingFQN == "") then
      return namespaceListingChildren
    else
      table.insert(namespaceListingChildren, M["up-namespace"])
      return namespaceListingChildren
    end
  else
    return nil
  end
end
M["get-list-entry-display"] = function(entry)
  local _8_ = entry
  if ((_G.type(_8_) == "table") and ((_G.type((_8_).contents) == "table") and (nil ~= ((_8_).contents).termName) and true and true and true) and (nil ~= (_8_).tag)) then
    local termName = ((_8_).contents).termName
    local _termHash = ((_8_).contents).termHash
    local _termTag = ((_8_).contents).termTag
    local _termType = ((_8_).contents).termType
    local tag = (_8_).tag
    return {render.colored("\243\176\138\149", tag), termName, ""}
  elseif ((_G.type(_8_) == "table") and ((_G.type((_8_).contents) == "table") and (nil ~= ((_8_).contents).namespaceName) and true and (nil ~= ((_8_).contents).namespaceSize)) and (nil ~= (_8_).tag)) then
    local namespaceName = ((_8_).contents).namespaceName
    local _namespaceHash = ((_8_).contents).namespaceHash
    local namespaceSize = ((_8_).contents).namespaceSize
    local tag = (_8_).tag
    return {render.colored("\239\146\135", tag), namespaceName, render.colored(tostring(namespaceSize), "SubnamespaceSize")}
  elseif ((_G.type(_8_) == "table") and ((_G.type((_8_).contents) == "table") and (((_8_).contents).namespaceName == "..") and (((_8_).contents).namespaceHash == nil) and (((_8_).contents).namespaceSize == nil)) and true) then
    local _tag = (_8_).tag
    return {"", "..", ""}
  elseif ((_G.type(_8_) == "table") and ((_G.type((_8_).contents) == "table") and true and (nil ~= ((_8_).contents).typeName) and true) and (nil ~= (_8_).tag)) then
    local _typeHash = ((_8_).contents).typeHash
    local typeName = ((_8_).contents).typeName
    local _typeTag = ((_8_).contents).typeTag
    local tag = (_8_).tag
    return {render.colored("\238\174\185", tag), typeName, ""}
  elseif ((_G.type(_8_) == "table") and ((_G.type((_8_).contents) == "table") and (nil ~= ((_8_).contents).patchName)) and ((_8_).tag == "PatchObject")) then
    local name = ((_8_).contents).patchName
    return {"\243\177\158\170", name, ""}
  elseif (nil ~= _8_) then
    local other = _8_
    return utils.notify({msg = "Pattern match failed", value = other})
  else
    return nil
  end
end
M["get-list-entry-name"] = function(entry)
  local _10_ = entry
  if ((_G.type(_10_) == "table") and ((_G.type((_10_).contents) == "table") and (nil ~= ((_10_).contents).termName) and true and true and true) and true) then
    local termName = ((_10_).contents).termName
    local _termHash = ((_10_).contents).termHash
    local _termTag = ((_10_).contents).termTag
    local _termType = ((_10_).contents).termType
    local _tag = (_10_).tag
    return termName
  elseif ((_G.type(_10_) == "table") and ((_G.type((_10_).contents) == "table") and (((_10_).contents).namespaceName == "/") and true and true) and ((_10_).tag == "Subnamespace")) then
    local _namespaceHash = ((_10_).contents).namespaceHash
    local _namespaceSize = ((_10_).contents).namespaceSize
    return nil
  elseif ((_G.type(_10_) == "table") and ((_G.type((_10_).contents) == "table") and (nil ~= ((_10_).contents).namespaceName) and true and true) and ((_10_).tag == "Subnamespace")) then
    local namespaceName = ((_10_).contents).namespaceName
    local _namespaceHash = ((_10_).contents).namespaceHash
    local _namespaceSize = ((_10_).contents).namespaceSize
    return namespaceName
  elseif ((_G.type(_10_) == "table") and ((_G.type((_10_).contents) == "table") and (((_10_).contents).namespaceName == "..") and (((_10_).contents).namespaceHash == nil) and (((_10_).contents).namespaceSize == nil)) and ((_10_).tag == "Subnamespace")) then
    return ".."
  elseif ((_G.type(_10_) == "table") and ((_G.type((_10_).contents) == "table") and true and (nil ~= ((_10_).contents).typeName) and true) and ((_10_).tag == "TypeObject")) then
    local _typeHash = ((_10_).contents).typeHash
    local typeName = ((_10_).contents).typeName
    local _typeTag = ((_10_).contents).typeTag
    return typeName
  elseif ((_G.type(_10_) == "table") and ((_G.type((_10_).contents) == "table") and (nil ~= ((_10_).contents).patchName)) and ((_10_).tag == "PatchObject")) then
    local name = ((_10_).contents).patchName
    return name
  elseif (nil ~= _10_) then
    local other = _10_
    return utils.notify({msg = "Pattern match failed", value = other})
  else
    return nil
  end
end
M["get-project-name"] = function(project)
  local _12_ = project
  if ((_G.type(_12_) == "table") and (nil ~= (_12_).name) and true and true) then
    local name = (_12_).name
    local _hash = (_12_).hash
    local _owner = (_12_).owner
    return name
  else
    return nil
  end
end
return M
