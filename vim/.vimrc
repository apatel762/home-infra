"        _
" __   _(_)_ __ ___  _ __ ___
" \ \ / / | '_ ` _ \| '__/ __|
"  \ V /| | | | | | | | | (__
"   \_/ |_|_| |_| |_|_|  \___|

" REQUIRED SETUP FOR Vundle
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

    call vundle#end()                 " required
    filetype plugin indent on         " required


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

 "____        _                  _
"/ ___| _ __ (_)_ __  _ __   ___| |_ ___
"\___ \| '_ \| | '_ \| '_ \ / _ \ __/ __|
 "___) | | | | | |_) | |_) |  __/ |_\__ \
"|____/|_| |_|_| .__/| .__/ \___|\__|___/
              "|_|   |_|

" Navigating with guides
    inoremap <Space><Tab> <Esc>/<++><Enter>"_c4l
    vnoremap <Space><Tab> <Esc>/<++><Enter>"_c4l
    map <Space><Tab> <Esc>/<++><Enter>"_c4l

""" PYTHON
    autocmd FileType python inoremap ,fn def<Space><++>(<++>):<Enter><Tab>'''<Enter><++><Enter>'''<Enter><++><Esc>?def<Enter>
    autocmd FileType python inoremap ,ft def<Space>test_<++>(self):<Enter><Tab><++><Enter>self.assert<++>(result, <++>)<Esc>?def<Enter>

    autocmd FileType python inoremap ,cn class<Space><++>:<Enter><Tab>'''<Enter><++><Enter>'''<Enter>def<Space>__init__(self<++>):<Enter><Tab><++><Esc>?class<Enter>
    autocmd FileType python inoremap ,ct class<Space>Test<++>(unittest.TestCase):<Enter><Enter><Tab><++><Esc>?class<Enter>

    autocmd FileType python inoremap ,m if<Space>__name__<Space>==<Space>'__main__':<Enter><Tab>

    autocmd FileType python inoremap ,if if<Space><++>:<Enter><Tab><++><Enter><Backspace>elif<Space><++>:<Enter><Tab><++><Enter><Backspace>else:<Enter><Tab><++><Esc>?if<Enter>n
    autocmd FileType python inoremap ,wh while<Space><++>:<Enter><Tab><++><Esc>?while<Enter>
    autocmd FileType python inoremap ,for for<Space><++><Space>in<Space><++>:<Enter><Tab><++><Esc>?for<Enter>
    autocmd FileType python inoremap ,try try:<Enter><Tab><++><Enter><Backspace>except<Space><++><Space>as<Space><++>:<Enter><Tab><++><Enter><Backspace>else:<Enter><Tab><++><Enter><Backspace>finally:<Enter><Tab><++><Esc>?try<Enter>
    autocmd FileType python inoremap ,wa with<Space><++><Space>as<Space><++>:<Enter><Tab><++><Esc>?with<Enter>

    autocmd FileType python inoremap ,p print(<++>)<Esc>?print<Enter><Esc>/<++><Enter>"_c4l

    autocmd FileType python inoremap ,lc [<++><Space>for<Space><++><Space>in<Space><++><Space>if<Space><++>]<Esc>?[<Enter>
    autocmd FileType python inoremap ,sc {<++><Space>for<Space><++><Space>in<Space><++><Space>if<Space><++>}<Esc>?{<Enter>
    autocmd FileType python inoremap ,dc {<++>:<Space><++><Space>for<Space><++><Space>in<Space><++>}<Esc>?{<Enter>

    autocmd FileType python inoremap ,la lambda<Space><++>:<Space><++><Esc>?lambda<Enter>
