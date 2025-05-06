local config = require("embrace.config")

local M = {}

M.setup = function(opts)
	config.set(opts)

	if config.opts.cmd then
		vim.api.nvim_create_user_command(config.opts.cmd, require("embrace.surround").surround,
			{ desc = "Surround selected text by the given input" })
	end
	if config.opts.keymaps.surround then
		vim.keymap.set("v", config.opts.keymaps.surround, require("embrace.surround").surround)
	end
end

return M
