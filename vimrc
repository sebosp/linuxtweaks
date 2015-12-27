"let g:tex_flavor = "latex"
"set runtimepath=~/.vim,$VIM/vimfiles,$VIMRUNTIME,$VIM/vimfiles/after,~/.vim/after
set t_Co=256
set background=dark
color PaperColor
syn on
set hlsearch
set incsearch
set number
filetype indent plugin on

set statusline=%f:%4l/%-4L\ -\ [Col:\ %3v]\ -\ %y\ %#warningmsg#%{SyntasticStatuslineFlag()}%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
set lcs=tab:>-,eol:$
set noerrorbells visualbell t_vb=
set list
autocmd FileType * set ts=8
autocmd FileType puppet set ts=2 sw=2 et
highlight currentWordHi term=bold ctermbg=236 guibg=green
au CursorHold * exe 'match currentWordHi /\V\<'.substitute(escape(expand('<cword>'),'\'),"/","\\\\/","g").'\>/'
au CursorHoldI * exe 'match currentWordHi /\V\<'.substitute(escape(expand('<cword>'),'\'),"/","\\\\/","g").'\>/'
setl updatetime=200
highlight rightMargin ctermbg=235
2match rightMargin /.\%>80v/    
set viminfo='10,\"100,:20,%,n~/.viminfo
