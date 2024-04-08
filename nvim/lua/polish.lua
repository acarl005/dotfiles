-- This will run last in the setup process and is a good place to configure
-- things like custom filetypes. This just pure lua so anything that doesn't
-- fit in the normal config locations above can go here

local edit_config = function() vim.cmd "e ~/.config/nvim/lua/user/init.lua" end

-- Set up custom filetypes
vim.filetype.add {
  extension = {
    wgsl = "wgsl",
  },
  filename = {
    -- ["Foofile"] = "fooscript",
  },
  pattern = {
    -- ["~/%.config/foo/.*"] = "fooscript",
  },
}

-- remove trailing whitespace
vim.api.nvim_create_user_command(
  "Trim",
  ":let _s=@/<Bar>:%s/\\s\\+$//e<Bar>:let @/=_s",
  { desc = "Trim the trailing whitespace off each line" }
)

-- convert snake_case to camelCase
vim.api.nvim_create_user_command(
  "Camel",
  "%s/\\([a-z0-9]\\)_\\([a-z0-9]\\)/\\1\\u\\2/g",
  { desc = "Convert snake case to camel case" }
)

-- print absolute file path
vim.api.nvim_create_user_command("F", ":echo expand('%:p')", { desc = "Echo absolute path of current buffer" })

-- open this file
vim.api.nvim_create_user_command("Conf", edit_config, { desc = "Edit config file" })

-- shows how the current buffer differs from the file on disk
vim.cmd [[
	function! s:DiffWithSaved()
		let filetype=&ft
		diffthis
		vnew | r # | normal! 1Gdd
		diffthis
		exe "setlocal bt=nofile bh=wipe nobl noswf ro ft=" . filetype
		endfunc
	com! DiffSaved call s:DiffWithSaved()
]]

vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
  signs = {
    severity_limit = "Hint",
  },
  virtual_text = {
    severity_limit = "Warning",
  },
})
