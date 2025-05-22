---@type LazySpec
return {
  "AstroNvim/astrocommunity",
  { import = "astrocommunity.colorscheme.cyberdream-nvim" },
  { import = "astrocommunity.pack.lua" },
  { import = "astrocommunity.recipes.picker-lsp-mappings" },
  { import = "astrocommunity.lsp.actions-preview-nvim" },
  { import = "astrocommunity.bars-and-lines.bufferline-nvim" },
  { import = "astrocommunity.editing-support.mini-splitjoin" },
  { import = "astrocommunity.editing-support.nvim-treesitter-context" },
  {
    "nvim-treesitter-context",
    config = function()
      require("treesitter-context").setup { max_lines = 10, trim_scope = "inner" }
      vim.keymap.set(
        "n",
        "[x",
        function() require("treesitter-context").go_to_context(vim.v.count1) end,
        { desc = "Beginning of context" }
      )
    end,
  },
  { import = "astrocommunity.editing-support.rainbow-delimiters-nvim" },
  { import = "astrocommunity.git.blame-nvim" },
  { import = "astrocommunity.motion.nvim-surround" },
  { import = "astrocommunity.scrolling.nvim-scrollbar" },
  { import = "astrocommunity.utility.noice-nvim" },
  { import = "astrocommunity.completion.avante-nvim" },
  {
    "avante.nvim",
    opts = {
      provider = "openai",
      openai = {
        model = "gpt-4o",
      },
    },
  },
}
