" Plugins

call plug#begin()
    " Start page
    Plug 'mhinz/vim-startify'
    " Theme
    Plug 'Luxed/ayu-vim'
    " File tree
    Plug 'scrooloose/nerdtree'
    " Status abr
    Plug 'itchyny/lightline.vim'
    " Code comments
    Plug 'scrooloose/nerdcommenter'
    " Vertical lines at each indentation level
    Plug 'Yggdroot/indentLine'
    " Autopairing for everything: brackets, parens, quotes
    Plug 'Raimondi/delimitMate'
    " Highlights trailing whitespace
    Plug 'ntpeters/vim-better-whitespace'
    " Git integration
    Plug 'tpope/vim-fugitive'
    " Multicursor
    Plug 'mg979/vim-visual-multi', {'branch': 'master'}
    " Maps russian layout to correct keys to avoid switching
    Plug 'powerman/vim-plugin-ruscmd'
    " Code suggestions/completion
    Plug 'neoclide/coc.nvim', {'branch': 'release'}
    " Python `black` integration
    Plug 'psf/black', { 'branch': 'master' }
    " Python `isort` integration
    Plug 'fisadev/vim-isort'
call plug#end()

" Defaults

set shiftwidth=4
set tabstop=4
set autoindent
set smartindent
set mouse=a
set number
set expandtab
set clipboard+=unnamedplus
set colorcolumn=120

" Theme

set termguicolors
set background=dark
let g:ayucolor="mirage"

function! s:custom_ayu_colors()
  call ayu#hi('LineNr', 'fg', '')
endfunction

augroup custom_colors
  autocmd!
  autocmd ColorScheme ayu call s:custom_ayu_colors()
augroup END

let g:ayu_sign_contrast = 1
let g:ayu_italic_comment = 1

colorscheme ayu

" Conf

" NERDCommenter
let g:NERDSpaceDelims = 1
let g:NERDTrimTrailingWhitespace = 1
let g:NERDCompactSexyComs = 1
let g:NERDDefaultAlign = 'left'
" :cmt should be mapped to Cmd+/ in Iterm2
nmap :cmt <Plug>NERDCommenterToggle
vmap :cmt <Plug>NERDCommenterToggle
imap :cmt <Esc><Plug>NERDCommenterToggle i

" indentline
let g:indentLine_char = '┊'
let g:indentLine_setColors = 0

" tagbar
nmap <F8> :TagbarToggle<CR>

" lightline
let g:lightline = {'colorscheme': 'ayu_mirage'}

if has("patch-8.1.1564")
  " Recently vim can merge signcolumn and number column into one
  set signcolumn=number
else
  set signcolumn=yes
endif

" navigation
set number relativenumber
nnoremap <S-Up> :m-2<CR>
nnoremap <S-Down> :m+<CR>
inoremap <S-Up> <Esc>:m-2<CR>
inoremap <S-Down> <Esc>:m+<CR>
nmap <silent> gb <C-o>
nnoremap <C-t> :tabnew<CR>
nnoremap <C-Left> :tabprevious<CR>
nnoremap <C-Right> :tabnext<CR>
inoremap <C-Left> <Esc>:tabprevious<CR>
inoremap <C-Right> <Esc>:tabnext<CR>

" nerdtree
nmap <silent> <expr> <leader>t &filetype ==# 'nerdtree' ? ':NERDTreeToggle<CR>' : ':NERDTreeFocus<CR>'
nmap <silent> <leader>f :NERDTreeFind<CR>
let NERDTreeMinimalUI = 1
let NERDTreeDirArrows = 1

" saving
map <silent> <leader>q <C-c>:q<CR>
map <silent> <leader>w <C-c>:w<CR>
map <silent> <leader>wq <C-c>:wq<CR>

" git
map <silent> <leader>gc <C-c>:w<CR>:G commit %<CR>
map <silent> <leader>gd <C-c>:Gdiff<CR>
map <silent> <leader>gp <C-c>:G push<CR>

" utils
nnoremap <space> za
vnoremap <space> zf
vnoremap <leader>s :sort<CR>
