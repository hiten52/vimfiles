" Cross-platform Vim configuration

set nocompatible

" Detect operating system
if has('win32') || has('win64')
  let $VIMHOME = $HOME . '/vimfiles'
else
  let $VIMHOME = $HOME . '/.vim'
endif

" Automatic Vim-Plug installation
if empty(glob($VIMHOME . '/autoload/plug.vim'))
  if has('win32') || has('win64')
    " Windows-specific download using PowerShell
    silent! execute '!powershell -Command "New-Item -Path "' . $VIMHOME . '/autoload" -ItemType Directory -Force"'
    silent! execute '!powershell -Command "Invoke-WebRequest -Uri https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim -OutFile "' . $VIMHOME . '/autoload/plug.vim"'
  else
    " Unix-style installation
    silent !mkdir -p ~/.vim/autoload
    silent !curl -sfLo ~/.vim/autoload/plug.vim --create-dirs
          \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  endif
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" Function to run PlugClean only when installing new plugins
function! RunPlugCleanIfNeeded()
  " Check if there are uninstalled plugins
  let s:uninstalled_plugins = len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))

  if s:uninstalled_plugins > 0
    PlugClean!
  endif
endfunction

" Run PlugClean before installing if needed
autocmd VimEnter * call RunPlugCleanIfNeeded()

" Basic settings
set relativenumber
set number
filetype plugin indent on

" Airline customization
let g:airline_section_c = '%f'
let g:airline_section_y = '%p%%'
let g:airline_section_z = '%l:%L'

" Plugin management
call plug#begin($VIMHOME . '/plugged')
  Plug 'preservim/nerdtree'
  Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
  Plug 'junegunn/fzf.vim'
  Plug 'vim-airline/vim-airline'
call plug#end()

" NERDTree shortcut
map <C-n> :NERDTreeToggle<CR>

" Fuzzy find shortcuts
" Ctrl-P for files
nnoremap <C-p> :Files<CR>
" Ctrl-F for text search within files
nnoremap <C-f> :Rg<CR>
" Ctrl-B for open buffers
nnoremap <C-b> :Buffers<CR>
