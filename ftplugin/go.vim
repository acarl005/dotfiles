set noexpandtab
augroup NAME_OF_GROUP
  autocmd!
  autocmd BufWritePost * GoImports
augroup end
