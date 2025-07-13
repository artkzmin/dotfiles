" Ensure Vim is not in compatibility mode
set nocompatible

" Automatically install vim-plug if not present
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" Initialize plugin system
call plug#begin('~/.vim/plugged')

" Theme
Plug 'morhetz/gruvbox'

" UI enhancements: status line, tabline
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" File explorer
Plug 'preservim/nerdtree'

" Fuzzy finder
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

" Linting and fixing
Plug 'dense-analysis/ale'

" Auto format on save
Plug 'Chiel92/vim-autoformat'

" Git integration
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'

" Rainbow parentheses
Plug 'luochen1990/rainbow'

call plug#end()

" Auto-install missing plugins on startup
augroup plug_auto_install
  autocmd!
  autocmd VimEnter * if len(filter(values(g:plugs), 'empty(glob(v:val.dir))')) > 0 | PlugInstall --sync | source $MYVIMRC | endif
augroup END

" Basic editor settings
syntax on                    " enable syntax highlighting
filetype plugin indent on    " enable filetype detection and indent
set number                   " show absolute line numbers
set relativenumber           " show relative line numbers
set cursorline               " highlight current line

" Tabs and indentation
set tabstop=4                " number of spaces that a <Tab> in the file counts for
set shiftwidth=4             " size of an indent
set expandtab                " use spaces instead of tabs
set autoindent               " copy indent from current line when starting a new line

" File handling improvements
set noswapfile               " disable swap file creation
set nobackup                 " disable backup files
set nowritebackup            " disable write backup files
set undofile                 " enable persistent undo
if has('persistent_undo')
  let target_path = expand('~/.vim/undo')
  if !isdirectory(target_path)
    call mkdir(target_path, 'p')
  endif
  let &undodir = target_path
endif

" Key mappings: save and exit
nnoremap <C-s> :w<CR>
inoremap <C-s> <Esc>:w<CR>a
vnoremap <C-s> <Esc>:w<CR>gv

nnoremap <C-q> :q<CR>
inoremap <C-q> <Esc>:q<CR>

" Enable mouse support in all modes
set mouse=a                  " enable mouse for normal, visual, insert and command-line modes

" Gruvbox configuration
set background=dark          " or light if you prefer
let g:gruvbox_contrast_dark = 'medium'
colorscheme gruvbox

" vim-airline settings
let g:airline#extensions#tabline#enabled = 1
let g:airline_theme='gruvbox'

" NERDTree settings
nnoremap <C-n> :NERDTreeToggle<CR>
let NERDTreeShowHidden=1

" fzf mappings
nnoremap <C-p> :Files<CR>
nnoremap <leader>bg :Buffers<CR>

" ALE settings
let g:ale_linters_explicit = 1
let g:ale_fix_on_save = 1
let g:ale_fixers = { '*': ['remove_trailing_lines', 'trim_whitespace'] }

" Autoformat on save
autocmd BufWritePre * Autoformat

" GitGutter settings
let g:gitgutter_enabled = 1

" Rainbow parentheses
let g:rainbow_active = 1

" Code folding by indent
set foldmethod=indent
set foldlevelstart=99        " open all folds by default

" Plugin installation check
" Use :PlugStatus to see which plugins are installed and their status
" You can map a shortcut for convenience
nnoremap <leader>ps :PlugStatus<CR>

" Optionally, echo a message on startup if all plugins loaded
autocmd VimEnter * echo "Plugins loaded successfully"

" Enhance UI
set showcmd
set showmode
set laststatus=2
set termguicolors            " enable true color
