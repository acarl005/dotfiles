---@type LazySpec
return {
  "nvim-treesitter/nvim-treesitter",
  opts = {
    ensure_installed = { "lua", "luadoc", "vim", "vimdoc" },
    textobjects = {
      move = {
        goto_next_start = {
          ["]c"] = { query = "@class.outer", desc = "Next class start" },
          ["]f"] = { query = "@function.outer", desc = "Next function start" },
          ["]l"] = { query = "@loop.outer", desc = "Next loop start" },
          ["]?"] = { query = "@conditional.outer", desc = "Next conditional start" },
        },
        goto_next_end = {
          ["]C"] = { query = "@class.outer", desc = "Next class end" },
          ["]F"] = { query = "@function.outer", desc = "Next function end" },
          ["]L"] = { query = "@loop.outer", desc = "Next loop end" },
        },
        goto_previous_start = {
          ["[c"] = { query = "@class.outer", desc = "Previous class start" },
          ["[f"] = { query = "@function.outer", desc = "Previous function start" },
          ["[l"] = { query = "@loop.outer", desc = "Previous loop start" },
          ["[?"] = { query = "@conditional.outer", desc = "Previous conditional start" },
        },
        goto_previous_end = {
          ["[C"] = { query = "@class.outer", desc = "Previous class end" },
          ["[F"] = { query = "@function.outer", desc = "Previous function end" },
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
