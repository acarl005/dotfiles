-- fallback theme if my plugins aren't installed
vim.cmd("colorscheme elflord")

-- I like a transparent background if my terminal theme is pretty
local transparent = true

-- attempt to load plugin manager. i don't want this file to crash if not installed
local success, packer = pcall(require, "packer")

if not success then
  print("install Packer")
  print("git clone --depth 1 https://github.com/wbthomason/packer.nvim ~/.local/share/nvim/site/pack/packer/start/packer.nvim")
else
  packer.init({
    auto_clean = true,
    compile_on_sync = true
  })
  packer.startup(function(use)
    use("wbthomason/packer.nvim")

    -- editing utilities
    use({
      "windwp/nvim-autopairs", -- automatically insert enclosing parentheses
      config = function()
        require("nvim-autopairs").setup()
      end
    })
    use({
      "kylechui/nvim-surround", -- manipulates pairs of brackets, tags and quotes
      config = function()
        require("nvim-surround").setup()
      end
    })
    use("scrooloose/nerdcommenter") -- adds keybindings for easily commenting out lines \c<space> to toggle
    use({
      "skammer/vim-swaplines", -- move lines up or down
      config = function()
        vim.keymap.set("n", "<c-k>", ":SwapUp<CR>", { noremap = true })
        vim.keymap.set("n", "<c-j>", ":SwapDown<CR>", { noremap = true })
      end
    })
    use("AndrewRadev/splitjoin.vim") -- switch formatting of objects between one-line and multi-line with gJ and gS
    use("mattn/emmet-vim") -- expand Emmet to HTML with <c-y>,

    -- appearances
    if transparent then
      use({
        "xiyaowong/nvim-transparent", -- removes background colors from color schemes
        config = function()
          require("transparent").setup({
            enable = true,
            extra_groups = {
              "GitBackground",
              "GitHeader",
              "lualine_c_normal"
            }
          })
        end
      })
    else
      use({
        "lukas-reineke/indent-blankline.nvim", -- adds a little grey line at each indentation level
        config = function()
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
      })
    end
    use("machakann/vim-highlightedyank") -- highlight yanked text
    use({
      "folke/tokyonight.nvim", -- good dark theme
      config = function()
        vim.o.termguicolors = true
        vim.cmd.colorscheme("tokyonight-night")
        vim.api.nvim_set_hl(0, "Todo", { fg = "#DB7093" })
      end
    })
    use({
      "yamatsum/nvim-cursorline", -- underline the word under the cursor
      requires = { "xiyaowong/nvim-cursorword" },
      config = function()
        require("nvim-cursorline").setup({
          cursorline = {
            enable = false
          }
        })
      end
    })
    use({
      "NvChad/nvim-colorizer.lua", -- add in-editor background colors to css colors
      config = function()
        require("colorizer").setup({
          user_default_options = {
            css = true
          }
        })
      end
    })

    -- widgets
    -- Mac: brew install ripgrep
    -- Linux: apt install ripgrep
    use({
      "nvim-telescope/telescope.nvim", -- fuzzy finder/file explorer all-in-one
      requires = { "nvim-lua/plenary.nvim", "kyazdani42/nvim-web-devicons" },
      config = function()
        vim.keymap.set("n", "<c-p>", ":Telescope find_files<CR>", { noremap = true })
        vim.keymap.set("n", "<leader>a", ":Telescope live_grep<CR>", { noremap = true })
        vim.keymap.set("n", "<leader>dd", "<cmd>Telescope diagnostics<CR>", { noremap = true })
        vim.keymap.set("n", "<leader>tr", "<cmd>Telescope lsp_references<CR>", { noremap = true })
        vim.keymap.set("n", "<leader>ti", "<cmd>Telescope lsp_implementations<CR>", { noremap = true })
        vim.keymap.set("n", "<leader>ts", "<cmd>Telescope lsp_document_symbols<CR>", { noremap = true })
        vim.keymap.set("n", "<leader>tw", "<cmd>Telescope lsp_dynamic_workspace_symbols<CR>", { noremap = true })

        local telescope = require("telescope")
        local actions = require("telescope.actions")
        local action_state = require("telescope.actions.state")
        local transform_mod = require("telescope.actions.mt").transform_mod

        --this is a hack to open all selected files, see this issue for source
        --https://github.com/nvim-telescope/telescope.nvim/issues/1048
        local function multiopen(prompt_bufnr, method)
          local edit_file_cmd_map = {
            vertical = "vsplit",
            horizontal = "split",
            tab = "tabedit",
            default = "edit"
          }
          local edit_buf_cmd_map = {
            vertical = "vert sbuffer",
            horizontal = "sbuffer",
            tab = "tab sbuffer",
            default = "buffer"
          }
          local picker = action_state.get_current_picker(prompt_bufnr)
          local multi_selection = picker:get_multi_selection()

          if #multi_selection > 1 then
            require("telescope.pickers").on_close_prompt(prompt_bufnr)
            pcall(vim.api.nvim_set_current_win, picker.original_win_id)

            for i, entry in ipairs(multi_selection) do
              local filename, row, col

              if entry.path or entry.filename then
                filename = entry.path or entry.filename
                row = entry.row or entry.lnum
                col = vim.F.if_nil(entry.col, 1)
              elseif not entry.bufnr then
                local value = entry.value
                if not value then
                  return
                end
                if type(value) == "table" then
                  value = entry.display
                end
                local sections = vim.split(value, ":")
                filename = sections[1]
                row = tonumber(sections[2])
                col = tonumber(sections[3])
              end

              local entry_bufnr = entry.bufnr

              if entry_bufnr then
                if not vim.api.nvim_buf_get_option(entry_bufnr, "buflisted") then
                  vim.api.nvim_buf_set_option(entry_bufnr, "buflisted", true)
                end
                local command = i == 1 and "buffer" or edit_buf_cmd_map[method]
                pcall(vim.cmd, string.format("%s %s", command, vim.api.nvim_buf_get_name(entry_bufnr)))
              else
                local command = i == 1 and "edit" or edit_file_cmd_map[method]
                if vim.api.nvim_buf_get_name(0) ~= filename or command ~= "edit" then
                  filename = require("plenary.path"):new(vim.fn.fnameescape(filename)):normalize(vim.loop.cwd())
                  pcall(vim.cmd, string.format("%s %s", command, filename))
                end
              end

              if row and col then
                pcall(vim.api.nvim_win_set_cursor, 0, { row, col - 1 })
              end
            end
          else
            actions["select_" .. method](prompt_bufnr)
          end
        end

        local custom_actions = transform_mod({
          multi_selection_open_vertical = function(prompt_bufnr)
            multiopen(prompt_bufnr, "vertical")
          end,
          multi_selection_open_horizontal = function(prompt_bufnr)
            multiopen(prompt_bufnr, "horizontal")
          end,
          multi_selection_open_tab = function(prompt_bufnr)
            multiopen(prompt_bufnr, "tab")
          end,
          multi_selection_open = function(prompt_bufnr)
            multiopen(prompt_bufnr, "default")
          end
        })

        telescope.setup({
          defaults = {
            mappings = {
              i = {
                ["<c-j>"] = actions.move_selection_next,
                ["<c-k>"] = actions.move_selection_previous,
                ["<c-o>"] = custom_actions.multi_selection_open
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
              hidden = true,
              grouped = true
            }
          }
        })
      end
    })

    use({
      "nvim-telescope/telescope-file-browser.nvim", -- file browser extension for Telescope
      requires = { "nvim-telescope/telescope.nvim" },
      config = function()
        vim.keymap.set("n", "<leader>e", ":Telescope file_browser<CR>", { noremap = true })
        require("telescope").load_extension("file_browser")
      end
    })
    use({
      "startup-nvim/startup.nvim", -- dashboard on startup, also integrates with Telescope
      requires = { "nvim-telescope/telescope.nvim" },
      config = function()
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
      end
    })
    use("kdheepak/tabline.nvim") -- dope tab line
    use({
      "nvim-lualine/lualine.nvim", -- dope status line
      requires = { "kyazdani42/nvim-web-devicons" },
      config = function()
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
      end
    })
    use({
      "folke/which-key.nvim",
      config = function()
        require("which-key").setup()
      end
    }) -- emacs-style index of possible keymaps once you press a key
    use({
      "petertriho/nvim-scrollbar", -- adds a scrollbar to the right of the view
      config = function()
        require("scrollbar").setup()
      end
    })
    use({
      "tanvirtin/vgit.nvim", -- a bunch of git integration, like diff view
      config = function()
        vim.keymap.set("n", "<leader>gpd", "<cmd>VGit project_diff_preview<CR>", { noremap = true })
        vim.keymap.set("n", "<leader>gbd", "<cmd>VGit buffer_diff_preview<CR>", { noremap = true })
        vim.keymap.set("n", "<leader>gbh", "<cmd>VGit buffer_history_preview<CR>", { noremap = true })
        vim.keymap.set("n", "<leader>ghd", "<cmd>VGit buffer_hunk_preview<CR>", { noremap = true })
        require("vgit").setup()
        require("vgit").toggle_live_gutter()
      end
    })
    use({
      "lewis6991/gitsigns.nvim", -- adds git diff symbols on the left hand side. vgit has this but it was super shaky due to updating on every keystroke
      requires = { "nvim-lua/plenary.nvim" },
      config = function()
        require("gitsigns").setup()
        vim.keymap.set("n", "<leader>gnh", "<cmd>Gitsigns next_hunk<CR>", { noremap = true })
        vim.keymap.set("n", "<leader>gph", "<cmd>Gitsigns prev_hunk<CR>", { noremap = true })
      end
    })
    -- MacOS: brew install --HEAD universal-ctags/universal-ctags/universal-ctags
    -- Linux: sudo snap install universal-ctags
    use({
      "preservim/tagbar", -- a ctag/class outline viewer
      config = function()
        vim.keymap.set("n", "<leader>tt", ":TagbarToggle<CR>", { noremap = true })
      end
    })
    use({
      "chentoast/marks.nvim", -- show the marks on the left
      config = function()
        require("marks").setup()
      end
    })

    -- commands
    use({
      "airblade/vim-rooter", -- adds :Rooter command to change pwd to the project root
      config = function()
        vim.g.rooter_manual_only = 1
      end
    })
    use({
      "tyru/open-browser-github.vim", -- opens current buffer in GitHub
      requires = { "tyru/open-browser.vim" }
    })

    -- text objects
    use({
      "glts/vim-textobj-comment", -- text object for comments to "c"
      requires = { "kana/vim-textobj-user" }
    })
    use({
      "michaeljsmith/vim-indent-object", -- text object for an indent level to "i" (good for python)
      requires = { "kana/vim-textobj-user" }
    })
    use({
      "sgur/vim-textobj-parameter", -- text object for function params to ","
      requires = { "kana/vim-textobj-user" }
    })
    use({
      "zandrmartin/vim-textobj-blanklines", -- text object for consecutive blank lines to <space>
      requires = { "kana/vim-textobj-user" }
    })

    -- languages, standard LSP
    use({
      "williamboman/nvim-lsp-installer", -- automatically detect which language servers to install (based on which servers are set up via lspconfig)
      config = function()
        require("nvim-lsp-installer").setup({
          automatic_installation = true,
          ui = {
            icons = {
              server_installed = "✓",
              server_pending = "➜",
              server_uninstalled = "✗"
            }
          }
        })
      end
    })
    use({
      "neovim/nvim-lspconfig", -- works with nvim-lsp-installer to use the language server after installation
      config = function()
        -- Language servers provide different completion results depending on the capabilities of the client. Neovim's default
        -- omnifunc has basic support for serving completion candidates. nvim-cmp supports more types of completion candidates, so
        -- users must override the capabilities sent to the server such that it can provide these candidates during a completion request.
        local lspconfig = require("lspconfig")
        local capabilities = require("cmp_nvim_lsp").default_capabilities()
        local ls_options = { capabilities = capabilities }

        -- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
        -- or check :LspInstallInfo
        lspconfig.bashls.setup(ls_options)
        lspconfig.pyright.setup(ls_options)
        lspconfig.eslint.setup(ls_options)
        lspconfig.svelte.setup(ls_options)
        lspconfig.cssls.setup(ls_options)
        lspconfig.html.setup(ls_options)
        lspconfig.tsserver.setup(ls_options)
        lspconfig.rust_analyzer.setup(ls_options)
        lspconfig.gopls.setup(ls_options)
        lspconfig.taplo.setup(ls_options)
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
      end
    })
    use({
      "nvim-treesitter/nvim-treesitter", -- a general parser-generator
      run = function()
        require("nvim-treesitter.install").update({ with_sync = true })
      end
    })

    -- language-specific
    use({
      "evanleck/vim-svelte",
      requires = { "othree/html5.vim", ("pangloss/vim-javascript") }
    })
    use({
      "preservim/vim-markdown",
      requires = { "godlygeek/tabular" },
      config = function()
        vim.g.vim_markdown_fenced_languages = { "c++=cpp", "bash=sh", "sqlx=pgsql", "sqlres=pgsql", "js=javascript" }
        vim.g.vim_markdown_folding_disabled = 1
      end
    })
    use("lifepillar/pgsql.vim") -- postgres-specific SQL (pgsql file extension)
    use({
      "ray-x/go.nvim", -- some helpful Go commands for formatting and auto-import
      requires = { "nvim-treesitter/nvim-treesitter" },
      config = function()
        require("go").setup()
      end
    })

    -- completions
    use({
      "hrsh7th/nvim-cmp", -- completion engine
      requires = {
        "hrsh7th/vim-vsnip",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-nvim-lua",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path"
      },
      config = function()
        vim.o.completeopt = "menu,menuone,noselect"
        local cmp = require("cmp")
        cmp.setup({
          sources = cmp.config.sources({
            { name = "nvim_lsp" },
            { name = 'nvim_lua' },
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
            ["<c-b>"] = cmp.mapping.scroll_docs(-4),
            ["<c-f>"] = cmp.mapping.scroll_docs(4),
            ["<c-x>"] = cmp.mapping.complete(),
            ["<c-v>"] = cmp.mapping.abort(),
            -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
            ["<CR>"] = cmp.mapping.confirm({ select = false }),
          })
        })
      end
    })
  end)
end


vim.g.mapleader = " "

vim.o.number = true -- line numbers

vim.o.expandtab = true -- convert tabs to spaces
vim.o.softtabstop = 2 -- how many spaces to insert for each <tab>
vim.o.tabstop = 2 -- the width to display a <tab> character
vim.o.shiftwidth = 2 -- used by commands like =, >, and < to know how much to indent
vim.o.cindent = true -- some automatic indent rules

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

local keymap_opts = { noremap = true }

-- insert line above in insert mode
vim.keymap.set("i", "<c-l>", "<Esc>O", keymap_opts)
-- pretty format JSON file
vim.keymap.set("n", "=j", ":%!python -m json.tool<CR>", keymap_opts)
-- strip double quotes from keys in JSON. useful when pasting JSON into a JS
-- file and the linter complains about unecessary quoting
vim.keymap.set("n", "<leader>j", ":s/^\\(\\s*\\)\"\\(\\w\\+\\)\"\\s*:/\\1\\2:/g<CR>", keymap_opts)
-- select the freshly pasted text
vim.keymap.set("n", "gV", "`[v`]", keymap_opts)
-- convenient save shortcut
vim.keymap.set("n", "<leader>w", ":update<CR>", keymap_opts)
-- dedent block and delete line with surrounding brackets
vim.keymap.set("n", "<leader>x{", "<i{0]}dd[{dd", keymap_opts)
vim.keymap.set("n", "<leader>x(", "<i(0])dd[(dd", keymap_opts)
vim.keymap.set("n", "<leader>x[", "<i[0]]dd[[dd", keymap_opts)
-- handy buffer navigation
vim.keymap.set("n", "<c-h>", ":bprevious<CR>", keymap_opts)
vim.keymap.set("n", "<c-l>", ":bnext<CR>", keymap_opts)

vim.keymap.set("v", "<leader>p", '"_dP', keymap_opts)

-- key mappings for LSP
vim.keymap.set("n", "<leader>do", ":lua vim.diagnostic.open_float()<CR>", keymap_opts)
vim.keymap.set("n", "<leader>d[", ":lua vim.diagnostic.goto_prev()<CR>", keymap_opts)
vim.keymap.set("n", "<leader>d]", ":lua vim.diagnostic.goto_next()<CR>", keymap_opts)
vim.keymap.set("n", "<leader>dl", ":lua vim.diagnostic.setloclist()<CR>", keymap_opts)

vim.keymap.set("n", "K", vim.lsp.buf.hover, keymap_opts)
vim.keymap.set("n", "gd", vim.lsp.buf.definition, keymap_opts)
vim.keymap.set("n", "gD", vim.lsp.buf.declaration, keymap_opts)
vim.keymap.set("n", "gt", vim.lsp.buf.type_definition, keymap_opts)
vim.keymap.set("n", "gi", vim.lsp.buf.implementation, keymap_opts)
vim.keymap.set("n", "gr", vim.lsp.buf.references, keymap_opts)
vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, keymap_opts)
vim.keymap.set("n", "<leader>f", function() vim.lsp.buf.format { async = true } end, keymap_opts)
vim.keymap.set("n", "<leader>sd", ":vsp<CR>:lua vim.lsp.buf.definition()<CR>", keymap_opts)
vim.keymap.set("n", "<leader>st", ":vsp<CR>:lua vim.lsp.buf.type_definition()<CR>", keymap_opts)

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

-- close all buffers except current
vim.api.nvim_create_user_command("Purge", "%bd|e#|bd#", {})

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

vim.api.nvim_create_user_command(
  "StyleJS",
  function()
    vim.cmd(":%s/'/\"/g")
    vim.cmd(":%s/;//g")
    vim.cmd(":%s/\t/  /g")
  end,
  {}
)

vim.api.nvim_create_user_command(
  "Rename",
  function(opts)
    vim.lsp.buf.rename(opts.args)
  end,
  { nargs = 1 }
)

-- prints the highlight group under the cursor
vim.cmd([[
  function! s:SynStack()
    if !exists("*synstack")
      return
    endif
    echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
  endfunc
  com! SynStack call s:SynStack()
]])

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

