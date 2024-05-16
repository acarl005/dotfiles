-- Set up custom filetypes
vim.filetype.add {
  extension = {
    wgsl = "wgsl",
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

vim.diagnostic.config {
  virtual_text = { severity = { min = vim.diagnostic.severity.WARN } },
  signs = { severity = { min = vim.diagnostic.severity.HINT } },
}
