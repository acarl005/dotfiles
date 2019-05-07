set noexpandtab
set softtabstop=4
set tabstop=4
set shiftwidth=4

if executable("goimports") == 1
  augroup NAME_OF_GROUP
    autocmd!
    autocmd BufWritePost * GoImports
  augroup end
endif
