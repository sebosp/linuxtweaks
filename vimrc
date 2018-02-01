function! ResCur()
  if line("'\"") <= line("$")
    normal! g`"
    return 1
  endif
endfunction

augroup resCur
  autocmd!
  autocmd BufWinEnter * call ResCur()
augroup END
let mapleader = ","
syn on se title
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
highlight rightMargin ctermbg=233
2match rightMargin /.\%>80v/    
set viminfo='10,\"100,:20,%,n~/.viminfo
set autowrite
map <C-n> :cnext<CR>
map <C-m> :cprevious<CR>
nnoremap <leader>a :cclose<CR>
let g:go_fmt_command = "goimports"
let g:go_metalinter_autosave = 1
autocmd FileType go nmap <leader>r  <Plug>(go-run)
autocmd FileType go nmap <leader>t  <Plug>(go-test)
" run :GoBuild or :GoTestCompile based on the go file
function! s:build_go_files()
  let l:file = expand('%')
  if l:file =~# '^\f\+_test\.go$'
    call go#test#Test(0, 1)
  elseif l:file =~# '^\f\+\.go$'
    call go#cmd#Build(0)
  endif
endfunction

autocmd FileType go nmap <leader>b :<C-u>call <SID>build_go_files()<CR>
autocmd FileType go nmap <Leader>c <Plug>(go-coverage-toggle)
autocmd Filetype go command! -bang A call go#alternate#Switch(<bang>0, 'edit')
autocmd Filetype go command! -bang AV call go#alternate#Switch(<bang>0, 'vsplit')
autocmd Filetype go command! -bang AS call go#alternate#Switch(<bang>0, 'split')
autocmd Filetype go command! -bang AT call go#alternate#Switch(<bang>0, 'tabe')
