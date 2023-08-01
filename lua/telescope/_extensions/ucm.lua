-- [nfnl] Compiled from fnl/telescope/_extensions/ucm.fnl by https://github.com/Olical/nfnl, do not edit.
local uv = vim.loop
local telescope = require("telescope")
local endpoint = require("ucm.utils.endpoint")
local list = require("telescope._extensions.ucm.pickers.list")
local find = require("telescope._extensions.ucm.pickers.find")
local projects = require("telescope._extensions.ucm.pickers.projects")
local function get_picker(p)
  local popup_open_3f = false
  local function _1_(_3fopts)
    local timer = uv.new_timer()
    local url = endpoint.get()
    local function _2_()
      if (url == nil) then
        if (popup_open_3f == false) then
          popup_open_3f = true
          local function _3_()
            local function _4_()
              return nil
            end
            return endpoint["check-endpoint"](url, _4_)
          end
          return vim.schedule(_3_)
        else
          return nil
        end
      else
        local function _6_()
          timer:stop()
          return p(_3fopts):find()
        end
        return vim.schedule(_6_)
      end
    end
    return uv.timer_start(timer, 0, 2000, _2_)
  end
  return _1_
end
local function _8_()
  return nil
end
return telescope.register_extension({setup = _8_, exports = {projects = get_picker(projects.picker), list = get_picker(list.picker), find = get_picker(find.picker)}})
