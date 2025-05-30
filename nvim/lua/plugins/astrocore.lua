---@type LazySpec
return {
  "AstroNvim/astrocore",
  ---@type AstroCoreOpts
  opts = {
    -- Configure core features of AstroNvim
    features = {
      large_buf = { size = 4 * 1024 * 1024, lines = 32 * 1024 }, -- set global limits for large files for disabling features like treesitter
      autopairs = true,
      cmp = true,
      diagnostics = { virtual_text = true, virtual_lines = false },
      highlighturl = true,
      notifications = true,
    },
    -- Diagnostics configuration (for vim.diagnostics.config({...})) when diagnostics are on
    diagnostics = {
      virtual_text = true,
      underline = true,
    },
    options = {
      opt = {
        wrap = false,
        title = false,
        scrolloff = 9001,
      },
    },
    mappings = {
      n = {
        ["gV"] = { "`[v`]", desc = "Select the text you just pasted" },
        ["<leader>x{"] = { "<i{0]}dd[{dd", desc = "Remove wrapping curly brace pair" },
        ["<leader>x("] = { "<i(0])dd[(dd", desc = "Remove wrapping parentheses" },
        ["<leader>x["] = { "<i[0]]dd[[dd", desc = "Remove wrapping square bracket pair" },
        ["<c-p>"] = { require("snacks").picker.files, desc = "Search files" },
        L = {
          function() require("bufferline.commands").cycle(1) end,
          desc = "Next buffer",
        },
        H = {
          function() require("bufferline.commands").cycle(-1) end,
          desc = "Previous buffer",
        },
      },
    },
  },
}
