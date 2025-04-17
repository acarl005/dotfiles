---@type LazySpec
return {
  "nvim-treesitter/nvim-treesitter",
  opts = {
    ensure_installed = { "diff", "lua", "luadoc", "vim", "vimdoc" },
    auto_install = vim.fn.executable "tree-sitter" == 1,
    textobjects = {
      move = {
        enable = true,
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
}
