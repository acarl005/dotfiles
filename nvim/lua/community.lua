---@type LazySpec
return {
  "AstroNvim/astrocommunity",
  { import = "astrocommunity.pack.lua" },
  { import = "astrocommunity.bars-and-lines.bufferline-nvim" },
  { import = "astrocommunity.editing-support.mini-splitjoin" },
  { import = "astrocommunity.editing-support.nvim-treesitter-context" },
  {
    "nvim-treesitter-context",
    config = function()
      vim.keymap.set("n", "[x", function() require("treesitter-context").go_to_context(vim.v.count1) end)
    end,
  },
  { import = "astrocommunity.editing-support.rainbow-delimiters-nvim" },
  { import = "astrocommunity.git.blame-nvim" },
  { import = "astrocommunity.motion.nvim-surround" },
  { import = "astrocommunity.scrolling.nvim-scrollbar" },
  { import = "astrocommunity.utility.noice-nvim" },
}
