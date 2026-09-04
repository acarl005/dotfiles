---@type LazySpec
return {
  { "akinsho/toggleterm.nvim", enabled = false },
  {
    "mason-org/mason.nvim",
    ---@class MasonSettings
    opts = {
      ui = {
        border = "rounded",
      },
    },
  },
  {
    "folke/snacks.nvim",
    ---@type snacks.Config
    opts = {
      picker = {
        previewers = {
          file = {
            max_size = 4 * 1024 * 1024,
            max_line_length = 32 * 1024,
          },
        },
      },
      dashboard = {
        preset = {
          header = table.concat({
            [[   ,φ≥        ▒                                                                 ]],
            [[ ,@╬╬▒▒       ╬╬▒╖                                            ▄▄                ]],
            [[δ▒╠╬╬╠╠╠╦     ╬╬╬╬▓                                           ╙╙                ]],
            [[╠▒▒╠╬╠╠╠╠▒    ╣╬╬╬╬     ▐QÆT^"▀┐  ,Æ""""▄   Æ"^^▀╗ ╙██    ▐█▌ ██  ██▓▓▀█▓▄▓▀▓█▓ ]],
            [[╠▒▒▒╠└╠╠╠╠╠ε  ╣╬╬╬╬     ▐▌     █ ]▌      ▌ ▌      ▓ ╙█▓  ▐█▓  ██  ██─  ▐██   ╟██]],
            [[╠╠╠╠╠  ╠╬╬╬╬▒ ╣▓▓▓▓     ▐▌     ▓ ▐▌‾‾‾‾‾‾ ▐▌      ╟▌ ╟█▌┌██   ██  ██   ▐██   ╞██]],
            [[╠╠╠╠╠   ╙╬╬╬╬╬╣▓▓▓▓     ▐▌     ▓  ▓        ▓     ,▓   ╟█▓█    ██  ██   ▐██   ╞██]],
            [[╠╠╠╠╠     ╢╬╬╬╣╬▓▓▓     └^     ╙   └"²²"`   └"²²"└     ╙╙`    ▀▀  ▀▀    ▀▀   └▀╙]],
            [[`╝╬╬╬      ╙╬╬╣╣╬▓╜                                                             ]],
            [[   ╚╬        ╣▓▓╙                                                               ]],
          }, "\n"),
        },
      },
      image = {
        force = vim.env.TERM_PROGRAM == "WarpTerminal",
      },
      picker = {
        previewers = {
          file = {
            max_size = 50 * 1024 * 1024, -- 50MB (default is 1MB)
          },
        },
      },
    },
  },
  {
    "rebelot/heirline.nvim",
    opts = function(_, opts)
      local status = require "astroui.status"

      local file_path = {
        provider = function()
          local path = vim.fn.expand "%:~:."
          if path == "" then return "" end

          local root_info = require("astrocore.rooter").detect(0, false)[1] or {}
          local root_path = (root_info.paths or {})[1]
          if root_path then
            local root = vim.fn.fnamemodify(root_path, ":~")
            if path:find(root, 1, true) == 1 then path = path:sub(#root + 2) end
          end
          local max_length = 4
          local sep = package.config:sub(1, 1)
          local parts = vim.split(path, "[\\/]")
          if #parts > max_length then
            parts = { parts[1], "…", table.concat({ unpack(parts, #parts - max_length + 2, #parts) }, sep) }
          end
          return table.concat(parts, sep)
        end,
      }

      opts.statusline = {
        status.component.mode { mode_text = { padding = { left = 1, right = 1 } } },
        status.component.git_branch(),
        status.component.file_info { filetype = {}, filename = false, file_modified = false },
        file_path,
        status.component.git_diff(),
        status.component.diagnostics(),
        status.component.fill(),
        status.component.cmd_info(),
        status.component.fill(),
        status.component.lsp(),
        status.component.treesitter(),
        status.component.nav(),
      }

      return opts
    end,
  },
  {
    "nvim-neo-tree/neo-tree.nvim",
    opts = {
      window = {
        mappings = {
          H = "prev_source",
          L = "next_source",
        },
      },
    },
  },
  {
    -- text object for function params to ","
    "sgur/vim-textobj-parameter",
    lazy = false,
    dependencies = { "kana/vim-textobj-user" },
  },
  {
    -- https://github.com/AstroNvim/astrocommunity/blob/a93944a58433b2daef83342bb9ea24b02376fee7/lua/astrocommunity/pack/rust/init.lua#L57-L70
    "Saecki/crates.nvim",
    event = { "BufRead Cargo.toml" },
    opts = {
      completion = {
        crates = { enabled = true },
      },
      lsp = {
        enabled = true,
        on_attach = function(...) require("astrolsp").on_attach(...) end,
        actions = true,
        completion = true,
        hover = true,
      },
    },
    config = function(_, opts)
      local crates = require "crates"
      crates.setup(opts)
      vim.keymap.set("n", "<leader>Gc", crates.show_crate_popup, { desc = "Crates: show crate metadata popup" })
      vim.keymap.set("n", "<leader>Gv", crates.show_versions_popup, { desc = "Crates: show versions popup" })
      vim.keymap.set("n", "<leader>Gf", crates.show_features_popup, { desc = "Crates: show features popup" })
      vim.keymap.set("n", "<leader>Gd", crates.show_dependencies_popup, { desc = "Crates: show dependencies popup" })
    end,
  },
  {
    "sindrets/diffview.nvim",
    opts = {
      hooks = {
        -- Remap highlight groups per-window so the left (old/"a") side renders
        -- as red and the right (new/"b") side renders as green, GitHub-style.
        diff_buf_win_enter = function(bufnr, _, ctx)
          if ctx.layout_name:match "^diff2" then
            if ctx.symbol == "a" then
              vim.opt_local.winhl = table.concat({
                "DiffAdd:DiffviewDiffAddAsDelete",
                "DiffChange:DiffviewDiffAddAsDelete",
                "DiffText:DiffviewDiffDeleteText",
              }, ",")
            elseif ctx.symbol == "b" then
              vim.opt_local.winhl = table.concat({
                "DiffChange:DiffAdd",
                "DiffText:DiffviewDiffAddText",
              }, ",")
            end
          end

          -- gitsigns sets buffer-local ]g/[g mappings via its own on_attach,
          -- which can fire after this buffer is opened and clobber diffview's
          -- bindings. Reassert non-recursive ]g/[g -> ]c/[c (builtin hunk
          -- jump) here, since this hook runs last, per diff buffer/window.
          vim.keymap.set("n", "]g", "]c", { buffer = bufnr, desc = "Next hunk" })
          vim.keymap.set("n", "[g", "[c", { buffer = bufnr, desc = "Previous hunk" })
        end,
      },
    },
    config = function(_, opts)
      require("diffview").setup(opts)
      vim.api.nvim_set_hl(0, "DiffAdd", { bg = "#1e3a2e" })
      vim.api.nvim_set_hl(0, "DiffviewDiffAddAsDelete", { bg = "#3a1e1e" })
      vim.api.nvim_set_hl(0, "DiffviewDiffDeleteText", { bg = "#5a2626" })
      vim.api.nvim_set_hl(0, "DiffviewDiffAddText", { bg = "#2a5a3a" })
      vim.api.nvim_set_hl(0, "DiffDelete", { bg = "NONE", fg = "#7a3a3a" })
    end,
  },
  {
    "lewis6991/gitsigns.nvim",
    opts = function(_, opts)
      local orig_on_attach = opts.on_attach
      opts.on_attach = function(bufnr)
        if orig_on_attach then orig_on_attach(bufnr) end

        -- gitsigns computes hunks asynchronously and may call on_attach
        -- after diffview has already set up a diff buffer/window, silently
        -- re-clobbering ]g/[g with gitsigns' own hunk nav. If this buffer's
        -- window is in diff mode, force ]g/[g back to the builtin (and
        -- diffview-aware) ]c/[c hunk jump, applied last, buffer-local.
        local winid = vim.fn.bufwinid(bufnr)
        if winid ~= -1 and vim.wo[winid].diff then
          vim.keymap.set("n", "]g", "]c", { buffer = bufnr, desc = "Next hunk" })
          vim.keymap.set("n", "[g", "[c", { buffer = bufnr, desc = "Previous hunk" })
        end
      end
      return opts
    end,
  },
  { "ii14/neorepl.nvim" },
  {
    "rmagatti/goto-preview",
    dependencies = { "rmagatti/logger.nvim" },
    event = "LspAttach",
    opts = {},
    specs = {
      {
        "AstroNvim/astrocore",
        opts = {
          mappings = {
            n = {
              ["<leader>lp"] = {
                function() require("goto-preview").goto_preview_definition() end,
                desc = "Peek definition",
              },
              ["<leader>lP"] = {
                function() require("goto-preview").goto_preview_type_definition() end,
                desc = "Peek type definition",
              },
            },
          },
        },
      },
    },
  },
}
