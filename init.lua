vim.cmd("colorscheme elflord")

local success, error = pcall(vim.fn["plug#begin"], vim.fn.stdpath("data") .. "/plugged")

if not success then
  if not error:find("Unknown function") then
    vim.fn["plug#begin"](vim.fn.stdpath("data") .. "/plugged")
  end
  print("curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim")
else
  -- editing utilities
  vim.fn["plug#"]("windwp/nvim-autopairs") -- automatically insert enclosing parentheses
  vim.fn["plug#"]("tpope/vim-surround") -- manipulates surrounding brackets and quotes
  vim.fn["plug#"]("tpope/vim-repeat") -- adds . support for the vim-surround maps
  vim.fn["plug#"]("scrooloose/nerdcommenter") -- adds keybindings for easily commenting out lines \c<space> to toggle
  vim.fn["plug#"]("skammer/vim-swaplines") -- move lines up or down
  vim.fn["plug#"]("AndrewRadev/splitjoin.vim") -- switch formatting of objects between one-line and multi-line with gJ and gS
  vim.fn["plug#"]("mattn/emmet-vim") -- expand Emmet to HTML with <c-y>,

  -- appearances
  vim.fn["plug#"]("lukas-reineke/indent-blankline.nvim") -- adds a little grey line at each indentation level
  vim.fn["plug#"]("machakann/vim-highlightedyank") -- highlight yanked text
  vim.fn["plug#"]("folke/tokyonight.nvim") -- good dark theme which I customized

  -- widgets
  vim.fn["plug#"]("nvim-lualine/lualine.nvim") -- dope status line
  vim.fn["plug#"]("kdheepak/tabline.nvim") -- dope tab line
  vim.fn["plug#"]("airblade/vim-gitgutter") -- adds git diff symbols on the left hand side
  vim.fn["plug#"]("kyazdani42/nvim-web-devicons") -- icons for file tree viewer
  vim.fn["plug#"]("kyazdani42/nvim-tree.lua") -- file tree viewer
  vim.fn["plug#"]("preservim/tagbar") -- a class outline viewer

  -- commands
  vim.fn["plug#"]("ctrlpvim/ctrlp.vim") -- fuzzy file finder
  vim.fn["plug#"]("mileszs/ack.vim") -- call ack from NeoVim

  -- text objects
  vim.fn["plug#"]("kana/vim-textobj-user") -- enable user-defined text objects
  vim.fn["plug#"]("glts/vim-textobj-comment") -- text object for comments to "c"
  vim.fn["plug#"]("michaeljsmith/vim-indent-object") -- text object for an indent level to "i" (good for python)
  vim.fn["plug#"]("sgur/vim-textobj-parameter") -- text object for function params to ","
  vim.fn["plug#"]("zandrmartin/vim-textobj-blanklines") -- text object for consecutive blank lines to <space>

  -- syntax
  vim.fn["plug#"]("nvim-treesitter/nvim-treesitter", {["do"] = ":TSUpdate"}) -- better highlighting
  vim.fn["plug#"]("p00f/nvim-ts-rainbow") -- rainbow colored parentheses based on depth
  vim.fn["plug#"]("williamboman/nvim-lsp-installer") -- manages installation of language servers
  vim.fn["plug#"]("neovim/nvim-lspconfig") -- works with nvim-lsp-installer to use the language server after installation

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
  require("nvim-autopairs").setup()
  require("tabline").setup({enable = false}) -- do not use directly, use with lualine instead
  require("lualine").setup({
    options = {theme = "auto"},
    tabline = {
      lualine_a = {},
      lualine_b = {},
      lualine_c = {require("tabline").tabline_buffers},
      lualine_x = {require("tabline").tabline_tabs},
      lualine_y = {},
      lualine_z = {}
    }
  })
  require("nvim-tree").setup()
  require("nvim-treesitter.configs").setup({
    ensure_installed = {"lua", "javascript", "python", "svelte", "html", "css"},
    sync_install = true,
    highlight = {
      enable = true
    },
    rainbow = {
      enable = true
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
      ["<c-g>"] = cmp.mapping.complete(),
      ["<c-v>"] = cmp.mapping.abort(),
      ["<CR>"] = cmp.mapping.confirm({ select = false }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    }),
  })

  local capabilities = require("cmp_nvim_lsp").update_capabilities(vim.lsp.protocol.make_client_capabilities())

  require("lspconfig").pyright.setup({capabilities = capabilities})
  require("lspconfig").eslint.setup({capabilities = capabilities})
  require("lspconfig").svelte.setup({capabilities = capabilities})
  require("lspconfig").cssls.setup({capabilities = capabilities})
  require("lspconfig").html.setup({capabilities = capabilities})
  require("lspconfig").sumneko_lua.setup({
    capabilities = capabilities,
    settings = {
      Lua = {
        runtime = {
          version = 'LuaJIT'
        },
        diagnostics = {
          globals = {'vim'}
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

  -- ctrlpvim/ctrlp.vim options
  vim.g.ctrlp_working_path_mode = "ra"
  vim.g.ctrlp_user_command = {".git", "cd %s && git ls-files -co --exclude-standard"}

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

-- insert line above in insert mode
vim.keymap.set("i", "<c-l>", "<Esc>O", {noremap = true})
-- pretty format JSON file
vim.keymap.set("n", "=j", ":%!python -m json.tool<CR>", {noremap = true})
-- strip double quotes from keys in JSON. useful when pasting JSON into a JS
-- file and the linter complains about unecessary quoting
vim.keymap.set("n", "<leader>j", ":s/^\\(\\s*\\)\"\\(\\w\\+\\)\"\\s*:/\\1\\2:/g<CR>", {noremap = true})
-- select the freshly pasted text
vim.keymap.set("n", "gV", "`[v`]", {noremap = true})
-- convenient save shortcut
vim.keymap.set("n", "<leader>w", ":update<CR>", {noremap = true})
-- dedent block and delete line with surrounding brackets
vim.keymap.set("n", "<leader>x", "<i{]}dd[{dd", {noremap = true})
-- handy buffer navigation
vim.keymap.set("n", "<leader>d", ":bprevious<CR>", {noremap = true})
vim.keymap.set("n", "<leader>f", ":bnext<CR>", {noremap = true})


-- key mappings for primitivorm/vim-swaplines plugin
vim.keymap.set("n", "<c-k>", ":SwapUp<CR>", {noremap = true})
vim.keymap.set("n", "<c-j>", ":SwapDown<CR>", {noremap = true})

-- key mappins for kyazdani42/nvim-tree.lua
vim.keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>", {noremap = true})

-- key mappings for preservim/tagbar
vim.keymap.set("n", "<leader>t", ":TagbarToggle<CR>", {noremap = true})


-- open this file
vim.api.nvim_create_user_command("Conf", ":badd ~/.config/nvim/init.lua", {})
-- remove trailing whitespace
vim.api.nvim_create_user_command("Trim", ":let _s=@/<Bar>:%s/\\s\\+$//e<Bar>:let @/=_s", {})
-- convert snake_case to camelCase
vim.api.nvim_create_user_command("Camel", "%s/\\([a-z0-9]\\)_\\([a-z0-9]\\)/\\1\\u\\2/g", {})
-- print absolute file path
vim.api.nvim_create_user_command(
  "F",
  function()
    print(vim.fn.expand("%:p"))
  end,
  {}
)
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
