vim.api.nvim_create_user_command(
  "Trim",
  ":let _s=@/<Bar>:%s/\\s\\+$//e<Bar>:let @/=_s",
  { desc = "Trim the trailing whitespace off each line" }
)

vim.api.nvim_create_user_command(
  "Camel",
  "%s/\\([a-z0-9]\\)_\\([a-z0-9]\\)/\\1\\u\\2/g",
  { desc = "Convert snake case to camel case" }
)

vim.api.nvim_create_user_command("F", ":echo expand('%:p')", { desc = "Echo absolute path of current buffer" })
vim.api.nvim_create_user_command(
  "LspLog",
  function() vim.cmd.edit(vim.lsp.get_log_path()) end,
  { desc = "Open LSP log" }
)

vim.api.nvim_create_user_command("Unescape", function()
  vim.cmd "%s/\\\\n/\\r/g"
  vim.cmd '%s/\\\\"/"/g'
end, { desc = "Unescape quotes and newlines" })

-- Treesitter directive: inject language from /* lang */ block comments in template literals
vim.treesitter.query.add_directive("inject-lang-from-block-comment!", function(match, _, bufnr, pred, metadata)
  local node_or_nodes = match[pred[2]]
  if not node_or_nodes then return end
  local comment_node = type(node_or_nodes) == "table" and node_or_nodes[1] or node_or_nodes
  if not comment_node then return end
  local text = vim.treesitter.get_node_text(comment_node, bufnr)
  local lang = text:match "/%*%s*(%w+)%s*%*/"
  if lang then
    metadata["injection.language"] = lang:lower()
    metadata["injection.include-children"] = true
  end
end, { force = true })

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
