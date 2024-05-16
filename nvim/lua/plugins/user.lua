---@type LazySpec
return {
  {
    "goolord/alpha-nvim",
    opts = function(_, opts)
      opts.config.layout[4].val[7] = {
        val = "  Configure",
        opts = {
          shortcut = "LDR ,  ",
          hl_shortcut = "DashboardShortcut",
          align_shortcut = "right",
          width = 36,
          cursor = -2,
          hl = "DashboardCenter",
          text = "  Configure",
          position = "center",
        },
        on_press = function() vim.cmd ":tabnew ~/.config/nvim" end,
        type = "button",
      }
      opts.section.header.val = {
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
      }
    end,
  },
  {
    "rebelot/heirline.nvim",
    opts = function(_, opts)
      local status = require "astroui.status"

      local file_path = {
        {
          provider = function() return vim.fn.fnamemodify(vim.fn.expand "%", ":~") end,
        },
        padding = { left = 1, right = 1 },
      }

      opts.statusline = {
        hl = { fg = "fg", bg = "bg" },
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
    "xiyaowong/transparent.nvim",
    lazy = false,
    opts = {
      groups = {
        "Normal",
        "NormalNC",
        "Comment",
        "Constant",
        "Special",
        "Identifier",
        "Statement",
        "PreProc",
        "Type",
        "Underlined",
        "Todo",
        "String",
        "Function",
        "Conditional",
        "Repeat",
        "Operator",
        "Structure",
        "LineNr",
        "NonText",
        "SignColumn",
        "CursorLineNr",
        "EndOfBuffer",
      },
      exclude_groups = {},
    },
  },
  {
    "airblade/vim-rooter", -- adds :Rooter command to change pwd to the project root
    cmd = { "Rooter", "RooterToggle" },
    config = function() vim.g.rooter_manual_only = 1 end,
  },
  {
    "tyru/open-browser-github.vim", -- opens current buffer in GitHub
    lazy = false,
    dependencies = { "tyru/open-browser.vim" },
  },
  {
    "sgur/vim-textobj-parameter", -- text object for function params to ","
    lazy = false,
    dependencies = { "kana/vim-textobj-user" },
  },
}
