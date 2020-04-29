set nocompatible              " be iMproved, required
filetype off                  " required

" some stuff only works with some vim plugins installed via Vundle
" to enable download it with this command
" git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
" then open vim and run :PluginInstall
let vundle_installed = 0

" set the runtime path to include Vundle and initialize
set runtimepath+=~/.vim/bundle/Vundle.vim
try
  call vundle#begin()
  " alternatively, pass a path where Vundle should install plugins
  "call vundle#begin('~/some/path/here')

  " let Vundle manage Vundle, required
  Plugin 'VundleVim/Vundle.vim'

  " plugin from http://vim-scripts.org/vim/scripts.html
  Plugin 'L9'


  " editing utilities
  Plugin 'cohama/lexima.vim' " automatically insert enclosing parentheses
  Plugin 'mattn/emmet-vim' " adds snippets and stuff for editint HTML/XML/JSX
  Plugin 'andymass/vim-matchup' " replacement for builtin matchit
  Plugin 'terryma/vim-multiple-cursors' " sublime-text-like multi cursors
  Plugin 'tpope/vim-surround' " manipulates surrounding brackets and quotes
  Plugin 'scrooloose/nerdcommenter' " adds keybindings for easily commenting out lines \c<space> to toggle
  Plugin 'tpope/vim-repeat' " adds . support for the vim-surround maps
  Plugin 'AndrewRadev/splitjoin.vim' " switch formatting of objects between one-line and multi-line with gj and gS
  Plugin 'skammer/vim-swaplines' " move lines up or down

  " appearances
  Plugin 'Yggdroot/indentLine' " adds a little grey line at each indentation level
  Plugin 'airblade/vim-gitgutter' " adds git diff symbols on the left hand side
  Plugin 'eapache/rainbow_parentheses.vim' " color parentheses based on depth
  Plugin 'ryanoasis/vim-devicons' " add icons for specific file types
  Plugin 'machakann/vim-highlightedyank' " briefly highlights the text that was just yanked

  " themes
  Plugin 'NLKNguyen/papercolor-theme' " great for light theme
  Plugin 'acarl005/vim-gotham' " great for dark theme

  " addon windows/commands
  Plugin 'tpope/vim-fugitive' " a git wrapper
  Plugin 'scrooloose/nerdtree' " a file explorer
  Plugin 'ctrlpvim/ctrlp.vim' " fuzzy searching for files
  Plugin 'mileszs/ack.vim' " call ack command from vim
  Plugin 'majutsushi/tagbar' " adds a tagbar
  Plugin 'vim-airline/vim-airline' " an awesome looking status bar

  " syntax/language stuff
  Plugin 'w0rp/ale' " syntax checker, has pretty good functionality built in already
  Plugin 'prabirshrestha/asyncomplete.vim' " asyncronous autocomplete framework
  Plugin 'prabirshrestha/async.vim' " normalize async job control api for vim and neovim. only needed for compatibility
  Plugin 'prabirshrestha/asyncomplete-buffer.vim' " adds an autocomplete source for tokens in the current buffer
  Plugin 'prabirshrestha/asyncomplete-file.vim'
  " language server support. ALE is good enough for syntax validation. just use this for autocomplete
  " note that the actual language servers must be installed separately
  Plugin 'prabirshrestha/vim-lsp'
  Plugin 'prabirshrestha/asyncomplete-lsp.vim' " get asyncomplete to integreate with vim-lsp
  Plugin 'ryanolsonx/vim-lsp-javascript' " npm install -g typescript typescript-language-server
  Plugin 'ryanolsonx/vim-lsp-typescript' " npm install -g typescript typescript-language-server
  Plugin 'ryanolsonx/vim-lsp-python' " pip install python-language-server

  " syntax plugins
  Plugin 'neoclide/vim-jsx-improve' " better js AND jsx highlighting
  Plugin 'elzr/vim-json' " better json highlighting
  Plugin 'leafgarland/typescript-vim'
  Plugin 'exu/pgsql.vim' " postgres-specific SQL syntax
  Plugin 'cespare/vim-toml' " TOML syntax
  Plugin 'fatih/vim-go'
  Plugin 'martinda/Jenkinsfile-vim-syntax' " jenkinsfile is actually Groovy lang

  " text-object stuff
  Plugin 'kana/vim-textobj-user' " plugin for defining custom text objects
  Plugin 'glts/vim-textobj-comment' " binds a text object to c for comments
  Plugin 'nelstrom/vim-textobj-rubyblock' " binds a text object to r for ruby blocks
  Plugin 'michaeljsmith/vim-indent-object' " binds a text object to i for an indentation level (good for python)
  Plugin 'zandrmartin/vim-textobj-blanklines' " text obj for blank lines to <space>
  Plugin 'sgur/vim-textobj-parameter' " text obj for a function param to ,

  " All of your Plugins must be added before the following line
  call vundle#end()            " required

  let vundle_installed = 1

  " turn rainbow parentheses always on
  au VimEnter * RainbowParenthesesToggle
  au Syntax * RainbowParenthesesLoadRound
  au Syntax * RainbowParenthesesLoadSquare
  au Syntax * RainbowParenthesesLoadBraces

catch /Unknown function/
  " this allows us to use this vimrc even if the package manager Vundle isn't
  " installed. its still technically usable, it just throws a ton of errors,
  " which is annoying
endtry

filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line

" enable syntax highlighting
syntax on

" normally, you cannot switch buffers if the current one has unsaved changes.
" this allows it
set hidden

" try loading a custom one. fallback to a built-in one
try
  colorscheme gotham256
catch /^Vim\%((\a\+)\)\=:E185/
  colorscheme pablo
endtry

" Use dark color theme after 5pm and light color theme in the morning
"if strftime('%H') > 16
  "set background=dark
"elseif strftime('%H') < 7
  "set background=dark
"else
  "set background=light
"endif

" ALE config
let g:ale_sign_error = "✖"
let g:ale_sign_warning = "⚠"
let g:ale_sign_info = "i"
let g:ale_sign_hint = "➤"

" disable LSPs reporting in favor of ALE's
let g:lsp_diagnostics_enabled = 0         " disable diagnostics support


if vundle_installed == 1
  " register the autocomplete sources for asyncomplete
  au User asyncomplete_setup call asyncomplete#register_source(asyncomplete#sources#file#get_source_options({
    \ 'name': 'file',
    \ 'whitelist': ['*'],
    \ 'priority': 10,
    \ 'completor': function('asyncomplete#sources#file#completor')
    \ }))
  call asyncomplete#register_source(asyncomplete#sources#buffer#get_source_options({
    \ 'name': 'buffer',
    \ 'whitelist': ['*'],
    \ 'blacklist': ['go'],
    \ 'completor': function('asyncomplete#sources#buffer#completor'),
    \ }))
  " include the individual language servers if they are installed
  " for more, see https://github.com/prabirshrestha/vim-lsp/wiki/Servers
  " rustup update && rustup component add rls rust-analysis rust-src
  if executable('rls')
    au User lsp_setup call lsp#register_server({
      \ 'name': 'rls',
      \ 'cmd': {server_info->['rustup', 'run', 'stable', 'rls']},
      \ 'workspace_config': {'rust': {'clippy_preference': 'on'}},
      \ 'whitelist': ['rust'],
      \ })
  endif
  " npm install -g dockerfile-language-server-nodejs
  if executable('docker-langserver')
    au User lsp_setup call lsp#register_server({
      \ 'name': 'docker-langserver',
      \ 'cmd': {server_info->[&shell, &shellcmdflag, 'docker-langserver --stdio']},
      \ 'whitelist': ['dockerfile'],
      \ })
  endif
  " go get -u golang.org/x/tools/gopls
  if executable('gopls')
    au User lsp_setup call lsp#register_server({
      \ 'name': 'gopls',
      \ 'cmd': {server_info->['gopls']},
      \ 'whitelist': ['go'],
      \ })
    autocmd BufWritePre *.go LspDocumentFormatSync
  endif
endif

" my favorite font. also includes customized unicode characters for making airline look super dope
set guifont=Inconsolata\ for\ Powerline:h15
" tell airline to use those custom characters inspired by powerline.
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1

set encoding=utf-8
set termencoding=utf-8
set t_Co=256
set fillchars+=stl:\ ,stlnc:\

" default leader key is \ which is inconvenient
let mapleader = ','

set showcmd " Display commands in the bottom right corner as they are typed
set number " line numbers
"set relativenumber " line numbers are relative to where the cursor is (has performance issues on large files > 500 lines)

set expandtab " convert tab to spaces
set softtabstop=2 " how many spaces to insert for each <tab>
set tabstop=2 " the width to display a <tab> character
set shiftwidth=2 " used by commands like =, >, and < to know how much to indent
set autoindent
set smartindent
let g:pyindent_open_paren = 4
let g:pyindent_nested_paren = '&sw'
let g:pyindent_continue = '&sw'

set ignorecase " searches are case insensitive
set smartcase " searches become case sensitive when you enter capital letters
set hlsearch " highlight the current search term
set incsearch " highight search incrementally
" the vim clipboard is be the same as the system clipboard. requires vim to be compiled with the +clipboard option if you run :echo has('clipboard') and it returns 0, you need to re-install vim to make use of this
" this doesnt work on TMUX though, so guard with if statement
if $TMUX == ''
  " See this issue: https://github.com/Tudmotu/gnome-shell-extension-clipboard-indicator/issues/59
  if $XDG_CURRENT_DESKTOP == 'ubuntu:GNOME'
    set clipboard=unnamedplus
  else
    set clipboard=unnamed
  endif
endif
set backspace=indent,eol,start " enable backspace button
set scrolloff=15 " vim will automatically adjust viewport to leave at least 15 lines above and below cursor when possible
set wildignore=*/node_modules/*,*.swp,*.zip,*/dist/*
set nofoldenable " disables code folding, because its confusing and I can't find decent docs on it
" virtualedit allows you to move the cursor where there aren't any actual characters, for example after the end of the line
" block means this is only enabled in block edit mode
set virtualedit=block

" configure the status line
set laststatus=2 " always show the status bar

" these manually configure a nice status line. they are not necessary when airline is installed
if vundle_installed == 0
  set statusline=   " clear the statusline for when vimrc is reloaded
  set statusline=%f " show filename
  set statusline+=[%{strlen(&fenc)?&fenc:'none'},%{&ff}]  " show encoding
  set statusline+=%h%m%r%y
  set statusline+=%= " right align
  set statusline+=%c,%l/%L@%P\  " show column, line, line-count, and percent from top of file
  set statusline+=%b,0x%-8B\                   " current char
endif

" vim-go options
let g:go_def_mapping_enabled = 0

" indentline options
let g:indentLine_color_term = 236
let g:indentLine_char = '𝄄'
set list lcs=tab:\𝄄\ 

" set default SQL dialect to postgres. used with 'exu/pgsql.vim'
let g:sql_type_default = 'pgsql'

" nerd commenter align to the left
let g:NERDDefaultAlign = 'left'

" CtrlP options
let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'
let g:ctrlp_working_path_mode = 'ra'
let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files -co --exclude-standard']

" dont hide double quotes using vim-json
set conceallevel=0
let g:vim_json_syntax_conceal = 0

" vim includes a bunch of keybindings in SQL files that overwrite my own. disable those
let g:omni_sql_no_default_maps = 1

" prevent enter and ecs key from getting hijacked by asyncomplete
inoremap <expr> <CR> pumvisible() ? asyncomplete#close_popup() . "\<CR>" : "\<CR>"
" custom key mappings
" when in insert mode, insert line above
imap <nowait> <C-l> <C-c>O
" pretty format for a JSON file. just press =j
nmap =j :%!python -m json.tool<CR>
" open new tab
map <nowait> <C-t> :tabe<CR>
" remove all trailing whitespace
nnoremap <F5> :let _s=@/<Bar>:%s/\s\+$//e<Bar>:let @/=_s<Bar><CR>
" select the freshly pasted text
nnoremap <expr> gV    "`[".getregtype(v:register)[0]."`]"
" replace single quotes with double quotes
map <leader>' :s/"/'/g<CR>
" strip double quotes from keys in JSON. useful when pasting JSON into a JS
" file and the linter complains about unecessary quoting
map <leader>j :s/^\(\s*\)"\(\w\+\)"\s*:/\1\2:/g<CR>
" a more convenient save shortcut. 'update' only writes the file if there are any changes
map <leader>w :update<CR>
" dedent block and delete line with surrounding brackets
map <leader>x <i{]}dd[{dd
map <leader>d :bprevious<CR>
map <leader>f :bnext<CR>
map <leader>q :bdelete<CR>
map <leader>t :Tagbar<CR>

" open the file tree from nerd-tree
map <C-e> :NERDTreeToggle<CR>

" key mappings for primitivorm/vim-swaplines plugin
noremap <silent> <C-k> :SwapUp<CR>
noremap <silent> <C-j> :SwapDown<CR>


" maximize window and return to previous split structure
nnoremap <C-W>o :call MaximizeToggle()<CR>
nnoremap <C-W><C-o> :call MaximizeToggle()<CR>

function! MaximizeToggle()
  if exists("s:maximize_session")
    exec "source " . s:maximize_session
    call delete(s:maximize_session)
    unlet s:maximize_session
    let &hidden=s:maximize_hidden_save
    unlet s:maximize_hidden_save
  else
    let s:maximize_hidden_save = &hidden
    let s:maximize_session = tempname()
    set hidden
    exec "mksession! " . s:maximize_session
    only
  endif
endfunction


" open the vimrc
command Conf :badd ~/.vimrc
" command Trim :%s/\s\+$//g
command Trim :let _s=@/<Bar>:%s/\s\+$//e<Bar>:let @/=_s
" translate snake case to camel case
command Camel %s/\([a-z0-9]\)_\([a-z0-9]\)/\1\u\2/g

command Day :set background=light
command Night :set background=dark

command F :echo expand('%:p')

" convert 4-space indentation to 2-space
command Dedent call Dedent()
function! Dedent()
  set ts=4 sts=4 noet
  retab!
  set ts=2 sts=2 et
  retab
endfunction

" view a diff of the unsaved changes
function! s:DiffWithSaved()
  let filetype=&ft
  diffthis
  vnew | r # | normal! 1Gdd
  diffthis
  exe "setlocal bt=nofile bh=wipe nobl noswf ro ft=" . filetype
endfunction
com! DiffSaved call s:DiffWithSaved()

autocmd filetype crontab setlocal nobackup nowritebackup
