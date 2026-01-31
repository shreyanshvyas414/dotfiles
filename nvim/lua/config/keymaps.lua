vim.keymap.set("n", "-", "<cmd>Oil --float<CR>", { desc = "Open parent directory in oil." })
vim.keymap.set("n", "gl", function()
	vim.diagnostic.open_float()
end, { desc = "Open diagnostic in float." })

vim.keymap.set("n", "<leader>cf", function()
	require("conform").format()
end, { desc = "Format current file" })
