-- This is not a stand-alone NeoVim config. Rather, it is for customizing the meta-package "AstroNvim"
-- https://astronvim.github.io/Configuration/manage_user_config

local edit_config = function()
	vim.cmd("e ~/.config/nvim/lua/user/init.lua")
end

return {
	colorscheme = "catppuccin",
	options = {
		opt = {
			scrolloff = 20,
			wrap = true,
			cmdheight = 1,
		},
	},
	mappings = {
		n = {
			["<tab>"] = { ":wincmd w<cr>", desc = "Next window" },
			["<leader>,"] = { edit_config, desc = "Edit user config file" },
			["gV"] = { "`[v`]", desc = "Select the text you just pasted" },
			["<leader>x{"] = { "<i{0]}dd[{dd", desc = "Remove wrapping curly brace pair" },
			["<leader>x("] = { "<i(0])dd[(dd", desc = "Remove wrapping parentheses" },
			["<leader>x["] = { "<i[0]]dd[[dd", desc = "Remove wrapping square bracket pair" },
			["<c-p>"] = { ":Telescope find_files<CR>", desc = "Search files" },
			L = {
				function()
					require("astronvim.utils.buffer").nav(vim.v.count > 0 and vim.v.count or 1)
				end,
				desc = "Next buffer",
			},
			H = {
				function()
					require("astronvim.utils.buffer").nav(-(vim.v.count > 0 and vim.v.count or 1))
				end,
				desc = "Previous buffer",
			},
		},
		i = {
			["<c-l>"] = { "<c-o>O", desc = "Enter newline above current line" },
		},
	},
	lsp = {
		-- easily add or disable built in mappings added during LSP attaching
		mappings = {
			n = {
				["<leader>lw"] = {
					"<cmd>Telescope lsp_dynamic_workspace_symbols<cr>",
					desc = "Show symbols in the whole workspace",
				},
				["<leader>lc"] = {
					"<cmd>Telescope lsp_incoming_calls<cr>",
					desc = "Show incoming calls for this function",
				},
				["<leader>lC"] = {
					"<cmd>Telescope lsp_outgoing_calls<cr>",
					desc = "Show outgoing calls in this function",
				},
				["&d"] = {
					":vsp<cr>:lua vim.lsp.buf.definition()<cr>",
					desc = "Open definition in a vsplit",
				},
				["&T"] = {
					":vsp<cr>:lua vim.lsp.buf.type_definition()<cr>",
					desc = "Open type definition in a vsplit",
				},
			},
		},
		config = {
			lua_ls = {
				settings = {
					Lua = {
						diagnostics = {
							globals = { "vim" },
						},
					},
				},
			},
		},
	},
	plugins = {
		-- override included plugin config
		{
			"goolord/alpha-nvim",
			opts = function(_, opts)
				opts.config.layout[4].val[7] = {
					val = "  Configure",
					opts = {
						shortcut = "SPC ,  ",
						hl_shortcut = "DashboardShortcut",
						align_shortcut = "right",
						width = 36,
						cursor = 5,
						hl = "DashboardCenter",
						text = "  Configure",
						position = "center",
					},
					on_press = edit_config,
					type = "button",
				}
				opts.section.header.val = {
					[[   ,φ≥        ▒                                                                 ]],
					[[ ,@╬╬▒▒       ╬╬▒╖                                            ▄▄                ]],
					[[δ▒╠╬╬╠╠╠╦     ╬╬╬╬▓                                           ╙╙                ]],
					[[╠▒▒╠╬╠╠╠╠▒    ╣╬╬╬╬     ▐QÆT^"▀┐  ,Æ""""▄   Æ"^^▀╗ ╙██    ▐█▌ ██  ██▓▓▀█▓▄▓▀▓█▓ ]],
					[[╠▒▒▒╠└╠╠╠╠╠ε  ╣╬╬╬╬     ▐▌     █ ]▌      ▌ ▌      ▓ ╙█▓  ▐█▓  ██  ██─  ▐██   ╟██]],
					[[╠╠╠╠╠  ╠╬╬╬╬▒ ╣▓▓▓▓     ▐▌     ▓ ▐▌‾‾‾‾‾‾ ▐▌      ╟▌ ╟█▌┌██   ██  ██   ▐██   ╞██]],
					[[╠╠╠╠╠   ╙╬╬╬╬╬╣▓▓▓▓     ▐▌     ▓  ▓        ▓     ,▓   ╟█▓█    ██  ██   ▐██   ╞██]],
					[[╠╠╠╠╠     ╢╬╬╬╣╬▓▓▓     └^     ╙   └"²²"`   └"²²"└     ╙╙`    ▀▀  ▀▀    ▀▀   └▀╙]],
					[[`╝╬╬╬      ╙╬╬╣╣╬▓╜                                                             ]],
					[[   ╚╬        ╣▓▓╙                                                               ]],
				}
			end,
		},
		{
			"jay-babu/mason-nvim-dap.nvim",
			opts = {
				automatic_setup = {
					configurations = function(default)
						default.codelldb[1].program = function()
							return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/target/debug/warp", "file")
						end
						return default
					end,
				},
			},
		},
		{
			"stevearc/aerial.nvim",
			opts = {
				disable_max_lines = 20000,
				-- 4 MiB
				disable_max_size = 4194304,
			},
		},
		{
			"rebelot/heirline.nvim",
			opts = function(_, opts)
				local file_path = {
					{
						provider = function()
							return vim.fn.expand("%")
						end,
					},
					padding = { left = 1, right = 1 },
				}
				table.insert(opts.statusline, 4, file_path)
				return opts
			end,
		},
		{
			"nvim-treesitter/nvim-treesitter",
			dependencies = { "nvim-treesitter/nvim-treesitter-textobjects" },
			opts = {
				auto_install = vim.fn.executable("tree-sitter") == 1,
				ensure_installed = { "lua", "vim" },
				textobjects = {
					select = {
						enable = true,
						lookahead = true,
						keymaps = {
							aA = "@attribute.outer",
							iA = "@attribute.inner",
							aB = "@block.outer",
							iB = "@block.inner",
							aC = "@conditional.outer",
							iC = "@conditional.inner",
							aF = "@function.outer",
							iF = "@function.inner",
							aL = "@loop.outer",
							iL = "@loop.inner",
							aP = "@parameter.outer",
							iP = "@parameter.inner",
							aR = "@regex.outer",
							iR = "@regex.inner",
							aX = "@class.outer",
							iX = "@class.inner",
							aS = "@statement.outer",
							iS = "@statement.outer",
							aN = "@number.inner",
							iN = "@number.inner",
						},
					},
					move = {
						enable = true,
						set_jumps = true,
						goto_next_start = {
							["]b"] = { query = "@block.outer", desc = "Next block start" },
							["]f"] = {
								query = "@function.outer",
								desc = "Next function start",
							},
							["]p"] = {
								query = "@parameter.outer",
								desc = "Next parameter start",
							},
							["]x"] = { query = "@class.outer", desc = "Next class start" },
							["]c"] = {
								query = "@conditional.outer",
								desc = "Next conditional start",
							},
						},
						goto_next_end = {
							["]B"] = { query = "@block.outer", desc = "Next block end" },
							["]F"] = { query = "@function.outer", desc = "Next function end" },
							["]P"] = {
								query = "@parameter.outer",
								desc = "Next parameter end",
							},
							["]X"] = { query = "@class.outer", desc = "Next class end" },
							["]C"] = {
								query = "@conditional.outer",
								desc = "Next conditional end",
							},
						},
						goto_previous_start = {
							["[b"] = { query = "@block.outer", desc = "Previous block start" },
							["[f"] = {
								query = "@function.outer",
								desc = "Previous function start",
							},
							["[p"] = {
								query = "@parameter.outer",
								desc = "Previous parameter start",
							},
							["[x"] = { query = "@class.outer", desc = "Previous class start" },
							["[c"] = {
								query = "@conditional.outer",
								desc = "Previous conditional start",
							},
						},
						goto_previous_end = {
							["[B"] = { query = "@block.outer", desc = "Previous block end" },
							["[F"] = {
								query = "@function.outer",
								desc = "Previous function end",
							},
							["[P"] = {
								query = "@parameter.outer",
								desc = "Previous parameter end",
							},
							["[X"] = { query = "@class.outer", desc = "Previous class end" },
							["[C"] = {
								query = "@conditional.outer",
								desc = "Previous conditional end",
							},
						},
					},
					swap = {
						enable = true,
						swap_next = {
							[">B"] = { query = "@block.outer", desc = "Swap next block" },
							[">F"] = { query = "@function.outer", desc = "Swap next function" },
							[">P"] = {
								query = "@parameter.inner",
								desc = "Swap next parameter",
							},
						},
						swap_previous = {
							["<B"] = { query = "@block.outer", desc = "Swap previous block" },
							["<F"] = {
								query = "@function.outer",
								desc = "Swap previous function",
							},
							["<P"] = {
								query = "@parameter.inner",
								desc = "Swap previous parameter",
							},
						},
					},
					lsp_interop = {
						enable = true,
						border = "single",
						peek_definition_code = {
							["<leader>lp"] = {
								query = "@function.outer",
								desc = "Peek function definition",
							},
							["<leader>lP"] = {
								query = "@class.outer",
								desc = "Peek class definition",
							},
						},
					},
				},
			},
		},
		{
			"williamboman/mason-lspconfig.nvim",
			opts = {
				ensure_installed = { "lua_ls" },
			},
		},
		{
			"nvim-telescope/telescope.nvim",
			opts = function(_, opts)
				local actions = require("telescope.actions")
				local action_state = require("telescope.actions.state")

				-- if picker has selected files, open those too on pressing "enter"
				local multi_open = function(pb)
					local picker = action_state.get_current_picker(pb)
					local multi = picker:get_multi_selection()
					-- the normal enter behaviour
					actions.select_default(pb)
					for _, j in pairs(multi) do
						-- is it a file -> open it as well
						if j.path ~= nil then
							vim.cmd(string.format("%s %s", "edit", j.path))
						end
					end
				end

				opts.defaults.mappings.i["<cr>"] = multi_open
				opts.defaults.mappings.n["<cr>"] = multi_open
				return opts
			end,
		},
		-- custom plugins
		{
			"AstroNvim/astrocommunity",
			{ import = "astrocommunity.colorscheme.catppuccin" },
			{ import = "astrocommunity.motion.nvim-surround" },
			{ import = "astrocommunity.motion.marks-nvim" },
			{ import = "astrocommunity.editing-support.mini-splitjoin" },
			{ import = "astrocommunity.scrolling.nvim-scrollbar" },
		},
		{
			"airblade/vim-rooter", -- adds :Rooter command to change pwd to the project root
			cmd = { "Rooter", "RooterToggle" },
			config = function()
				vim.g.rooter_manual_only = 1
			end,
		},
		{
			"tyru/open-browser-github.vim", -- opens current buffer in GitHub
			lazy = false,
			dependencies = { "tyru/open-browser.vim" },
		},
		{
			"sgur/vim-textobj-parameter", -- text object for function params to ","
			lazy = false,
			dependencies = { "kana/vim-textobj-user" },
		},
	},
	-- This function is run last and is a good place to configuring
	-- augroups/autocommands and custom filetypes also this just pure lua so
	-- anything that doesn't fit in the normal config locations above can go here
	polish = function()
		-- remove trailing whitespace
		vim.api.nvim_create_user_command("Trim", ":let _s=@/<Bar>:%s/\\s\\+$//e<Bar>:let @/=_s", {})

		-- convert snake_case to camelCase
		vim.api.nvim_create_user_command("Camel", "%s/\\([a-z0-9]\\)_\\([a-z0-9]\\)/\\1\\u\\2/g", {})

		-- print absolute file path
		vim.api.nvim_create_user_command("F", ":echo expand('%:p')", {})

		-- close all buffers except current
		vim.api.nvim_create_user_command("Purge", "%bd|e#|bd#", {})

		-- open this file
		vim.api.nvim_create_user_command("Conf", edit_config, {})

		-- shows how the current buffer differs from the file on disk
		vim.cmd([[
			function! s:DiffWithSaved()
				let filetype=&ft
				diffthis
				vnew | r # | normal! 1Gdd
				diffthis
				exe "setlocal bt=nofile bh=wipe nobl noswf ro ft=" . filetype
				endfunc
			com! DiffSaved call s:DiffWithSaved()
    ]])

		vim.api.nvim_create_autocmd("FocusGained", {
			callback = function()
				vim.notify("Welcome back", nil, { timeout = 500 })
			end,
		})
		vim.api.nvim_create_autocmd("FocusLost", {
			callback = function()
				vim.notify("Goodbye", nil, { timeout = 500 })
			end,
		})
	end,
}
