function! ResCur()
  if line("'\"") <= line("$")
    normal! g`"
    return 1
  endif
endfunction
function! TestStatus()
  if &filetype != "rust"
    return ""
  elseif g:TestStatus == -1
    return "[Test: N/A]"
  elseif g:TestStatus == 0
    return "[Test: OK.]"
  else
    return "[Test: ERR]"
  endif
endfunction

" run :GoBuild or :GoTestCompile based on the go file
function! s:build_go_files()
  let l:file = expand('%')
  if l:file =~# '^\f\+_test\.go$'
    call go#test#Test(0, 1)
  elseif l:file =~# '^\f\+\.go$'
    call go#cmd#Build(0)
  endif
endfunction

function! BgCmdCB(channel,msg)
  call writefile([a:msg], g:bgCmdOutput,'a')
endfunction
function! BgCmdExit(job,status)
  let l:bufno = bufwinnr("__Bg_Res__")
  echo 'Running' g:bgCmd 'in background... Done.'
  let g:TestStatus=a:status
  " Change status line to show errors
  if a:status > 0
    hi statusline guibg=DarkRed ctermfg=1 guifg=Black ctermbg=0
    if l:bufno == -1
      below 8split __Bg_Res__
      let l:bufno = bufwinnr("__Bg_Res__")
    else
      execute bufno . "wincmd w"
    endif
    normal! ggdG
    setlocal buftype=nofile
    call append(0,readfile(g:bgCmdOutput))
    normal! gg
    execute "-1 wincmd w"
  else
    " Restore status line
    hi statusline term=bold,reverse cterm=bold ctermfg=233 ctermbg=66 gui=bold guifg=#1c1c1c guibg=#5f8787
    " Close tests result window
    if l:bufno != -1
      execute bufno . "wincmd w"
      close
    endif
  endif
  unlet g:bgCmdOutput
endfunction

function! RunBgCmd(command)
  let g:bgCmd = a:command
  if exists('g:bgCmdOutput')
    echo 'Task' g:bgCmd 'running in background'
  else
    echo 'Running' g:bgCmd 'in background'
    let g:bgCmdOutput = tempname()
    call job_start(a:command,{
      \'err_io':'buffer',
      \'out_io': 'buffer',
      \'callback': 'BgCmdCB',
      \'exit_cb':'BgCmdExit'})
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
au BufNewFile,BufRead *.rs set filetype=rust
set statusline=%f:                "Current file
set statusline+=%4l/%-4L          "Current line / Total lines
set statusline+=\ -\ [Col:\ %3v]  "Current column
set statusline+=\ -\ %y\          "Current filetype
set statusline+=%{TestStatus()}   "Test Results
set statusline+=%#warningmsg#     "Warning message
set statusline+=%{SyntasticStatuslineFlag()}%*

let g:TestStatus=-1
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
au BufRead,BufNewFile *.tf setlocal filetype=terraform
au BufRead,BufNewFile *.tfvars setlocal filetype=terraform
au BufRead,BufNewFile *.tfstate setlocal filetype=javascript
setl updatetime=200
highlight rightMargin ctermbg=233
2match rightMargin /.\%>80v/    
au BufNewFile,BufRead *.yml set filetype=ansible
autocmd FileType ansible setlocal ts=2 sts=2 sw=2 expandtab indentkeys=!^Fo,O,0#,<:>,=-
autocmd FileType ansible setlocal indentkeys-=<:>
set viminfo='10,\"100,:20,%,n~/.viminfo
set autowrite
map <C-n> :cnext<CR>
map <C-m> :cprevious<CR>
nnoremap <leader>a :cclose<CR>
let g:go_fmt_command = "goimports"
let g:rustfmt_autosave = 1
let g:go_metalinter_autosave = 1
autocmd FileType go nmap <leader>r <Plug>(go-run)
autocmd FileType go nmap <leader>t <Plug>(go-test)
command! -nargs=+ -complete=shellcmd RunBg call RunBgCmd(<q-args>)

autocmd FileType go nmap <leader>b :<C-u>call <SID>build_go_files()<CR>
autocmd FileType go nmap <Leader>c <Plug>(go-coverage-toggle)
autocmd Filetype go command! -bang A call go#alternate#Switch(<bang>0, 'edit')
autocmd Filetype go command! -bang AV call go#alternate#Switch(<bang>0, 'vsplit')
autocmd Filetype go command! -bang AS call go#alternate#Switch(<bang>0, 'split')
autocmd Filetype go command! -bang AT call go#alternate#Switch(<bang>0, 'tabe')
autocmd FileType rust compiler cargo
autocmd FileType rust nmap <leader>r :!cargo run 2>&1<CR>
autocmd FileType rust nmap <leader>tc :RunBg cargo test<CR>
autocmd FileType rust nmap <leader>tc :RunBg cargo test<CR>
autocmd FileType rust nmap <leader>tC :RunBg cargo test -- --nocapture<CR>
autocmd FileType rust nmap <leader>b :!cargo build<CR>
autocmd FileType rust set shiftwidth=4
autocmd FileType rust let g:syntastic_rust_checkers = ['cargo']
