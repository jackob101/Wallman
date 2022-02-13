set clipboard=unnamedplus
set number
set termguicolors

let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"


call plug#begin('~/.vim/plugged')

Plug 'morhetz/gruvbox'
Plug 'ap/vim-css-color',
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

call plug#end()

let g:airline_theme='base16_gruvbox_dark_hard'
autocmd vimenter * ++nested colorscheme gruvbox

highlight Normal guibg=NONE
highlight NonText guibg=NONE
highlight SignColumn guibg=NONE