set noexpandtab
set softtabstop=4
set tabstop=4
set shiftwidth=4

imap ç fmt.Printf("%+v\n", )<C-c>i

if executable("goimports") == 1
  augroup NAME_OF_GROUP
    autocmd!
    autocmd BufWritePost * GoImports
  augroup end
endif
