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

function! Smart_TabComplete()
  let line = getline('.')                         " current line

  let substr = strpart(line, -1, col('.'))        " from the start of the current
                                                  " line to one character right
                                                  " of the cursor
  let substr = matchstr(substr, "[^ \t]*$")       " word till cursor
  if (strlen(substr)==0)                          " nothing to match on empty string
    return "\<tab>"
  endif
  let has_period = match(substr, '\.') != -1      " position of period, if any
  let has_slash = match(substr, '\/') != -1       " position of slash, if any
  if (!has_period && !has_slash)
    return "\<tab>"
    "return "\<C-X>\<C-P>"                        " existing text matching
  elseif ( has_slash )
    return "\<C-X>\<C-F>"                         " file matching
  else
    return "\<tab>"
    "return "\<C-X>\<C-O>"                        " plugin matching
  endif
endfunction

inoremap <tab> <c-r>=Smart_TabComplete()<CR>
