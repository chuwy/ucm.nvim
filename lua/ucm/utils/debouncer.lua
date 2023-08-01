local make_entry = require "telescope.make_entry"

local M = {}

M.timer = nil

-- This where the async_fn output goes. It can be a `Job`!
M._job = nil

-- For some reasons I couldn't make 'telescope.debounce' working
function M.debounce(thunk, ms)
  if (M.timer ~= nil) then
    M.timer:stop()
  end

  -- That's probably a good idea, but unfortunately a killed job produces JSON parsing error
  -- which itself results into a dead coroutine
  if (M._job ~= nil and M._job.shutdown) then
    M._job:shutdown()   -- Not always works out, can hang
  end

  M.timer = vim.loop.new_timer()

  M.timer:start(ms, 0, function()
    thunk()
    M.timer:stop()
  end)
end

function M.async_finder(opts)
  local async_fn = opts.async_fn
  local entry_maker = opts.entry_maker or make_entry.gen_from_string(opts)


  local callable = function(_, prompt, process_result, process_complete)
    local function on_result(i, item)
      local entry = entry_maker(item)
      if entry then
        entry.index = i
      end
      vim.schedule(function ()
        if process_result(entry) then
          return
        end
      end)
    end


    M.debounce(function ()
      M._job = async_fn(on_result, process_complete)(prompt)
    end, 500)

  end

  return setmetatable({
    close = function()
      if opts.close then
        opts.close(true)
      end
    end,
  }, {
    __call = callable,
  })
end


return M
