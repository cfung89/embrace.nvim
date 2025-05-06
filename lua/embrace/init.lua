local config = require("embrace.config")

local M = {}

M.setup = function(opts)
	config.set(opts)

	if config.opts.keymaps.surround then
		vim.keymap.set("v", config.opts.keymaps.surround, require("embrace.surround").surround)
	end
end

return M
