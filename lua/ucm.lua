-- [nfnl] Compiled from fnl/ucm.fnl by https://github.com/Olical/nfnl, do not edit.
local config = require("ucm.config")
local M = {}
M.setup = function(opts)
  config.endpoint = opts.endpoint
  return nil
end
return M
