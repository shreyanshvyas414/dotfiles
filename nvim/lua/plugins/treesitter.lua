return {
	{
		"shreyanshvyas414/ts-node-select",
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
		},
		config = function()
			require("ts-node-select").setup()
		end,
	},
	{
		-- Basic Configuration for nvim treesitter textobjects
		"nvim-treesitter/nvim-treesitter-textobjects",
		branch = "main", -- CRITICAL: Use main branch, NOT master
		dependencies = {
			{ "nvim-treesitter/nvim-treesitter", branch = "main" },
		},
		config = function()
			-- SETUP: Configure textobjects behavior

			require("nvim-treesitter-textobjects").setup({
				select = {
					-- Automatically jump forward to textobj, similar to targets.vim
					lookahead = true,

					-- Choose the select mode (charwise, linewise, blockwise)
					selection_modes = {
						["@parameter.outer"] = "v", -- charwise
						["@function.outer"] = "V", -- linewise
						["@class.outer"] = "<c-v>", -- blockwise
					},

					-- Include surrounding whitespace
					include_surrounding_whitespace = true,
				},
				move = {
					-- Add movements to jumplist (Ctrl-o to go back)
					set_jumps = true,
				},
			})

			-- HELPER: Check if treesitter parser exists for current buffer
			local function has_parser()
				local buf = vim.api.nvim_get_current_buf()
				local lang = vim.treesitter.language.get_lang(vim.bo[buf].filetype)
				if not lang then
					return false
				end
				return pcall(vim.treesitter.get_parser, buf, lang)
			end

			-- HELPER: Wrap textobject functions to check for parser first
			local function safe_textobject(func)
				return function(...)
					if not has_parser() then
						vim.notify("No treesitter parser for filetype: " .. vim.bo.filetype, vim.log.levels.WARN)
						return
					end
					func(...)
				end
			end

			-- SELECT TEXT OBJECTS

			local select = require("nvim-treesitter-textobjects.select")

			-- Functions
			vim.keymap.set(
				{ "x", "o" },
				"af",
				safe_textobject(function()
					select.select_textobject("@function.outer", "textobjects")
				end),
				{ desc = "Select outer function" }
			)

			vim.keymap.set(
				{ "x", "o" },
				"if",
				safe_textobject(function()
					select.select_textobject("@function.inner", "textobjects")
				end),
				{ desc = "Select inner function" }
			)

			-- Classes
			vim.keymap.set(
				{ "x", "o" },
				"ac",
				safe_textobject(function()
					select.select_textobject("@class.outer", "textobjects")
				end),
				{ desc = "Select outer class" }
			)

			vim.keymap.set(
				{ "x", "o" },
				"ic",
				safe_textobject(function()
					select.select_textobject("@class.inner", "textobjects")
				end),
				{ desc = "Select inner class" }
			)

			-- Comments
			vim.keymap.set(
				{ "x", "o" },
				"ao",
				safe_textobject(function()
					select.select_textobject("@comment.outer", "textobjects")
				end),
				{ desc = "Select outer comment" }
			)

			vim.keymap.set(
				{ "x", "o" },
				"io",
				safe_textobject(function()
					select.select_textobject("@comment.inner", "textobjects")
				end),
				{ desc = "Select inner comment" }
			)

			-- Parameters
			vim.keymap.set(
				{ "x", "o" },
				"aa",
				safe_textobject(function()
					select.select_textobject("@parameter.outer", "textobjects")
				end),
				{ desc = "Select outer parameter" }
			)

			vim.keymap.set(
				{ "x", "o" },
				"ia",
				safe_textobject(function()
					select.select_textobject("@parameter.inner", "textobjects")
				end),
				{ desc = "Select inner parameter" }
			)

			-- Scopes (from locals.scm)
			vim.keymap.set(
				{ "x", "o" },
				"as",
				safe_textobject(function()
					select.select_textobject("@local.scope", "locals")
				end),
				{ desc = "Select language scope" }
			)

			-- SWAP TEXT OBJECTS

			local swap = require("nvim-treesitter-textobjects.swap")

			vim.keymap.set(
				"n",
				"<leader>a",
				safe_textobject(function()
					swap.swap_next("@parameter.inner")
				end),
				{ desc = "Swap with next parameter" }
			)

			vim.keymap.set(
				"n",
				"<leader>A",
				safe_textobject(function()
					swap.swap_previous("@parameter.inner")
				end),
				{ desc = "Swap with previous parameter" }
			)

			-- MOVE TO TEXT OBJECTS
			local move = require("nvim-treesitter-textobjects.move")

			-- Functions
			vim.keymap.set(
				{ "n", "x", "o" },
				"]m",
				safe_textobject(function()
					move.goto_next_start("@function.outer", "textobjects")
				end),
				{ desc = "Next function start" }
			)

			vim.keymap.set(
				{ "n", "x", "o" },
				"]M",
				safe_textobject(function()
					move.goto_next_end("@function.outer", "textobjects")
				end),
				{ desc = "Next function end" }
			)

			vim.keymap.set(
				{ "n", "x", "o" },
				"[m",
				safe_textobject(function()
					move.goto_previous_start("@function.outer", "textobjects")
				end),
				{ desc = "Previous function start" }
			)

			vim.keymap.set(
				{ "n", "x", "o" },
				"[M",
				safe_textobject(function()
					move.goto_previous_end("@function.outer", "textobjects")
				end),
				{ desc = "Previous function end" }
			)

			-- Classes
			vim.keymap.set(
				{ "n", "x", "o" },
				"]]",
				safe_textobject(function()
					move.goto_next_start("@class.outer", "textobjects")
				end),
				{ desc = "Next class start" }
			)

			vim.keymap.set(
				{ "n", "x", "o" },
				"][",
				safe_textobject(function()
					move.goto_next_end("@class.outer", "textobjects")
				end),
				{ desc = "Next class end" }
			)

			vim.keymap.set(
				{ "n", "x", "o" },
				"[[",
				safe_textobject(function()
					move.goto_previous_start("@class.outer", "textobjects")
				end),
				{ desc = "Previous class start" }
			)

			vim.keymap.set(
				{ "n", "x", "o" },
				"[]",
				safe_textobject(function()
					move.goto_previous_end("@class.outer", "textobjects")
				end),
				{ desc = "Previous class end" }
			)

			-- Conditionals
			vim.keymap.set(
				{ "n", "x", "o" },
				"]i",
				safe_textobject(function()
					move.goto_next_start("@conditional.outer", "textobjects")
				end),
				{ desc = "Next conditional start" }
			)

			vim.keymap.set(
				{ "n", "x", "o" },
				"[i",
				safe_textobject(function()
					move.goto_previous_start("@conditional.outer", "textobjects")
				end),
				{ desc = "Previous conditional start" }
			)

			-- Loops
			vim.keymap.set(
				{ "n", "x", "o" },
				"]l",
				safe_textobject(function()
					move.goto_next_start("@loop.outer", "textobjects")
				end),
				{ desc = "Next loop start" }
			)

			vim.keymap.set(
				{ "n", "x", "o" },
				"[l",
				safe_textobject(function()
					move.goto_previous_start("@loop.outer", "textobjects")
				end),
				{ desc = "Previous loop start" }
			)

			-- REPEATABLE MOVEMENTS
			local ts_repeat_move = require("nvim-treesitter-textobjects.repeatable_move")

			-- Wrap repeatable movements with parser check
			vim.keymap.set({ "n", "x", "o" }, ";", function()
				if has_parser() then
					ts_repeat_move.repeat_last_move_next()
				else
					-- Fallback to default ; behavior
					vim.cmd("normal! ;")
				end
			end)

			vim.keymap.set({ "n", "x", "o" }, ",", function()
				if has_parser() then
					ts_repeat_move.repeat_last_move_previous()
				else
					-- Fallback to default , behavior
					vim.cmd("normal! ,")
				end
			end)

			-- Make builtin f, F, t, T also repeatable (these work without treesitter)
			vim.keymap.set({ "n", "x", "o" }, "f", ts_repeat_move.builtin_f_expr, { expr = true })
			vim.keymap.set({ "n", "x", "o" }, "F", ts_repeat_move.builtin_F_expr, { expr = true })
			vim.keymap.set({ "n", "x", "o" }, "t", ts_repeat_move.builtin_t_expr, { expr = true })
			vim.keymap.set({ "n", "x", "o" }, "T", ts_repeat_move.builtin_T_expr, { expr = true })
		end,
	},
}
