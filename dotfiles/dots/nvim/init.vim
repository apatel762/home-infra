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
lua << EOF
vim.cmd[[colorscheme tokyonight]]
EOF

"  https://github.com/folke/which-key.nvim#%EF%B8%8F-mappings
lua << EOF
require("which-key").setup {
	-- your configuration comes here
	-- or leave it empty to use the default settings
	-- refer to the configuration section below
}

require("which-key").register({
	["<leader>"] = {
		f = {
			name = "+file",
			f = { "<cmd>Telescope find_files<cr>", "Find File" },
			r = { "<cmd>Telescope oldfiles<cr>", "Open Recent File" },
			n = { "<cmd>enew<cr>", "New File" },
		},
	},
}
)
EOF

" ---------------------------------------------------------------------

" line numbers
set number
set relativenumber

" ctrl+p - find files, ctrl+g - find tracked files
nnoremap <C-p> <cmd>Telescope find_files<cr>
nnoremap <C-g> <cmd>Telescope git_files<cr>

" indent/unindent with tab/shift-tab
nmap <Tab> >>
imap <S-Tab> <Esc><<i
nmap <S-tab> <<

" hightlight on yank
" from https://neovim.io/news/2021/07
au TextYankPost * lua vim.highlight.on_yank {higroup="IncSearch", timeout=150, on_visual=true}

" copy and paste helpers
vmap <C-c> "+y
vmap <C-x> "+c
vmap <C-v> c<ESC>"+p

" move through buffers
nmap <leader>[ :bp!<CR>
nmap <leader>] :bn!<CR>
nmap <leader>x :bd<CR>
