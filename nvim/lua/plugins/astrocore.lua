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
      diagnostics_mode = 3, -- diagnostic mode on start (0 = off, 1 = no signs/virtual text, 2 = no virtual text, 3 = on)
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
        wrap = true,
        title = false,
        cmdheight = 1,
        scrolloff = 9001,
      },
    },
    mappings = {
      n = {
        ["<tab>"] = { ":wincmd w<cr>", desc = "Next window" },
        ["<leader>,"] = { ":tabnew ~/.config/nvim<cr>", desc = "Edit user config files" },
        ["gV"] = { "`[v`]", desc = "Select the text you just pasted" },
        ["<leader>x{"] = { "<i{0]}dd[{dd", desc = "Remove wrapping curly brace pair" },
        ["<leader>x("] = { "<i(0])dd[(dd", desc = "Remove wrapping parentheses" },
        ["<leader>x["] = { "<i[0]]dd[[dd", desc = "Remove wrapping square bracket pair" },
        ["<leader>gB"] = { ":ToggleBlame<cr>", desc = "Show git blame gutter" },
        ["<c-p>"] = { ":Telescope find_files<cr>", desc = "Search files" },
        L = { function() require("astrocore.buffer").nav(vim.v.count1) end, desc = "Next buffer" },
        H = { function() require("astrocore.buffer").nav(-vim.v.count1) end, desc = "Previous buffer" },
      },
      i = {
        ["<c-l>"] = { "<c-o>O", desc = "Enter newline above current line" },
      },
    },
  },
}
