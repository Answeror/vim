" vim:foldmethod=marker

" /tmp issue in fish
" https://github.com/gmarik/Vundle.vim/issues/175
set shell=/bin/bash

" leader
imap jj <esc>
let mapleader=','
let g:mapleader=','
let maplocalleader=','

set nu
nnoremap <silent><unique><leader>e :e $HOME/.vim/vimrc<cr>

" indent
set tabstop=4
set shiftwidth=4
set expandtab
set smartindent

" 80 column layout {{{
if exists('+colorcolumn')
	set colorcolumn=80
else
	au BufWinEnter * let w:m2=matchadd('ErrorMsg', '\%>80v.\+', -1)
endif
" }}}

" search {{{
set ignorecase
set smartcase
set hlsearch
set incsearch
set magic
map <space> /
map <c-space> ?
nnoremap <silent><leader>n :silent :noh<cr>
" }}}

" encoding {{{
set fileencodings=ucs-bom,utf-8,cp936,gb18030,big5,euc-jp,euc-kr,latin1
set fileencoding=utf-8
set ffs=unix,dos,mac
" }}}

" fast saving {{{
nmap <leader>x :xa!<cr>
nmap <leader>w :w!<cr>
nmap <leader>q :q<cr>
" }}}

set showmatch

" undo {{{
set undofile
set undodir=$HOME/.vim/.undo
set ul=1024
" }}}

" vundle {{{
set nocompatible
filetype off
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'Solarized'
syntax on
set t_Co=16
set background=dark
let g:solarized_base16=1

Plugin 'surround.vim'
Plugin 'oblitum/bufkill'
Plugin 'scrooloose/nerdcommenter'

Plugin 'scrooloose/nerdtree'
map <leader><leader>f :NERDTreeToggle<cr>
map <leader>f :NERDTreeFocus<cr>

Plugin 'wincent/Command-T'
nnoremap <silent><unique>,. :CommandT<cr>
nnoremap <silent><unique>,, :CommandTBuffer<cr>

function! WinMove(key)                                                                                         
    let t:curwin = winnr()                                                  
    exec "wincmd ".a:key                                                    
    if (t:curwin == winnr())
        if (match(a:key,'[jk]'))
            wincmd v                                                        
        else                                                                
            wincmd s                                                        
        endif                                                               
        exec "wincmd ".a:key                                                
    endif                                                                   
endfunction                                                                 
                                                                            
nnoremap <unique> <c-h> :call WinMove('h')<cr>                              
nnoremap <unique> <c-k> :call WinMove('k')<cr>                              
nnoremap <unique> <c-l> :call WinMove('l')<cr>                              
nnoremap <unique> <c-j> :call WinMove('j')<cr>                              
                                                                            
nnoremap <unique> <leader>wc :wincmd q<cr>                                  
nnoremap <unique> <leader>wr <C-W>r                                         
                                                                            
nnoremap <unique> <leader>h :wincmd H<cr>                                   
nnoremap <unique> <leader>k :wincmd K<cr>                                   
nnoremap <unique> <leader>l :wincmd L<cr>                                   
nnoremap <unique> <leader>j :wincmd J<cr>

" python mode {{{
Plugin 'klen/python-mode'
let g:pymode_rope = 0
let g:pymode_python = 'python3'
let g:pymode_lint_ignore = "E501,C901"
" }}}

Plugin 'bling/vim-airline'
set laststatus=2

Plugin 'auto_mkdir'

call vundle#end()
filetype plugin indent on

colorscheme solarized
" }}}
