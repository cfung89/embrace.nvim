local M = {}

M.setup = function(opts)
	M.default_opts = {
		keymap = "S",
		cmd = "Surround",
	}
	M.config = vim.tbl_deep_extend("force", M.default_opts, opts or {})

	vim.api.nvim_create_user_command(M.config.cmd, function()
		local status, surround = pcall(require, "embrace.surround")
		if not status then
			print("Error: 'embrace.surround' module not found!")
			return
		end
		surround.surround()
	end, { desc = "Surround selected text by the given input" })

	vim.keymap.set("v", M.config.keymap, function()
		local status, surround = pcall(require, "embrace.surround")
		if not status then
			print("Error: 'embrace.surround' module not found!")
			return
		end
		surround.surround()
	end)
end

return M
