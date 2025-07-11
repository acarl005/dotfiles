local cwd = vim.fn.getcwd()
local features = {}
if cwd:find "warp%-internal" then features = { "local_tty", "agent_mode_debug" } end

---@type LazySpec
return {
  "AstroNvim/astrolsp",
  ---@type AstroLSPOpts
  opts = {
    -- Overridden by folke/noice.nvim config
    -- defaults = {
    --   hover = { border = "rounded", silent = true },
    -- },
    features = {
      autoformat = true,
      codelens = true,
      inlay_hints = false,
      semantic_tokens = true,
    },
    formatting = {
      format_on_save = {
        enabled = true,
        allow_filetypes = {},
        ignore_filetypes = {},
      },
      disabled = {},
      timeout_ms = 1000,
    },
    -- enable servers that you already have installed without mason
    servers = {
      "gleam",
      -- "rust_analyzer",
    },
    ---@diagnostic disable: missing-fields
    config = {
      powershell_es = {
        settings = {
          powershell = {
            codeFormatting = {
              openBraceOnSameLine = true,
            },
          },
        },
      },
      rust_analyzer = {
        settings = {
          ["rust-analyzer"] = {
            cfg = {
              setTest = true,
            },
            cargo = {
              features = features,
            },
            granularity = {
              enforce = true,
            },
            inlayHints = {
              lifetimeElisionHints = {
                enable = "skip_trivial",
                useParameterNames = true,
              },
            },
          },
        },
      },
    },
    -- Configure buffer local auto commands to add when attaching a language server
    autocmds = {
      -- first key is the `augroup` to add the auto commands to (:h augroup)
      lsp_document_highlight = {
        -- Optional condition to create/delete auto command group
        -- can either be a string of a client capability or a function of `fun(client, bufnr): boolean`
        -- condition will be resolved for each client on each execution and if it ever fails for all clients,
        -- the auto commands will be deleted for that buffer
        cond = "textDocument/documentHighlight",
        -- cond = function(client, bufnr) return client.name == "lua_ls" end,
        -- list of auto commands to set
        {
          -- events to trigger
          event = { "CursorHold", "CursorHoldI" },
          -- the rest of the autocmd options (:h nvim_create_autocmd)
          desc = "Document Highlighting",
          callback = function() vim.lsp.buf.document_highlight() end,
        },
        {
          event = { "CursorMoved", "CursorMovedI", "BufLeave" },
          desc = "Document Highlighting Clear",
          callback = function() vim.lsp.buf.clear_references() end,
        },
      },
    },
    -- mappings to be set up on attaching of a language server
    mappings = {
      n = {
        ["&d"] = {
          function()
            vim.api.nvim_command "vsp"
            require("snacks").picker.lsp_definitions()
          end,
          desc = "Open definition in a vsplit",
          cond = "textDocument/definition",
        },
        ["&D"] = {
          function()
            vim.api.nvim_command "vsp"
            require("snacks").picker.lsp_declarations()
          end,
          desc = "Open declaration in a vsplit",
          cond = "textDocument/declaration",
        },
        ["&y"] = {
          function()
            vim.api.nvim_command "vsp"
            require("snacks").picker.lsp_type_definitions()
          end,
          desc = "Open type definition in a vsplit",
          cond = "textDocument/typeDefinition",
        },
      },
    },
  },
}
