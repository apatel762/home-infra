" ---------------------------------------------------------------------
" PLUGINS
"

" Install vim-plug if not found
" https://github.com/junegunn/vim-plug/wiki/tips#automatic-installation

let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" Run PlugInstall if there are missing plugins
" https://github.com/junegunn/vim-plug/wiki/tips#automatic-installation-of-missing-plugins
autocmd VimEnter * if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
  \| PlugInstall --sync | source $MYVIMRC
\| endif

call plug#begin()

" sensible defaults
Plug 'tpope/vim-sensible'

" git indicator in editor
Plug 'airblade/vim-gitgutter'

" status bar
Plug 'itchyny/lightline.vim'

" telescope file finder / picker
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'

" neovim language things
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'neovim/nvim-lspconfig'

" emacs which-key equivalent
Plug 'folke/which-key.nvim'

" theme
Plug 'folke/tokyonight.nvim', { 'branch': 'main' }

" autocompletion
" https://github.com/ms-jpq/coq_nvim#install
Plug 'ms-jpq/coq_nvim', {'branch': 'coq'}
Plug 'ms-jpq/coq.artifacts', {'branch': 'artifacts'}
Plug 'ms-jpq/coq.thirdparty', {'branch': '3p'}

call plug#end()

" ensure that coq loads on startup
lua << EOF
vim.g.coq_settings = {
  auto_start = true,
}
local coq = require "coq"
EOF

" ensure that we are using the custom theme
lua vim.cmd[[colorscheme tokyonight]]

" ---------------------------------------------------------------------

" line numbers
set number
set relativenumber

" ctrl+p - find files
nnoremap <C-p> <cmd>Telescope find_files<cr>

" indent/unindent with tab/shift-tab
nmap <Tab> >>
imap <S-Tab> <Esc><<i
nmap <S-tab> <<
