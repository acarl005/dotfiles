function serializeTable(val, name, skipnewlines, depth)
  skipnewlines = skipnewlines or false
  depth = depth or 0

  local tmp = string.rep(" ", depth)

  if name then tmp = tmp .. name .. " = " end

  if type(val) == "table" then
    tmp = tmp .. "{" .. (not skipnewlines and "\n" or "")

    for k, v in pairs(val) do
      tmp = tmp .. serializeTable(v, k, skipnewlines, depth + 1) .. "," .. (not skipnewlines and "\n" or "")
    end

    tmp = tmp .. string.rep(" ", depth) .. "}"
  elseif type(val) == "number" then
    tmp = tmp .. tostring(val)
  elseif type(val) == "string" then
    tmp = tmp .. string.format("%q", val)
  elseif type(val) == "boolean" then
    tmp = tmp .. (val and "true" or "false")
  else
    tmp = tmp .. "\"[inserializeable datatype:" .. type(val) .. "]\""
  end

  return tmp
end

local config = {
  -- set vim options here (vim.<first_key>.<second_key> = value)
  options = {
    opt = {
      relativenumber = false,
      scrolloff = 15,
      wrap = true,
      cmdheight = 1,
    },
    g = {
      heirline_bufferline = true,
    },
  },
  -- Extend LSP configuration
  lsp = {
    -- easily add or disable built in mappings added during LSP attaching
    mappings = {
      n = {
        ["<leader>lw"] = {
          "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>",
          desc = "Show symbols in the whole workspace"
        },
        ["<leader>lci"] = { "<cmd>Telescope lsp_incoming_calls<cr>", desc = "Show incoming calls for this function" },
        ["<leader>lco"] = { "<cmd>Telescope lsp_outgoing_calls<cr>", desc = "Show outgoing calls in this function" },
        ["&d"] = { ":vsp<cr>:lua vim.lsp.buf.definition()<cr>", desc = "Open definition in a vsplit" },
        ["&T"] = { ":vsp<cr>:lua vim.lsp.buf.type_definition()<cr>", desc = "Open type definition in a vsplit" },
      },
    },
  },
  mappings = {
    n = {
      -- I use this to open my Tagbar instead
      ["<leader>tt"] = false,
      ["gV"] = { "`[v`]", desc = "Select the text you just pasted" },
      ["<leader>x{"] = { "<i{0]}dd[{dd", desc = "Remove wrapping curly brace pair" },
      ["<leader>x("] = { "<i(0])dd[(dd", desc = "Remove wrapping parentheses" },
      ["<leader>x["] = { "<i[0]]dd[[dd", desc = "Remove wrapping square bracket pair" },
      ["<c-p>"] = { ":Telescope find_files<CR>", desc = "Search files" },
    },
  },
  -- Configure plugins
  plugins = {
    init = {
      -- You can disable default plugins as follows:
      -- ["goolord/alpha-nvim"] = { disable = true },

      -- MacOS: brew install --HEAD universal-ctags/universal-ctags/universal-ctags
      -- Linux: sudo snap install universal-ctags
      {
        "preservim/tagbar", -- a ctag/class outline viewer
        config = function()
          vim.keymap.set("n", "<leader>tt", ":TagbarToggle<cr>", { noremap = true })
        end
      },
      {
        "petertriho/nvim-scrollbar", -- adds a scrollbar to the right of the view
        config = function()
          require("scrollbar").setup()
        end
      },
      {
        "chentoast/marks.nvim", -- show the marks on the left
        config = function()
          require("marks").setup()
        end
      },
      {
        "airblade/vim-rooter", -- adds :Rooter command to change pwd to the project root
        config = function()
          vim.g.rooter_manual_only = 1
        end
      },
      {
        "tyru/open-browser-github.vim", -- opens current buffer in GitHub
        requires = { "tyru/open-browser.vim" }
      },
      {
        "sgur/vim-textobj-parameter", -- text object for function params to ","
        requires = { "kana/vim-textobj-user" }
      },
    },
    treesitter = {
      ensure_installed = { "lua" },
    },
    ["mason-lspconfig"] = {
      ensure_installed = { "sumneko_lua" },
    },
    heirline = function(config)
      local file_path = {
        {
          provider = function()
            return vim.fn.expand("%")
          end
        },
        padding = { left = 1, right = 1 },
      }

      config[1] = {
        -- statusline
        hl = { fg = "fg", bg = "bg" },
        astronvim.status.component.mode(),
        astronvim.status.component.git_branch(),
        astronvim.status.component.file_info(
          (astronvim.is_available "bufferline.nvim" or vim.g.heirline_bufferline)
          and { filetype = {}, filename = false, file_modified = false }
          or nil
        ),
        file_path,
        astronvim.status.component.git_diff(),
        astronvim.status.component.diagnostics(),
        astronvim.status.component.fill(),
        astronvim.status.component.cmd_info(),
        astronvim.status.component.fill(),
        astronvim.status.component.lsp(),
        astronvim.status.component.treesitter(),
        astronvim.status.component.nav(),
        astronvim.status.component.mode { surround = { separator = "right" } },
      }
      return config
    end
  },
  -- Customize Heirline options
  heirline = {
    -- Customize different separators between sections
    separators = {
      tab = { "", "" },
    },
    -- -- Customize colors for each element each element has a `_fg` and a `_bg`
    -- colors = function(colors)
    --   colors.git_branch_fg = astronvim.get_hlgroup "Conditional"
    --   return colors
    -- end,
    -- -- Customize attributes of highlighting in Heirline components
    -- attributes = {
    --   -- styling choices for each heirline element, check possible attributes with `:h attr-list`
    --   git_branch = { bold = true }, -- bold the git branch statusline component
    -- },
    -- -- Customize if icons should be highlighted
    -- icon_highlights = {
    --   breadcrumbs = false, -- LSP symbols in the breadcrumbs
    --   file_icon = {
    --     winbar = false, -- Filetype icon in the winbar inactive windows
    --     statusline = true, -- Filetype icon in the statusline
    --   },
    -- },
  },
  -- This function is run last and is a good place to configuring
  -- augroups/autocommands and custom filetypes also this just pure lua so
  -- anything that doesn't fit in the normal config locations above can go here
  polish = function()
    -- remove trailing whitespace
    vim.api.nvim_create_user_command("Trim", ":let _s=@/<Bar>:%s/\\s\\+$//e<Bar>:let @/=_s", {})

    -- convert snake_case to camelCase
    vim.api.nvim_create_user_command("Camel", "%s/\\([a-z0-9]\\)_\\([a-z0-9]\\)/\\1\\u\\2/g", {})

    -- print absolute file path
    vim.api.nvim_create_user_command("F", ":echo expand('%:p')", {})

    -- close all buffers except current
    vim.api.nvim_create_user_command("Purge", "%bd|e#|bd#", {})

    -- open this file
    vim.api.nvim_create_user_command(
      "Conf",
      function()
        vim.cmd("badd ~/.config/nvim/lua/user/init.lua")
        vim.cmd("b ~/.config/nvim/lua/user/init.lua")
      end,
      {}
    )

    -- shows how the current buffer differs from the file on disk
    vim.cmd([[
      function! s:DiffWithSaved()
        let filetype=&ft
        diffthis
        vnew | r # | normal! 1Gdd
        diffthis
        exe "setlocal bt=nofile bh=wipe nobl noswf ro ft=" . filetype
      endfunc
      com! DiffSaved call s:DiffWithSaved()
    ]])
  end,
}

return config
