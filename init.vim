set runtimepath+=~/.vim,~/.vim/after
set packpath+=~/.vim
source ~/.vimrc
let g:python_host_prog="/Users/ghama/.pyenv/versions/neovim2/bin/python"
let g:python3_host_prog="/Users/ghama/.pyenv/versions/neovim3/bin/python"

set inccommand=nosplit

if has('nvim')
   tnoremap <Esc> <C-\><C-n>
   tnoremap <A-[> <Esc>
   tnoremap <A-h> <C-\><C-n><C-w>h
   tnoremap <A-j> <C-\><C-n><C-w>j
   tnoremap <A-k> <C-\><C-n><C-w>k
   tnoremap <A-l> <C-\><C-n><C-w>l

   nnoremap <A-h> <C-w>h
   nnoremap <A-j> <C-w>j
   nnoremap <A-k> <C-w>k
   nnoremap <A-l> <C-w>l

   tnoremap <expr> <A-r> '<C-\><C-n>"'.nr2char(getchar()).'pi'
endif
