syntax enable
set termguicolors
set laststatus=2
set tabstop=8
set softtabstop=2
set shiftwidth=2
set expandtab
set backspace=2
set modeline
let g:is_bash = 1

if has('nvim')
  autocmd vimenter * ++nested colorscheme gruvbox
else
  colorscheme elflord
endif
