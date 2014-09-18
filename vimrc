set tabstop=4
set shiftwidth=4
set smartindent
imap jj <esc>
let mapleader=','
let g:mapleader=','
let maplocalleader=','

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

call vundle#end()
filetype plugin indent on

colorscheme solarized
