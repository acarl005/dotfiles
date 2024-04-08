local edit_config = function() vim.cmd "e ~/.config/nvim/lua/user/init.lua" end

---@type LazySpec
return {

  -- == Examples of Adding Plugins ==

  "andweeb/presence.nvim",
  {
    "ray-x/lsp_signature.nvim",
    event = "BufRead",
    config = function() require("lsp_signature").setup() end,
  },

  -- == Examples of Overriding Plugins ==

  -- customize alpha options
  {
    "goolord/alpha-nvim",
    opts = function(_, opts)
      opts.config.layout[4].val[7] = {
        val = "  Configure",
        opts = {
          shortcut = "SPC ,  ",
          hl_shortcut = "DashboardShortcut",
          align_shortcut = "right",
          width = 36,
          cursor = 5,
          hl = "DashboardCenter",
          text = "  Configure",
          position = "center",
        },
        on_press = edit_config,
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

  -- You can disable default plugins as follows:
  { "max397574/better-escape.nvim", enabled = false },

  -- You can also easily customize additional setup of plugins that is outside of the plugin's setup call
  {
    "L3MON4D3/LuaSnip",
    config = function(plugin, opts)
      require "astronvim.plugins.configs.luasnip"(plugin, opts) -- include the default astronvim config that calls the setup call
      -- add more custom luasnip configuration such as filetype extend or custom snippets
      local luasnip = require "luasnip"
      luasnip.filetype_extend("javascript", { "javascriptreact" })
    end,
  },

  {
    "windwp/nvim-autopairs",
    config = function(plugin, opts)
      require "astronvim.plugins.configs.nvim-autopairs"(plugin, opts) -- include the default astronvim config that calls the setup call
      -- add more custom autopairs configuration such as custom rules
      local npairs = require "nvim-autopairs"
      local Rule = require "nvim-autopairs.rule"
      local cond = require "nvim-autopairs.conds"
      npairs.add_rules(
        {
          Rule("$", "$", { "tex", "latex" })
            -- don't add a pair if the next character is %
            :with_pair(cond.not_after_regex "%%")
            -- don't add a pair if  the previous character is xxx
            :with_pair(
              cond.not_before_regex("xxx", 3)
            )
            -- don't move right when repeat character
            :with_move(cond.none())
            -- don't delete if the next character is xx
            :with_del(cond.not_after_regex "xx")
            -- disable adding a newline when you press <cr>
            :with_cr(cond.none()),
        },
        -- disable for .vim files, but it work for another filetypes
        Rule("a", "a", "-vim")
      )
    end,
  },

  {
    "rebelot/heirline.nvim",
    opts = function(_, opts)
      local status = require "astroui.status"

      local file_path = {
        {
          provider = function() return vim.fn.expand "%" end,
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
