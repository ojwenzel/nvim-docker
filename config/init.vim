" nvim python
" let g:python3_host_prog = '/Users/ojwenzel/.pyenv/versions/neovim3/bin/python'
" let g:python_host_prog = '/Users/ojwenzel/.pyenv/versions/neovim2/bin/python'

call plug#begin()
" The default plugin directory will be as follows:
"   - Vim (Linux/macOS): '~/.vim/plugged'
"   - Neovim (Linux/macOS/Windows): stdpath('data') . '/plugged'
" You can specify a custom plugin directory by passing it as the argument
"   - e.g. `call plug#begin('~/.vim/plugged')`
"   - Avoid using standard Vim directory names like 'plugin'

" Make sure you use single quotes

" CoC
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" Plug 'pappasam/coc-jedi', { 'do': 'yarn install --frozen-lockfile && yarn build', 'branch': 'main' }
" jedi-vim, for autocompletion
Plug 'davidhalter/jedi-vim'

" autocompletion with tab
Plug 'ervandew/supertab'

" Plugin outside ~/.vim/plugged with post-update hook
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
" Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }

" file managing and exploration
Plug 'scrooloose/nerdtree'

" a useful status bar
Plug 'vim-airline/vim-airline'

" automatic quote and bracket completion
Plug 'jiangmiao/auto-pairs'

" python docstrings
Plug 'pixelneo/vim-python-docstring'

" black for formatting
Plug 'psf/black', { 'branch': 'main' }

" for linting in neovim
Plug 'dense-analysis/ale'

"isort for import sorting
Plug 'fisadev/vim-isort'

" seemless ctrl-[hjkl] navigation in tmux and nvim
Plug 'christoomey/vim-tmux-navigator'

" Initialize plugin system
" - Automatically executes `filetype plugin indent on` and `syntax enable`.
call plug#end()

" fzf settings
source /root/.config/nvim/fzf.vim

" key bindings for jedi-vim
nmap <silent> ga <Plug>(coc-codeaction-line)
xmap <silent> ga <Plug>(coc-codeaction-selected)
nmap <silent> gA <Plug>(coc-codeaction)

" open the go-to function in split, not another buffer
let g:jedi#show_call_signatures = "1"
let g:jedi#popup_on_dot = 0
" let g:jedi#use_splits_not_buffers = "right"

" set docstring style
let g:python_style = 'numpy'

" default settings to sort imports
source /root/.config/nvim/isort.vim

set number " show line number
set ru " Ruler active
:set colorcolumn=79

set runtimepath^=/.vim runtimepath+=~/.vim/after

let &packpath = &runtimepath
