-- AstroCore provides a central place to modify mappings, vim options, autocommands, and more!
-- Configuration documentation can be found with `:h astrocore`
-- NOTE: We highly recommend setting up the Lua Language Server (`:LspInstall lua_ls`)
--       as this provides autocomplete and documentation while editing

local edit_config = function() vim.cmd "e ~/.config/nvim/lua/user/init.lua" end

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
        relativenumber = true,
        number = true,
        spell = false,
        signcolumn = "auto",
        wrap = true,
        title = false,
        cmdheight = 1,
        scrolloff = 20,
      },
    },
    mappings = {
      n = {
        ["<tab>"] = { ":wincmd w<cr>", desc = "Next window" },
        -- ["<leader>,"] = { edit_config, desc = "Edit user config file" },
        ["gV"] = { "`[v`]", desc = "Select the text you just pasted" },
        ["<leader>x{"] = { "<i{0]}dd[{dd", desc = "Remove wrapping curly brace pair" },
        ["<leader>x("] = { "<i(0])dd[(dd", desc = "Remove wrapping parentheses" },
        ["<leader>x["] = { "<i[0]]dd[[dd", desc = "Remove wrapping square bracket pair" },
        ["<leader>gB"] = { ":ToggleBlame<cr>", desc = "Show git blame gutter" },
        ["<c-p>"] = { ":Telescope find_files<cr>", desc = "Search files" },
        L = { function() require("astrocore.buffer").nav(vim.v.count1) end, desc = "Next buffer" },
        H = { function() require("astrocore.buffer").nav(-vim.v.count1) end, desc = "Previous buffer" },

        -- mappings seen under group name "Buffer"
        -- ["<Leader>bD"] = {
        --   function()
        --     require("astroui.status.heirline").buffer_picker(
        --       function(bufnr) require("astrocore.buffer").close(bufnr) end
        --     )
        --   end,
        --   desc = "Pick to close",
        -- },
        -- tables with just a `desc` key will be registered with which-key if it's installed
        -- this is useful for naming menus
        -- ["<Leader>b"] = { desc = "Buffers" },
        -- quick save
        -- ["<C-s>"] = { ":w!<cr>", desc = "Save File" },  -- change description but the same command
      },
      i = {
        ["<c-l>"] = { "<c-o>O", desc = "Enter newline above current line" },
      },
    },
  },
}
