"        _
" __   _(_)_ __ ___  _ __ ___
" \ \ / / | '_ ` _ \| '__/ __|
"  \ V /| | | | | | | | | (__
"   \_/ |_|_| |_| |_|_|  \___|

" Plugin management
    execute pathogen#infect()

" Line numbers
    set number
    set relativenumber

" Spaces and tabs - indentation without any hard tabs
    set autoindent
    set expandtab
    set shiftwidth=4
    set softtabstop=4

    set ruler          " Show current cursor position in lower right
    set showcmd        " Show incomplete vim commands in lower right
    set cursorline     " Highlight the current line
    set wildmenu       " Graphical menu for vim autocomplete
    set lazyredraw     " Redraw the screen less - leads to faster macros
    set updatetime=100 " Set vim's update timer to 100ms (Default: 4000)
    set showmatch      " Highlight matching [{()}]
    set incsearch      " Search as characters are entered

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
