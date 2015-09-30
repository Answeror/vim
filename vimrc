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

" tmux {{{
if exists('$ITERM_PROFILE')
  if exists('$TMUX') 
    let &t_SI = "\<Esc>[3 q"
    let &t_EI = "\<Esc>[0 q"
  else
    let &t_SI = "\<Esc>]50;CursorShape=1\x7"
    let &t_EI = "\<Esc>]50;CursorShape=0\x7"
  endif
end

" for tmux to automatically set paste and nopaste mode at the time pasting (as
" happens in VIM UI)

function! WrapForTmux(s)
  if !exists('$TMUX')
    return a:s
  endif

  let tmux_start = "\<Esc>Ptmux;"
  let tmux_end = "\<Esc>\\"

  return tmux_start . substitute(a:s, "\<Esc>", "\<Esc>\<Esc>", 'g') . tmux_end
endfunction

let &t_SI .= WrapForTmux("\<Esc>[?2004h")
let &t_EI .= WrapForTmux("\<Esc>[?2004l")

function! XTermPasteBegin()
  set pastetoggle=<Esc>[201~
  set paste
  return ""
endfunction

inoremap <special> <expr> <Esc>[200~ XTermPasteBegin()
" }}}

" indent {{{
set tabstop=4
set shiftwidth=4
set expandtab
set smartindent
" }}}

" allow backspacing over everything in insert mode {{{
" http://stackoverflow.com/a/3534090
set backspace=indent,eol,start
" }}}

"Set to auto read when a file is changed from the outside {{{
if exists("&autoread")
	set autoread
endif
" }}}

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
set showmatch
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

" undo {{{
set undofile
set undodir=$HOME/.vim/.undo
set ul=1024
" }}}

" C++ header guard {{{
function InsertCppHeaderGuard()
py3 << endpy
import vim
from uuid import uuid4

content = '\n'.join(vim.current.buffer[:])
guarded = '''\
#ifdef _MSC_VER
    #pragma once
#endif
#ifndef __{0}__
#define __{0}__

{1}

#endif // __{0}__'''.format(str(uuid4()).upper().replace('-', '_'), content)
vim.current.buffer[:] = guarded.split('\n')
endpy
endfunction
noremap <unique><silent><leader><leader>g :call InsertCppHeaderGuard()<cr>
" }}}

" Set 7 lines to the curors - when moving vertical.. {{{
set so=7
" }}}

" Pretty XML {{{
function! DoPrettyXML()
  " save the filetype so we can restore it later
  let l:origft = &ft
  set ft=
  " delete the xml header if it exists. This will
  " permit us to surround the document with fake tags
  " without creating invalid xml.
  1s/<?xml .*?>//e
  " insert fake tags around the entire document.
  " This will permit us to pretty-format excerpts of
  " XML that may contain multiple top-level elements.
  0put ='<PrettyXML>'
  $put ='</PrettyXML>'
  silent %!xmllint --format -
  " xmllint will insert an <?xml?> header. it's easy enough to delete
  " if you don't want it.
  " delete the fake tags
  2d
  $d
  " restore the 'normal' indentation, which is one extra level
  " too deep due to the extra tags we wrapped around the document.
  silent %<
  " back to home
  1
  " restore the filetype
  exe "set ft=" . l:origft
endfunction
command! PrettyXML call DoPrettyXML()
" }}}

" bufkill bd's: really do not mess with NERDTree buffer {{{
nnoremap <silent> <backspace> :bd<cr>
nnoremap <silent> <s-backspace> :bd!<cr>
" Prevent :bd inside NERDTree buffer
au FileType nerdtree cnoreabbrev <buffer> bd <nop>
au FileType nerdtree cnoreabbrev <buffer> BD <nop>
" }}}

set exrc
set secure

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
let NERDSpaceDelims=1

Plugin 'scrooloose/nerdtree'
map <leader><leader>f :NERDTreeToggle<cr>
map <leader>f :NERDTreeFocus<cr>
let NERDTreeIgnore=['\.pyc$', '\.aux$', '\.nav$', '\.snm$', '\.toc$']

" Plugin 'wincent/Command-T'
" nnoremap <silent><unique>,. :CommandT<cr>
" nnoremap <silent><unique>,, :CommandTBuffer<cr>
" set wildignore+=*.o,*.obj,.git,tmp,temp,cache,exp_*,build*,boost*,pstade*,*.swp,*.un~,*.egg-info,*.pyc,__pycache__
" let g:CommandTMaxFiles=40000

Plugin 'kien/ctrlp.vim'
let g:ctrlp_map = ',.'

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
let g:pymode_lint_ignore = "E731,E501,E116,E131,C901"
" }}}

"" taglist {{{
"Plugin 'kylinwowo/taglist'
"" Taglist plugin mapping
"noremap <silent> <Leader>t :TlistToggle<cr>

"" Taglist plugin config
"let Tlist_Use_Right_Window = 1
"let Tlist_Inc_Winwidth = 0
"let Tlist_WinWidth = 45
"let Tlist_GainFocus_On_ToggleOpen= 1
"let Tlist_Ctags_Cmd = 'ctags'
"let Tlist_Show_One_File = 1
"" }}}

" tagbar {{{
Plugin 'majutsushi/tagbar'
noremap <unique><silent><Leader>t :TagbarToggle<cr>
let g:tagbar_iconchars = ['▸', '▾']
" }}}

Plugin 'bling/vim-airline'
set laststatus=2

Plugin 'auto_mkdir'

" vim-latex {{{
Plugin 'LaTeX-Suite-aka-Vim-LaTeX'
let g:Tex_CompileRule_pdf = 'xelatex -interaction=nonstopmode $*'
let g:Tex_MultipleCompileFormats = 'pdf'

" IMPORTANT: win32 users will need to have 'shellslash' set so that latex
" can be called correctly.
set shellslash

" IMPORTANT: grep will sometimes skip displaying the file name if you
" search in a singe file. This will confuse Latex-Suite. Set your grep
" program to always generate a file-name.
set grepprg=grep\ -nH\ $*

" OPTIONAL: Starting with Vim 7, the filetype of empty .tex files defaults to
" 'plaintex' instead of 'tex', which results in vim-latex not being loaded.
" The following changes the default filetype back to 'tex':
let g:tex_flavor='latex'

" Solve nmap confliction
nmap <c-\> <Plug>IMAP_JumpForward

" Single space after dot
" http://vim.1045645.n5.nabble.com/format-a-paragraph-with-gq-td1189411.html
au Filetype tex setlocal nojs
au Filetype tex setlocal formatoptions+=nmM
" au Filetype tex let &l:flp = '^\s*\\\(end\|item\)\>'
au Filetype tex let &l:flp = '^\s*\\\(item\|end\|begin\)\s*'
" }}}

" Google Protocal Buffer {{{
Plugin 'uarun/vim-protobuf'
au BufRead,BufNewFile *.proto setfiletype proto
" }}}

" Markdown {{{
autocmd Filetype markdown setlocal fo+=mM
" }}}

" Doxygen {{{
Plugin 'DoxygenToolkit.vim'
" }}}

" Split window {{{
Plugin 'tomtom/tinykeymap_vim'
" }}}

call vundle#end()
filetype plugin indent on

colorscheme solarized

Bundle 'Glench/Vim-Jinja2-Syntax'
" }}}
