-- [nfnl] Compiled from fnl/ucm.fnl by https://github.com/Olical/nfnl, do not edit.
local uv = vim.loop
local config = require("ucm.config")
local ucm_state = require("ucm.state")
local utils = require("ucm.utils")
local path = require("ucm.utils.path")
local function get_state_file()
  return path.path_join(vim.fn.stdpath("data"), "ucm.json")
end
local function create_state_file()
  local state_file = get_state_file()
  local function _1_(_3ferr, _3ffd)
    if (_3ferr ~= nil) then
      local function _2_()
        return utils.notify(("Could not create an ucm.nvim state file at " .. state_file))
      end
      return vim.schedule(_2_)
    else
      local function _3_()
        do local _ = uv.fs_close end
        return _3ffd
      end
      return uv.fs_write(_3ffd, "{}", _3_)
    end
  end
  return uv.fs_open(get_state_file(), "w", 438, _1_)
end
local function notify_state_file_error(err)
  local function _5_()
    return utils.notify("ucm.nvim state file error. ", err)
  end
  return vim.schedule(_5_)
end
local function state_file_set(data)
  local parsed = vim.json.decode(data)
  local project_branch = parsed["project-branch"]
  local project
  if (project_branch == nil) then
    project = nil
  else
    project = project_branch.project
  end
  local branch
  if (project_branch == nil) then
    branch = nil
  else
    branch = project_branch.branch
  end
  ucm_state["set-project"](project)
  return ucm_state["set-branch"](branch)
end
local function read_state_file()
  local function _8_(_3ferr, _3ffd)
    if (_3ferr == nil) then
      local function _9_(_3ferr0, stat)
        _G.assert((nil ~= stat), "Missing argument stat on /Users/chuwy/workspace/ucm.nvim/fnl/ucm.fnl:38")
        if (_3ferr0 == nil) then
          local function _10_(_3ferr1, data)
            _G.assert((nil ~= data), "Missing argument data on /Users/chuwy/workspace/ucm.nvim/fnl/ucm.fnl:41")
            if (_3ferr1 == nil) then
              state_file_set(data)
              return uv.fs_close(_3ffd)
            else
              return notify_state_file_error(_3ferr1)
            end
          end
          return uv.fs_read(_3ffd, stat.size, 0, _10_)
        else
          return notify_state_file_error(_3ferr0)
        end
      end
      return uv.fs_fstat(_3ffd, _9_)
    else
      return create_state_file()
    end
  end
  return uv.fs_open(get_state_file(), "r", 438, _8_)
end
local M = {}
M.setup = function(opts)
  read_state_file()
  config.endpoint = opts.endpoint
  return nil
end
M["save-state"] = function()
  local data = {["project-branch"] = ucm_state["get-project-branch"]()}
  local function _14_(_3fopen_err, _3ffd)
    local close
    local function _15_()
      do local _ = uv.fs_close end
      return _3ffd
    end
    close = _15_
    if (_3fopen_err == nil) then
      return uv.fs_write(_3ffd, vim.json.encode(data), close)
    else
      return nil
    end
  end
  return uv.fs_open(get_state_file(), "w", 438, _14_)
end
return M
