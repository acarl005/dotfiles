set tabstop=4
set shiftwidth=4
set noexpandtab
augroup NAME_OF_GROUP
  autocmd!
  autocmd BufWritePost * GoImports
augroup end
