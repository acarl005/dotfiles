set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set runtimepath^=~/.vim/bundle/ctrlp.vim
set runtimepath+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

" plugin from http://vim-scripts.org/vim/scripts.html
Plugin 'L9'
" The sparkup vim script is in a subdirectory of this repo called vim.
" Pass the path to set the runtimepath properly.
Plugin 'rstacruz/sparkup', {'rtp': 'vim/'}

Plugin 'Townk/vim-autoclose.git' " auto add matching bracket or quote when you type one
"Plugin 'jiangmiao/auto-pairs' " auto add matching bracket or quote when you type one. has an annoying problem of skipping over the closing brace when i'm trying to actually insert one
Plugin 'terryma/vim-multiple-cursors' " sublime-text-like multi cursors
Plugin 'tpope/vim-surround' " manipulates surrounding brackets and quotes
Plugin 'tpope/vim-repeat' " adds . support for the vim-surround maps
Plugin 'tpope/vim-fugitive' " a git wrapper
Plugin 'ctrlpvim/ctrlp.vim' " fuzzy searching for files
Plugin 'Yggdroot/indentLine' " adds a little grey line at each indentation level
Plugin 'airblade/vim-gitgutter' " adds git diff symbols on the left hand side
Plugin 'scrooloose/nerdcommenter' " adds keybindings for easily commenting out lines \c<space> to toggle
Plugin 'scrooloose/nerdtree' " a file explorer
Plugin 'AndrewRadev/splitjoin.vim' " switch formatting of objects between one-line and multi-line with gj and gS
Plugin 'skammer/vim-swaplines' " move lines up or down
Plugin 'eapache/rainbow_parentheses.vim' " color parentheses based on depth
Plugin 'sagarrakshe/toggle-bool' " shortcut for toggling booleans in whatever language
Plugin 'mileszs/ack.vim' " call ack command from vim

Plugin 'scrooloose/syntastic' " inline syntax checker
Plugin 'jelera/vim-javascript-syntax' " better js highlighting
Plugin 'kchmck/vim-coffee-script'
Plugin 'leafgarland/typescript-vim'
Plugin 'elzr/vim-json' " better json highlighting 
Plugin 'derekwyatt/vim-scala'
Plugin 'exu/pgsql.vim' " postgres-specific SQL syntax

" a pretty status line 
" requires installation of this font package on OSX:
" https://github.com/powerline/fonts
" this font must be chosen for the terminal as well
Bundle 'Lokaltog/powerline', {'rtp': 'powerline/bindings/vim/'}

Plugin 'kana/vim-textobj-user' " plugin for defining custom text objects
Plugin 'glts/vim-textobj-comment' " binds a text object to c for comments
Plugin 'nelstrom/vim-textobj-rubyblock' " binds a text object to r for ruby blocks
Plugin 'michaeljsmith/vim-indent-object' " binds a text object to i for an indentation level (good for python)
Plugin 'zandrmartin/vim-textobj-blanklines' " text obj for blank lines to <space>
Plugin 'sgur/vim-textobj-parameter' " text obj for a function param to ,

Plugin 'NLKNguyen/papercolor-theme'
Plugin 'acarl005/vim-gotham'

" All of your Plugins must be added before the following line
call vundle#end()            " required
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

syntax on " enable syntax highlighting

" Use dark color theme after 5pm and light color theme in the morning
"colorscheme pablo
"colorscheme PaperColor
colorscheme gotham256
"if strftime('%H') > 16
  "set background=dark
"elseif strftime('%H') < 7
  "set background=dark
"else
  "set background=light
"endif

" a matching extension for things like ruby blocks
runtime macros/matchit.vim

" my favorite font. also includes customized unicode characters for making powerline look super dope
set guifont=Inconsolata\ for\ Powerline:h15
" tell powerline to use those custom characters. they look super dope
let g:Powerline_symbols = 'fancy'

set encoding=utf-8
set t_Co=256
set fillchars+=stl:\ ,stlnc:\
set term=xterm-256color
set termencoding=utf-8

" default leader key is \ which is inconvenient
let mapleader = ','

set showcmd " Display commands in the bottom right corner as they are typed
set expandtab " convert tab to spaces
set softtabstop=2 " how many spaces to insert for each <tab>
set tabstop=2 " the width to display a <tab> character
set shiftwidth=2 " used by commands like =, >, and < to know how much to indent
"set relativenumber " line numbers are relative to where the cursor is (has performance issues on large files > 500 lines)
set number " line numbers
set autoindent
set smartindent
set ignorecase " searches are case insensitive
set smartcase " searches become case sensitive when you enter capital letters
set hlsearch " highlight the current search term
set incsearch " highight search incrementally
set clipboard=unnamed " the vim clipboard is be the same as the system clipboard. requires vim to be compiled with the +clipboard option if you run :echo has('clipboard') and it returns 0, you need to re-install vim to make use of this
set backspace=indent,eol,start " enable backspace button
set scrolloff=15 " vim will automatically adjust viewport to leave at least 15 lines above and below cursor when possible
set wildignore=*/node_modules/*,*.swp,*.zip,*/dist/*
set nofoldenable " disables code folding, because its confusing and I can't find decent docs on it
" virtualedit allows you to move the cursor where there aren't any actual characters, for example after the end of the line
" block means this is only enabled in block edit mode
set virtualedit=block

" configure the status line
set laststatus=2 " always show the status bar

" these manually configure a nice status line. they are not necessary when powerline is installed
"set statusline=   " clear the statusline for when vimrc is reloaded
"set statusline=%f " show filename
"set statusline+=[%{strlen(&fenc)?&fenc:'none'},%{&ff}]  " show encoding
"set statusline+=%h%m%r%y
"set statusline+=%= " right align
"set statusline+=%c,%l/%L@%P\  " show column, line, line-count, and percent from top of file
"set statusline+=%b,0x%-8B\                   " current char

" indentline options
let g:indentLine_color_term = 236
let g:indentLine_char = '𝄄'
" syntastic options
"let g:syntastic_javascript_checkers = ['eslint']
"let g:syntastic_javascript_eslint_exec = 'eslint_d'
let g:syntastic_python_checkers = ['pyflakes']
"let g:syntastic_mode_map = { "mode": "passive" }
let g:jsx_ext_required = 0
let g:syntastic_always_populate_loc_list = 0
let g:syntastic_auto_loc_list = 0
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

" set default SQL dialect to postgres. used with 'exu/pgsql.vim'
let g:sql_type_default = 'pgsql'

" CtrlP options
let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'
let g:ctrlp_working_path_mode = 'ra'
let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files -co --exclude-standard']

" rainbow parentheses always on
au VimEnter * RainbowParenthesesToggle
au Syntax * RainbowParenthesesLoadRound
au Syntax * RainbowParenthesesLoadSquare
au Syntax * RainbowParenthesesLoadBraces

" dont hide double quotes using vim-json
set conceallevel=0
let g:vim_json_syntax_conceal = 0

" vim includes a bunch of keybindings in SQL files that overwrite my own. disable those
let g:omni_sql_no_default_maps = 1

" custom key mappings
" when in insert mode, insert line above
imap <nowait> <C-l> <C-c>O
" insert console.log (alt+c)
imap <nowait> ç console.log()<ESC>i
" wrap in JSON.stringify (alt+j)
imap <nowait> ∆ JSON.stringify(, null, 2)<ESC>2F,i
imap <nowait> ß // eslint-disable-line
imap <nowait> † require('util').inspect(, { depth: 10, color: true<C-c>f}a))<ESC>2F,i
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
" a more convenient quit shorcut. ZZ only writes the file if there are changes
map <leader>q ZZ<CR>
" dedent block and delete line with surrounding brackets
map <leader>x <i{]}dd[{dd
" add comma at the end
map <leader>, A,<ESC>
" reload .vimrc
map <silent> <leader>V :source ~/.vimrc<CR>:filetype detect<CR>:exe ":echo 'vimrc reloaded'"<CR>
map <C-e> :NERDTreeToggle<CR>

" key mappings for primitivorm/vim-swaplines plugin
noremap <silent> <C-k> :SwapUp<CR>
noremap <silent> <C-j> :SwapDown<CR>


" open the vimrc
command Conf :tabe ~/.vimrc
" command Trim :%s/\s\+$//g
command Trim :let _s=@/<Bar>:%s/\s\+$//e<Bar>:let @/=_s
" translate snake case to camel case
command Camel %s/\([a-z0-9]\)_\([a-z0-9]\)/\1\u\2/g

command Day :set background=light
command Night :set background=dark

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

