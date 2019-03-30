set noexpandtab
set softtabstop=4
set tabstop=4
set shiftwidth=4

augroup NAME_OF_GROUP
  autocmd!
  autocmd BufWritePost * GoImports
augroup end
