vim.api.nvim_create_user_command("UcmApiSet", require("ucm.utils.endpoint").set, { nargs = '?' })
