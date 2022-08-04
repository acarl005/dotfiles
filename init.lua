vim.cmd("colorscheme elflord")

local transparent = true
local success, error = pcall(vim.fn["plug#begin"], vim.fn.stdpath("data") .. "/plugged")

if not success then
  if not error:find("Unknown function") then
    vim.fn["plug#begin"](vim.fn.stdpath("data") .. "/plugged")
  end
  print("curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim")
else
  -- editing utilities
  vim.fn["plug#"]("windwp/nvim-autopairs") -- automatically insert enclosing parentheses
  vim.fn["plug#"]("kylechui/nvim-surround") -- manipulates pairs of brackets, tags and quotes
  vim.fn["plug#"]("scrooloose/nerdcommenter") -- adds keybindings for easily commenting out lines \c<space> to toggle
  vim.fn["plug#"]("skammer/vim-swaplines") -- move lines up or down
  vim.fn["plug#"]("AndrewRadev/splitjoin.vim") -- switch formatting of objects between one-line and multi-line with gJ and gS
  vim.fn["plug#"]("mattn/emmet-vim") -- expand Emmet to HTML with <c-y>,

  -- appearances
  if transparent then
    vim.fn["plug#"]("xiyaowong/nvim-transparent") -- removes background colors from color schemes
  else
    vim.fn["plug#"]("lukas-reineke/indent-blankline.nvim") -- adds a little grey line at each indentation level
  end
  vim.fn["plug#"]("machakann/vim-highlightedyank") -- highlight yanked text
  vim.fn["plug#"]("folke/tokyonight.nvim") -- good dark theme which I customized
  vim.fn["plug#"]("xiyaowong/nvim-cursorword") -- needed by yamatsum/nvim-cursorline
  vim.fn["plug#"]("yamatsum/nvim-cursorline") -- underline the word under the cursor

  -- widgets
  vim.fn["plug#"]("nvim-lua/plenary.nvim") -- depended upon by nvim-telescope/telescope.nvim
  vim.fn["plug#"]("nvim-telescope/telescope.nvim") -- fuzzy file finder
  vim.fn["plug#"]("nvim-telescope/telescope-file-browser.nvim") -- file browser extension for Telescope
  vim.fn["plug#"]("startup-nvim/startup.nvim") -- dashboard on startup, also integrates with (and so depends on) nvim-telescope/telescope.nvim
  vim.fn["plug#"]("nvim-lualine/lualine.nvim") -- dope status line
  vim.fn["plug#"]("kdheepak/tabline.nvim") -- dope tab line
  vim.fn["plug#"]("petertriho/nvim-scrollbar") -- adds a scrollbar to the right of the view
  vim.fn["plug#"]("lewis6991/gitsigns.nvim") -- adds git diff symbols on the left hand side
  vim.fn["plug#"]("kyazdani42/nvim-web-devicons") -- icons for file tree viewer
  vim.fn["plug#"]("preservim/tagbar") -- a ctag/class outline viewer
  vim.fn["plug#"]("universal-ctags/ctags") -- ctag extractor for all languages
  vim.fn["plug#"]("chentoast/marks.nvim") -- show the marks on the left

  -- text objects
  vim.fn["plug#"]("kana/vim-textobj-user") -- enable user-defined text objects
  vim.fn["plug#"]("glts/vim-textobj-comment") -- text object for comments to "c"
  vim.fn["plug#"]("michaeljsmith/vim-indent-object") -- text object for an indent level to "i" (good for python)
  vim.fn["plug#"]("sgur/vim-textobj-parameter") -- text object for function params to ","
  vim.fn["plug#"]("zandrmartin/vim-textobj-blanklines") -- text object for consecutive blank lines to <space>

  -- syntax
  vim.fn["plug#"]("williamboman/nvim-lsp-installer") -- manages installation of language servers
  vim.fn["plug#"]("neovim/nvim-lspconfig") -- works with nvim-lsp-installer to use the language server after installation

  vim.fn["plug#"]("othree/html5.vim") -- depended upon by evanleck/vim-svelte
  vim.fn["plug#"]("pangloss/vim-javascript") -- depended upon by evanleck/vim-svelte
  vim.fn["plug#"]("evanleck/vim-svelte") -- needed for good svelte file indentation
  vim.fn["plug#"]("godlygeek/tabular") -- depended upon by preservim/vim-markdown
  vim.fn["plug#"]("preservim/vim-markdown")
  vim.fn["plug#"]("lifepillar/pgsql.vim") -- postgres-specific SQL (pgsql file extension)

  -- completions
  vim.fn["plug#"]("hrsh7th/cmp-nvim-lsp") -- completion source for LSPs
  vim.fn["plug#"]("hrsh7th/cmp-buffer") -- completion source for symbols in the current buffer
  vim.fn["plug#"]("hrsh7th/cmp-path") -- completion source for file paths
  vim.fn["plug#"]("hrsh7th/nvim-cmp") -- completion engine
  vim.fn["plug#"]("hrsh7th/vim-vsnip") -- snippet engine, required by cmp to insert the selections

  vim.fn["plug#end"]()

  vim.o.termguicolors = true
  vim.g.tokyonight_style = "night"
  vim.cmd("colorscheme tokyonight")

  if transparent then
    require("transparent").setup({
      enable = true,
      extra_groups = { "lualine_c_normal" }
    })
  else
    -- to configure lukas-reineke/indent-blankline.nvim
    vim.cmd("highlight IndentBlanklineIndent1 guibg=#16161e gui=nocombine")
    vim.cmd("highlight IndentBlanklineIndent2 guibg=#1e1e1e gui=nocombine")
    require("indent_blankline").setup({
      char = "",
      char_highlight_list = {
        "IndentBlanklineIndent1",
        "IndentBlanklineIndent2"
      },
      space_char_highlight_list = {
        "IndentBlanklineIndent1",
        "IndentBlanklineIndent2"
      },
      show_trailing_blankline_indent = false
    })
  end

  require("nvim-autopairs").setup()
  require("nvim-surround").setup()

  require("gitsigns").setup()
  require("scrollbar").setup()
  require("marks").setup()
  require('nvim-cursorline').setup {
    cursorline = {
      enable = false
    }
  }

  local telescope = require("telescope")
  local actions = require("telescope.actions")
  telescope.setup({
    defaults = {
      mappings = {
        i = {
          ["<c-j>"] = actions.move_selection_next,
          ["<c-k>"] = actions.move_selection_previous
        }
      }
    },
    pickers = {
      find_files = {
        hidden = true
      },
      live_grep = {
        additional_args = function()
          return { "--hidden" }
        end
      }
    },
    extensions = {
      file_browser = {
        hidden = true
      }
    }
  })
  telescope.load_extension("file_browser")

  local startup_settings = require("startup.themes.dashboard")
  startup_settings.footer.content = { "Hello, " .. (os.getenv("USER") or "user") .. "!" }
  table.insert(
    startup_settings.body.content,
    {
      " Edit Config",
      [[
        Conf
        cd ~
      ]],
      "<leader>fc"
    }
  )
  require("startup").setup(startup_settings)

  local tabline = require("tabline")
  tabline.setup({ enable = false }) -- do not use directly, use with lualine instead
  require("lualine").setup({
    options = { theme = "auto" },
    tabline = {
      lualine_a = {},
      lualine_b = {},
      lualine_c = { tabline.tabline_buffers },
      lualine_x = { tabline.tabline_tabs },
      lualine_y = {},
      lualine_z = {}
    }
  })

  require("nvim-lsp-installer").setup({
    automatic_installation = true, -- automatically detect which servers to install (based on which servers are set up via lspconfig)
    ui = {
      icons = {
        server_installed = "✓",
        server_pending = "➜",
        server_uninstalled = "✗"
      }
    }
  })

  local cmp = require("cmp")
  cmp.setup({
    sources = cmp.config.sources({
      { name = "nvim_lsp" },
      { name = "buffer" },
      { name = "path" }
    }),
    snippet = {
      expand = function(args)
        vim.fn["vsnip#anonymous"](args.body)
      end
    },
    mapping = cmp.mapping.preset.insert({
      ["<c-n>"] = cmp.mapping.select_next_item(),
      ["<c-p>"] = cmp.mapping.select_prev_item(),
      ['<c-b>'] = cmp.mapping.scroll_docs(-4),
      ['<c-f>'] = cmp.mapping.scroll_docs(4),
      ["<c-x>"] = cmp.mapping.complete(),
      ["<c-v>"] = cmp.mapping.abort(),
      ["<CR>"] = cmp.mapping.confirm({ select = false }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    })
  })

  local capabilities = require("cmp_nvim_lsp").update_capabilities(vim.lsp.protocol.make_client_capabilities())
  local lspconfig = require("lspconfig")
  lspconfig.pyright.setup({ capabilities = capabilities })
  lspconfig.eslint.setup({ capabilities = capabilities })
  lspconfig.svelte.setup({ capabilities = capabilities })
  lspconfig.cssls.setup({ capabilities = capabilities })
  lspconfig.html.setup({ capabilities = capabilities })
  lspconfig.tsserver.setup({ capabilities = capabilities })
  lspconfig.rust_analyzer.setup({ capabilities = capabilities })
  lspconfig.sumneko_lua.setup({
    capabilities = capabilities,
    settings = {
      Lua = {
        runtime = {
          version = "LuaJIT"
        },
        diagnostics = {
          globals = { "vim" }
        },
        workspace = {
          -- Make the server aware of Neovim runtime files
          library = vim.api.nvim_get_runtime_file("", true)
        },
        -- Do not send telemetry data containing a randomized but unique identifier
        telemetry = {
          enable = false
        }
      }
    }
  })

  -- preservim/vim-markdown options for working on SQL Scholar
  vim.g.vim_markdown_fenced_languages = { "c++=cpp", "bash=sh", "sqlx=pgsql", "sqlres=pgsql", "js=javascript" }
  vim.g.vim_markdown_folding_disabled = 1

  vim.o.completeopt = "menu,menuone,noselect"
end


vim.g.mapleader = ","

vim.o.number = true -- line numbers

vim.o.expandtab = true -- convert tabs to spaces
vim.o.softtabstop = 2 -- how many spaces to insert for each <tab>
vim.o.tabstop = 2 -- the width to display a <tab> character
vim.o.shiftwidth = 2 -- used by commands like =, >, and < to know how much to indent
vim.o.cindent = true

vim.o.ignorecase = true -- searches are case-insens
vim.o.smartcase = true -- searches become case-sens when you include capital letters

vim.o.scrolloff = 15 -- vim will automatically adjust viewport to leave at least 15 lines above and below cursor when possible

-- display whitespace chars
vim.o.listchars = "tab:› ,trail:·"
vim.o.list = true

-- virtualedit allows you to move the cursor where there are not any actual characters, for example after the end of the line
-- block means this is only enabled in block edit mode (ctrl-v)
vim.o.virtualedit = "block"

-- copy and paste from system clipboard
vim.o.clipboard = "unnamedplus"

vim.o.wildignore = "*/node_modules/*,*.swp,*.zip,*/dist/*,*/.ipynb_checkpoints/*,*/.mypy_cache/*,*/.tox/*,*/.cache/*,*/.svelte-kit/*,*/.netlify/*"

-- prevent SQL ft plugin from causing <c-c> to wait
vim.g.ftplugin_sql_omni_key = "<c-j>"

-- automatically try to check for changed files
vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, { pattern = "*", command = "checktime" })

-- this is meant to fix this issue with Warp terminal:
-- https://github.com/warpdotdev/Warp/issues/1451
vim.api.nvim_create_autocmd({ "VimEnter" }, {
  callback = function()
    local pid, WINCH = vim.fn.getpid(), vim.loop.constants.SIGWINCH
    vim.defer_fn(function() vim.loop.kill(pid, WINCH) end, 20)
  end
})

-- insert line above in insert mode
vim.keymap.set("i", "<c-l>", "<Esc>O", { noremap = true })
-- pretty format JSON file
vim.keymap.set("n", "=j", ":%!python -m json.tool<CR>", { noremap = true })
-- strip double quotes from keys in JSON. useful when pasting JSON into a JS
-- file and the linter complains about unecessary quoting
vim.keymap.set("n", "<leader>j", ":s/^\\(\\s*\\)\"\\(\\w\\+\\)\"\\s*:/\\1\\2:/g<CR>", { noremap = true })
-- select the freshly pasted text
vim.keymap.set("n", "gV", "`[v`]", { noremap = true })
-- convenient save shortcut
vim.keymap.set("n", "<leader>w", ":update<CR>", { noremap = true })
-- dedent block and delete line with surrounding brackets
vim.keymap.set("n", "<leader>x", "<i{]}dd[{dd", { noremap = true })
-- handy buffer navigation
vim.keymap.set("n", "<c-h>", ":bprevious<CR>", { noremap = true })
vim.keymap.set("n", "<c-l>", ":bnext<CR>", { noremap = true })
-- indent a line to the correct level
vim.keymap.set("n", "<leader>i", "O<Left><Esc>J", { noremap = true })


-- key mappings for nvim-telescope/telescope.nvim
vim.keymap.set("n", "<c-p>", ":Telescope find_files<CR>", { noremap = true })
vim.keymap.set("n", "<leader>a", ":Telescope live_grep<CR>", { noremap = true })
vim.keymap.set("n", "<leader>e", ":Telescope file_browser<CR>", { noremap = true })

-- key mappings for primitivorm/vim-swaplines plugin
vim.keymap.set("n", "<c-k>", ":SwapUp<CR>", { noremap = true })
vim.keymap.set("n", "<c-j>", ":SwapDown<CR>", { noremap = true })

-- key mappings for preservim/tagbar
vim.keymap.set("n", "<leader>t", ":TagbarToggle<CR>", { noremap = true })


-- open this file
vim.api.nvim_create_user_command(
  "Conf",
  function()
    vim.cmd("badd ~/.config/nvim/init.lua")
    vim.cmd("b ~/.config/nvim/init.lua")
  end,
  {}
)
-- remove trailing whitespace
vim.api.nvim_create_user_command("Trim", ":let _s=@/<Bar>:%s/\\s\\+$//e<Bar>:let @/=_s", {})
-- convert snake_case to camelCase
vim.api.nvim_create_user_command("Camel", "%s/\\([a-z0-9]\\)_\\([a-z0-9]\\)/\\1\\u\\2/g", {})
-- print absolute file path
vim.api.nvim_create_user_command("F", ":echo expand('%:p')", {})
-- convert 4-space indentation to 2-space
vim.api.nvim_create_user_command(
  "Dedent",
  function()
    vim.o.tabstop = 4
    vim.o.softtabstop = 4
    vim.o.expandtab = false
    vim.cmd("retab!")
    vim.o.tabstop = 2
    vim.o.softtabstop = 2
    vim.o.expandtab = true
    vim.cmd("retab")
  end,
  {}
)
