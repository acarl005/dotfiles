---@type LazySpec
return {
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
  { "ii14/neorepl.nvim" },
}
