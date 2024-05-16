---@type LazySpec
return {
  "AstroNvim/astrolsp",
  ---@type AstroLSPOpts
  opts = {
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
      -- "pyright"
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
            cargo = {
              features = { "skip_login", "windowing-winit", "integration_tests" },
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
        gl = { function() vim.diagnostic.open_float() end, desc = "Hover diagnostics" },
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
    -- A custom `on_attach` function to be run after the default `on_attach` function
    -- takes two parameters `client` and `bufnr`  (`:h lspconfig-setup`)
    on_attach = function(client, bufnr)
      -- this would disable semanticTokensProvider for all clients
      -- client.server_capabilities.semanticTokensProvider = nil
    end,
  },
}
