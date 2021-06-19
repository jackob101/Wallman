call plug#begin('~/.vim/plugged')



Plug 'https://github.com/vim-airline/vim-airline'
Plug 'https://github.com/vimwiki/vimwiki'
Plug 'https://github.com/morhetz/gruvbox'
Plug 'https://github.com/norcalli/nvim-colorizer.lua'

call plug#end()

set termguicolors
lua require'colorizer'.setup()


let g:gruvbox_contrast_dark='soft'
let g:gruvbox_transparent_bg=1


colorscheme gruvbox
set number
set nocompatible
filetype plugin on

syntax on

hi! Normal ctermbg=NONE guibg=NONE
hi! NonText ctermbg=NONE guibg=NONE


