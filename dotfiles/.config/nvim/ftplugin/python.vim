set foldmethod=indent
set foldnestmax=2

function MyCustomHighlights()
    hi semshiLocal           guifg=#ff875f
    hi semshiGlobal          guifg=#dcddde
    hi semshiImported        guifg=#dcddde gui=bold
    hi semshiParameter       guifg=#73D0FF
    hi semshiParameterUnused guifg=#73D0FF gui=underline
    hi semshiFree            guifg=#ffafd7
    hi semshiBuiltin         guifg=#5CCFE6
    hi semshiAttribute       guifg=#BAE67E
    hi semshiSelf            guifg=#73D0FF gui=italic
    hi semshiUnresolved      guifg=#ffff00 gui=underline
    hi semshiSelected        guifg=#ffffff guibg=#33415e
endfunction
autocmd FileType python call MyCustomHighlights()

nmap <silent> <leader>af :Isort<CR> :Black<CR>
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gr <Plug>(coc-references)

" select suggestion by Enter
inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm() : "\<C-g>u\<CR>"

" navigate suggestions
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
