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
        fillchars = { diff = " " },
      },
    },
    mappings = {
      n = {
        ["gV"] = { "`[v`]", desc = "Select the text you just pasted" },
        ["<leader>x{"] = { "<i{0]}dd[{dd", desc = "Remove wrapping curly brace pair" },
        ["<leader>x("] = { "<i(0])dd[(dd", desc = "Remove wrapping parentheses" },
        ["<leader>x["] = { "<i[0]]dd[[dd", desc = "Remove wrapping square bracket pair" },
        ["<c-p>"] = { require("snacks").picker.files, desc = "Search files" },
        ["<c-,>"] = {
          function() require("snacks").picker.files { dirs = { vim.fn.stdpath "config" }, desc = "Config Files" } end,
          desc = "Find AstroNvim config files",
        },
        L = {
          function() require("bufferline.commands").cycle(1) end,
          desc = "Next buffer",
        },
        H = {
          function() require("bufferline.commands").cycle(-1) end,
          desc = "Previous buffer",
        },
        ["<leader>t"] = { desc = "Tabs" },
        ["<leader>tn"] = { ":tabnew<CR>", desc = "New tab" },
        ["<leader>tc"] = { ":tabclose<CR>", desc = "Close tab" },
        ["<leader>to"] = { ":tabonly<CR>", desc = "Close other tabs" },
        ["<leader>tf"] = { ":tabfirst<CR>", desc = "First tab" },
        ["<leader>tl"] = { ":tablast<CR>", desc = "Last tab" },
        ["<leader>tm"] = { ":tabmove<Space>", desc = "Move tab to position" },
        ["<leader>D"] = { desc = "Diffview" },
        ["<leader>Do"] = { ":DiffviewOpen<CR>", desc = "Open diff view" },
        ["<leader>Dc"] = { ":DiffviewClose<CR>", desc = "Close diff view" },
        ["<leader>Dh"] = { ":DiffviewFileHistory %<CR>", desc = "File history (current file)" },
        ["<leader>DH"] = { ":DiffviewFileHistory<CR>", desc = "File history (repo)" },
        ["<leader>Dt"] = { ":DiffviewToggleFiles<CR>", desc = "Toggle file panel" },
        ["<leader>Dr"] = { ":DiffviewRefresh<CR>", desc = "Refresh diff view" },
        ["<leader>Dm"] = {
          function()
            local function git(...)
              local out = vim.fn.systemlist { "git", ... }
              if vim.v.shell_error ~= 0 then return nil end
              return vim.trim(out[1] or "")
            end

            local base = git("symbolic-ref", "--short", "refs/remotes/origin/HEAD")
            if not base or base == "" then
              vim.notify("Could not determine origin/HEAD. Run: git remote set-head origin -a", vim.log.levels.ERROR)
              return
            end

            local merge_base = git("merge-base", "HEAD", base)
            if not merge_base or merge_base == "" then
              vim.notify("Could not determine merge-base with " .. base, vim.log.levels.ERROR)
              return
            end

            vim.cmd("DiffviewOpen " .. merge_base)
          end,
          desc = "Diff against merge-base with origin/HEAD",
        },
      },
    },
    treesitter = {
      ensure_installed = { "diff", "lua", "luadoc", "vim", "vimdoc" },
      textobjects = {
        move = {
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
      },
    },
  },
}
