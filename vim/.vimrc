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

" Various improvements to the UI
    set ruler                      " Show current cursor position in lower right
    set showcmd                    " Show incomplete vim commands in lower right
    set cursorline                 " Highlight the current line
    
    set wildmode=longest,list,full " AUTOCOMPLETE
    set wildmenu                   " Graphical menu for vim autocomplete

    set lazyredraw                 " Redraw the screen less - leads to faster macros
    set updatetime=100             " Set vim's update timer to 100ms (Default: 4000)
    set showmatch                  " Highlight matching [{()}]
    set incsearch                  " Search as characters are entered

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
    autocmd FileType python inoremap ,for for<Space><++><Space>in<Space><++>:<Enter><Tab><++><Esc>?for<Enter>
    autocmd FileType python inoremap ,try try:<Enter><Tab><++><Enter><Backspace>except<Space><++><Space>as<Space><++>:<Enter><Tab><++><Enter><Backspace>else:<Enter><Tab><++><Enter><Backspace>finally:<Enter><Tab><++><Esc>?try<Enter>
    autocmd FileType python inoremap ,wa with<Space><++><Space>as<Space><++>:<Enter><Tab><++><Esc>?with<Enter>
    autocmd FileType python inoremap ,p print(<++>)<Esc>?print<Enter><Space><Tab>
