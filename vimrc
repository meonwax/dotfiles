set nocompatible          " Get rid of Vi compatibility mode. SET FIRST!
syntax on                 " Enable syntax highlighting
set background=dark       " Optimize theme colors for dark background
set t_Co=256              " Enable 256-color mode
set expandtab             " Insert spaces when tab key is pressed
set tabstop=2             " Number of spaces for tab
set shiftwidth=2          " Automatically indent next lines
map Q <Nop>               " Disable the Ex mode key

" Gruvbox color theme
"if has('termguicolors')
"  set termguicolors
"endif
autocmd VimEnter * hi Normal ctermbg=none
colorscheme gruvbox
