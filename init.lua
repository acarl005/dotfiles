-- This is not a stand-alone NeoVim config. Rather, it is for customizing the meta-package "AstroNvim"
-- https://astronvim.github.io/Configuration/manage_user_config

local edit_config = function()
        vim.cmd("e ~/.config/nvim/lua/user/init.lua")
end

local config = {
        colorscheme = "catppuccin",
        options = {
                opt = {
                        relativenumber = false,
                        scrolloff = 15,
                        wrap = true,
                        cmdheight = 1,
                },
        },
        mappings = {
                n = {
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
        },
        lsp = {
                -- easily add or disable built in mappings added during LSP attaching
                mappings = {
                        n = {
                                ["<leader>lw"] = {
                                        "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>",
                                        desc = "Show symbols in the whole workspace"
                                },
                                ["<leader>lci"] = {
                                        "<cmd>Telescope lsp_incoming_calls<cr>",
                                        desc = "Show incoming calls for this function"
                                },
                                ["<leader>lco"] = {
                                        "<cmd>Telescope lsp_outgoing_calls<cr>",
                                        desc = "Show outgoing calls in this function"
                                },
                                ["&d"] = {
                                        ":vsp<cr>:lua vim.lsp.buf.definition()<cr>",
                                        desc = "Open definition in a vsplit"
                                },
                                ["&T"] = {
                                        ":vsp<cr>:lua vim.lsp.buf.type_definition()<cr>",
                                        desc = "Open type definition in a vsplit"
                                },
                        },
                },
        },
        heirline = {
                separators = {
                        tab = { "", "" },
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
                                                shortcut = "SPC ,",
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
                                                        return vim.fn.input(
                                                                "Path to executable: ",
                                                                vim.fn.getcwd() .. "/target/debug/warp",
                                                                "file"
                                                        )
                                                end
                                                return default
                                        end,
                                }
                        }
                },
                {
                        "stevearc/aerial.nvim",
                        opts = function(_, opts)
                                opts.disable_max_lines = 20000
                        end,
                },
                {
                        "rebelot/heirline.nvim",
                        opts = function(_, opts)
                                local file_path = {
                                        {
                                                provider = function()
                                                        return vim.fn.expand("%")
                                                end
                                        },
                                        padding = { left = 1, right = 1 },
                                }
                                table.insert(opts.statusline, 4, file_path)
                                return opts
                        end,
                },
                {
                        "nvim-treesitter/nvim-treesitter",
                        opts = {
                                auto_install = vim.fn.executable "tree-sitter" == 1,
                                ensure_installed = { "lua", "vim" },
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
                                        actions.select_default(pb)    -- the normal enter behaviour
                                        for _, j in pairs(multi) do
                                                if j.path ~= nil then -- is it a file -> open it as well:
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
                        "catppuccin/nvim",
                        as = "catppuccin",
                        config = function()
                                require("catppuccin").setup()
                        end,
                },
                {
                        "kylechui/nvim-surround", -- manipulates pairs of brackets, tags and quotes
                        lazy = false,
                        config = function()
                                require("nvim-surround").setup()
                        end,
                },
                {
                        "petertriho/nvim-scrollbar", -- adds a scrollbar to the right of the view
                        lazy = false,
                        config = function()
                                require("scrollbar").setup()
                        end,
                },
                {
                        "chentoast/marks.nvim", -- show the marks on the left
                        lazy = false,
                        config = function()
                                require("marks").setup()
                        end,
                },
                {
                        "airblade/vim-rooter", -- adds :Rooter command to change pwd to the project root
                        lazy = false,
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
        end,
}

return config
