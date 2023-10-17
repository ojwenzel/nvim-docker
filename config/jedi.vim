" key bindings
nmap <silent> ga <Plug>(coc-codeaction-line)
xmap <silent> ga <Plug>(coc-codeaction-selected)
nmap <silent> gA <Plug>(coc-codeaction)

" open the go-to function in split, not another buffer
let g:jedi#show_call_signatures = "1"
let g:jedi#popup_on_dot = 0
" let g:jedi#use_splits_not_buffers = "right"
let g:jedi#server_command = ['/path/to/virtualenv/bin/python3', '-m', 'jedi', '--log-to-stderr']
autocmd FileType python setlocal omnifunc=jedi#completions()
