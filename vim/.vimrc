"        _
" __   _(_)_ __ ___  _ __ ___
" \ \ / / | '_ ` _ \| '__/ __|
"  \ V /| | | | | | | | | (__
"   \_/ |_|_| |_| |_|_|  \___|

" REQUIRED SETUP FOR Vundle
"
" For a new PC/Laptop do: (after running `stow vim/` from dotfiles/)
" git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line
"
" Plugin management
    set nocompatible                  " be iMproved, required
    filetype off                      " required

" Set the runtime path to include Vundle and initialize
    set rtp+=~/.vim/bundle/Vundle.vim
    call vundle#begin()

" Let Vundle manage Vundle, required
    Plugin 'VundleVim/Vundle.vim'

" PLUGINS
    Plugin 'w0rp/ale'                 " Asynchronous Linting Engine
    Plugin 'mattn/emmet-vim'          " Emmet-vim
    Plugin 'scrooloose/nerdtree'      " NERDTree
    Plugin 'vim-airline/vim-airline'  " Airline
    Plugin 'airblade/vim-gitgutter'   " Git gutter
    Plugin 'ervandew/supertab'        " SuperTab
    Plugin 'honza/vim-snippets'       " Snippets (mainly used for markdown)
    Plugin 'Shougo/deoplete.nvim'     " Deoplete.nvim

    call vundle#end()                 " required
    filetype plugin indent on         " required

" Activate deoplete by default
    let g:deoplete#enable_at_startup=1
    call deoplete#custom#option('ignore_case', v:true) 

" Line numbers
    set number
    set relativenumber

" Spaces and tabs - indentation without any hard tabs
    set autoindent
    set expandtab
    set shiftwidth=4
    set softtabstop=4

" Various improvements to the UI
    set ruler                      " Show line and col number (bottom right)
    set showcmd                    " Show partial command (bottom right)
    set cursorline                 " Highlight the current line
    
    set wildmode=longest,list,full " AUTOCOMPLETE
    set wildmenu                   " Graphical menu for vim autocomplete

    set lazyredraw                 " Redraw the screen less - faster macros
    set updatetime=100             " Update timer = 100ms (Default: 4000)
    set showmatch                  " Highlight matching [{()}]
    set incsearch                  " Search as characters are entered

" Highlight any characters in column 79 (for keeping lines short)
    highlight ColorColumn ctermbg=magenta
    call matchadd('ColorColumn', '\%79v', 100)

" Splits open at the bottom and right, rather than Vim defaults
    set splitbelow
    set splitright

" Shortcuts for navigating between splits
    map <C-h> <C-w>h
    map <C-j> <C-w>j
    map <C-k> <C-w>k
    map <C-l> <C-w>l

" Syntax highlighting
    syntax on

" Close vim if NERDTree is the last thing open
    autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

    let NERDTreeShowHidden=1                 " Show hidden files - NERDTree
    let g:airline#extensions#ale#enabled = 1 " Integrate the ALE with Airline

" AUTOCOMPLETE
" Press <C-x> then <C-o> to activate
    autocmd FileType html set omnifunc=htmlcomplete#CompleteTags 
    autocmd FileType css set omnifunc=csscomplete#CompleteCSS
    autocmd FileType javascript set omnifunc=javascriptcomplete#CompleteJS

" HOTKEYS
    map <C-n> :NERDTreeToggle<CR>

" Execute the current line of text as a shell command
    noremap Q !!$SHELL<CR>
