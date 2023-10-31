-- This is not a stand-alone NeoVim config. Rather, it is for customizing the meta-package "AstroNvim"
-- https://astronvim.github.io/Configuration/manage_user_config

local edit_config = function() vim.cmd "e ~/.config/nvim/lua/user/init.lua" end

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
      ["<leader>gB"] = { ":ToggleBlame<cr>", desc = "Show git blame gutter" },
      ["<c-p>"] = { ":Telescope find_files<cr>", desc = "Search files" },
      L = {
        function() require("astronvim.utils.buffer").nav(vim.v.count > 0 and vim.v.count or 1) end,
        desc = "Next buffer",
      },
      H = {
        function() require("astronvim.utils.buffer").nav(-(vim.v.count > 0 and vim.v.count or 1)) end,
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
        ["&y"] = {
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
        disable_max_lines = 32768,
        -- 4 MiB
        disable_max_size = 4194304,
      },
    },
    {
      "rebelot/heirline.nvim",
      opts = function(_, opts)
        local status = require "astronvim.utils.status"

        local file_path = {
          {
            provider = function() return vim.fn.expand "%" end,
          },
          padding = { left = 1, right = 1 },
        }

        opts.statusline = {
          hl = { fg = "fg", bg = "bg" },
          status.component.mode { mode_text = { padding = { left = 1, right = 1 } } },
          status.component.git_branch(),
          status.component.file_info { filetype = {}, filename = false, file_modified = false },
          file_path,
          status.component.git_diff(),
          status.component.diagnostics(),
          status.component.fill(),
          status.component.cmd_info(),
          status.component.fill(),
          status.component.lsp(),
          status.component.treesitter(),
          status.component.nav(),
        }

        return opts
      end,
    },
    {
      "nvim-treesitter/nvim-treesitter",
      opts = {
        auto_install = vim.fn.executable "tree-sitter" == 1,
        ensure_installed = { "lua", "vim" },
        textobjects = {
          move = {
            goto_next_start = {
              ["]c"] = { query = "@class.outer", desc = "Next class start" },
              ["]l"] = { query = "@loop.outer", desc = "Next loop start" },
              ["]?"] = { query = "@conditional.outer", desc = "Next conditional start" },
            },
            goto_next_end = {
              ["]C"] = { query = "@class.outer", desc = "Next class end" },
              ["]L"] = { query = "@loop.outer", desc = "Next loop end" },
            },
            goto_previous_start = {
              ["[c"] = { query = "@class.outer", desc = "Previous class start" },
              ["[l"] = { query = "@loop.outer", desc = "Previous loop start" },
              ["[?"] = { query = "@conditional.outer", desc = "Previous conditional start" },
            },
            goto_previous_end = {
              ["[C"] = { query = "@class.outer", desc = "Previous class end" },
              ["[L"] = { query = "@loop.outer", desc = "Previous loop end" },
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
        local actions = require "telescope.actions"
        local action_state = require "telescope.actions.state"

        -- if picker has selected files, open those too on pressing "enter"
        local multi_open = function(pb)
          local picker = action_state.get_current_picker(pb)
          local multi = picker:get_multi_selection()
          -- the normal enter behaviour
          actions.select_default(pb)
          for _, j in pairs(multi) do
            -- is it a file -> open it as well
            if j.path ~= nil then vim.cmd(string.format("%s %s", "edit", j.path)) end
          end
        end

        opts.defaults.mappings.n["<cr>"] = multi_open
        opts.defaults.mappings.i["<cr>"] = multi_open

        opts.defaults.mappings.i["<C-n>"] = actions.move_selection_next
        opts.defaults.mappings.i["<C-p>"] = actions.move_selection_previous

        return opts
      end,
    },
    {
      "nvim-neo-tree/neo-tree.nvim",
      opts = {
        window = {
          mappings = {
            H = "prev_source",
            L = "next_source",
          },
        },
      },
    },
    {
      "kevinhwang91/nvim-ufo",
      opts = {
        close_fold_kinds = { "imports" },
      },
    },
    {
      "rcarriga/nvim-notify",
      opts = {
        -- Hack to silence a warning caused by nvim-transparent
        -- https://github.com/AstroNvim/astrocommunity/issues/598
        background_colour = "#1e222d",
      },
    },
    -- custom plugins
    {
      "AstroNvim/astrocommunity",
      { import = "astrocommunity.colorscheme.catppuccin" },
      { import = "astrocommunity.editing-support.mini-splitjoin" },
      { import = "astrocommunity.git.blame-nvim" },
      { import = "astrocommunity.motion.nvim-surround" },
      { import = "astrocommunity.motion.marks-nvim" },
      { import = "astrocommunity.scrolling.nvim-scrollbar" },
    },
    {
      "xiyaowong/transparent.nvim",
      lazy = false,
      opts = {
        groups = {
          "Normal",
          "NormalNC",
          "Comment",
          "Constant",
          "Special",
          "Identifier",
          "Statement",
          "PreProc",
          "Type",
          "Underlined",
          "Todo",
          "String",
          "Function",
          "Conditional",
          "Repeat",
          "Operator",
          "Structure",
          "LineNr",
          "NonText",
          "SignColumn",
          "CursorLineNr",
          "EndOfBuffer",
        },
        exclude_groups = {},
      },
    },
    {
      "airblade/vim-rooter", -- adds :Rooter command to change pwd to the project root
      cmd = { "Rooter", "RooterToggle" },
      config = function() vim.g.rooter_manual_only = 1 end,
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
    vim.api.nvim_create_user_command(
      "Trim",
      ":let _s=@/<Bar>:%s/\\s\\+$//e<Bar>:let @/=_s",
      { desc = "Trim the trailing whitespace off each line" }
    )

    -- convert snake_case to camelCase
    vim.api.nvim_create_user_command(
      "Camel",
      "%s/\\([a-z0-9]\\)_\\([a-z0-9]\\)/\\1\\u\\2/g",
      { desc = "Convert snake case to camel case" }
    )

    -- print absolute file path
    vim.api.nvim_create_user_command("F", ":echo expand('%:p')", { desc = "Echo absolute path of current buffer" })

    -- open this file
    vim.api.nvim_create_user_command("Conf", edit_config, { desc = "Edit config file" })

    -- shows how the current buffer differs from the file on disk
    vim.cmd [[
			function! s:DiffWithSaved()
				let filetype=&ft
				diffthis
				vnew | r # | normal! 1Gdd
				diffthis
				exe "setlocal bt=nofile bh=wipe nobl noswf ro ft=" . filetype
				endfunc
			com! DiffSaved call s:DiffWithSaved()
    ]]

    vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
      signs = {
        severity_limit = "Hint",
      },
      virtual_text = {
        severity_limit = "Warning",
      },
    })
  end,
}
