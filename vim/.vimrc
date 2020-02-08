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
    Plugin 'vim-airline/vim-airline'  " Airline
    Plugin 'airblade/vim-gitgutter'   " Git gutter
    Plugin 'ervandew/supertab'        " SuperTab
    Plugin 'SirVer/ultisnips'         " Snippets Engine
    Plugin 'honza/vim-snippets'       " The actual snippets
    Plugin 'Shougo/deoplete.nvim'     " Deoplete.nvim

    call vundle#end()                 " required
    filetype plugin indent on         " required

" Activate deoplete by default
    let g:deoplete#enable_at_startup=1
    call deoplete#custom#option('ignore_case', v:true) 

" Trigger configuration. Do not use <tab> if you use https://github.com/Valloric/YouCompleteMe.
    let g:UltiSnipsJumpForwardTrigger="<c-b>"
    let g:UltiSnipsJumpBackwardTrigger="<c-z>"

" If you want :UltiSnipsEdit to split your window.
    let g:UltiSnipsEditSplit="vertical"


" Highlight any characters in column 79 (for keeping lines short)
"    highlight ColorColumn ctermbg=magenta
"    call matchadd('ColorColumn', '\%79v', 100)

" Splits open at the bottom and right, rather than Vim defaults
    set splitbelow
    set splitright

" Syntax highlighting
    syntax on

" Integrate the ALE with Airline
    let g:airline#extensions#ale#enabled = 1

" AUTOCOMPLETE
" Press <C-x> then <C-o> to activate
    autocmd FileType html set omnifunc=htmlcomplete#CompleteTags 
    autocmd FileType css set omnifunc=csscomplete#CompleteCSS
    autocmd FileType javascript set omnifunc=javascriptcomplete#CompleteJS

" Execute the current line of text as a shell command
    noremap Q !!$SHELL<CR>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" STOLEN FROM https://github.com/amix/vimrc/blob/master/vimrcs/basic.vim
" => General
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Sets how many lines of history VIM has to remember
    set history=500

" Enable filetype plugins
    filetype plugin on
    filetype indent on

" Set to auto read when a file is changed from the outside
    set autoread
    au FocusGained,BufEnter * checktime

" With a map leader it's possible to do extra key combinations
" like <leader>w saves the current file
    let mapleader = ","

" Fast saving
    nmap <leader>w :w!<cr>

" :W sudo saves the file 
" (useful for handling the permission-denied error)
    command! W execute 'w !sudo tee % > /dev/null' <bar> edit!

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" STOLEN FROM https://github.com/amix/vimrc/blob/master/vimrcs/basic.vim
" => VIM user interface
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Line numbers
    set number
    set relativenumber

" Various improvements to the UI (not stolen from amix/vimrc, but I moved it
" here so it can be with the other stuff)
    set ruler                      " Show line and col number (bottom right)
    set showcmd                    " Show partial command (bottom right)
    set cursorline                 " Highlight the current line
    
    set wildmode=longest,list,full " AUTOCOMPLETE
    set wildmenu                   " Graphical menu for vim autocomplete

    set lazyredraw                 " Redraw the screen less - faster macros
    set updatetime=100             " Update timer = 100ms (Default: 4000)
    set showmatch                  " Highlight matching [{()}]
    set incsearch                  " Search as characters are entered

" Set 7 lines to the cursor - when moving vertically using j/k
    set so=7

" Avoid garbled characters in Chinese language windows OS
    let $LANG='en' 
    set langmenu=en
    source $VIMRUNTIME/delmenu.vim
    source $VIMRUNTIME/menu.vim

" Ignore compiled files
    set wildignore=*.o,*~,*.pyc
    if has("win16") || has("win32")
        set wildignore+=.git\*,.hg\*,.svn\*
    else
        set wildignore+=*/.git/*,*/.hg/*,*/.svn/*,*/.DS_Store
    endif

" Height of the command bar
    set cmdheight=1

" A buffer becomes hidden when it is abandoned
    set hid

" Configure backspace so it acts as it should act
    set backspace=eol,start,indent
    set whichwrap+=<,>,h,l

" Ignore case when searching
    set ignorecase

" When searching try to be smart about cases 
    set smartcase

" For regular expressions turn magic on
    set magic

" How many tenths of a second to blink when matching brackets
    set mat=2

" No annoying sound on errors
    set noerrorbells
    set novisualbell
    set t_vb=
    set tm=500

" Properly disable sound on errors on MacVim
    if has("gui_macvim")
        autocmd GUIEnter * set vb t_vb=
    endif

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" STOLEN FROM https://github.com/amix/vimrc/blob/master/vimrcs/basic.vim
" => Colors and fonts
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Set utf8 as standard encoding and en_US as the standard language
    set encoding=utf8

" Use Unix as the standard file type
    set ffs=unix,dos,mac

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" STOLEN FROM https://github.com/amix/vimrc/blob/master/vimrcs/basic.vim
" => Text, tab and indent related
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Use spaces instead of tabs
    set expandtab

" Be smart when using tabs ;)
    set smarttab

" 1 tab == 4 spaces
    set shiftwidth=4
    set tabstop=4

" Linebreak on 500 characters
    set lbr
    set tw=500

" Auto indent
    set autoindent

" Smart indent
    set smartindent

" Wrap lines
    set wrap

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" STOLEN FROM https://github.com/amix/vimrc/blob/master/vimrcs/basic.vim
" => Visual mode related
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Visual mode pressing * or # searches for the current selection
" Super useful! From an idea by Michael Naumann
    vnoremap <silent> * :<C-u>call VisualSelection('', '')<CR>/<C-R>=@/<CR><CR>
    vnoremap <silent> # :<C-u>call VisualSelection('', '')<CR>?<C-R>=@/<CR><CR>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""" => Moving around, tabs, windows and buffers
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""" Map <Space> to / (search) and Ctrl-<Space> to ? (backwards search)
""map <space> /
""map <C-space> ?
""
""" Disable highlight when <leader><cr> is pressed
""map <silent> <leader><cr> :noh<cr>
""
""" Smart way to move between windows
""map <C-j> <C-W>j
""map <C-k> <C-W>k
""map <C-h> <C-W>h
""map <C-l> <C-W>l
""
""" Close the current buffer
""map <leader>bd :Bclose<cr>:tabclose<cr>gT
""
""" Close all the buffers
""map <leader>ba :bufdo bd<cr>
""
""map <leader>l :bnext<cr>
""map <leader>h :bprevious<cr>
""
""" Useful mappings for managing tabs
""map <leader>tn :tabnew<cr>
""map <leader>to :tabonly<cr>
""map <leader>tc :tabclose<cr>
""map <leader>tm :tabmove 
""map <leader>t<leader> :tabnext 
""
""" Let 'tl' toggle between this and the last accessed tab
""let g:lasttab = 1
""nmap <Leader>tl :exe "tabn ".g:lasttab<CR>
""au TabLeave * let g:lasttab = tabpagenr()
""
""
""" Opens a new tab with the current buffer's path
""" Super useful when editing files in the same directory
""map <leader>te :tabedit <C-r>=expand("%:p:h")<cr>/
""
""" Switch CWD to the directory of the open buffer
""map <leader>cd :cd %:p:h<cr>:pwd<cr>
""
""" Specify the behavior when switching between buffers 
""try
""  set switchbuf=useopen,usetab,newtab
""  set stal=2
""catch
""endtry
""
""" Return to last edit position when opening files (You want this!)
""au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
""
""
""""""""""""""""""""""""""""""""
""" => Status line
""""""""""""""""""""""""""""""""
""" Always show the status line
""set laststatus=2
""
""" Format the status line
""set statusline=\ %{HasPaste()}%F%m%r%h\ %w\ \ CWD:\ %r%{getcwd()}%h\ \ \ Line:\ %l\ \ Column:\ %c
""
""
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""" => Editing mappings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""" Remap VIM 0 to first non-blank character
""map 0 ^
""
""" Move a line of text using ALT+[jk] or Command+[jk] on mac
""nmap <M-j> mz:m+<cr>`z
""nmap <M-k> mz:m-2<cr>`z
""vmap <M-j> :m'>+<cr>`<my`>mzgv`yo`z
""vmap <M-k> :m'<-2<cr>`>my`<mzgv`yo`z
""
""if has("mac") || has("macunix")
""  nmap <D-j> <M-j>
""  nmap <D-k> <M-k>
""  vmap <D-j> <M-j>
""  vmap <D-k> <M-k>
""endif
""
""" Delete trailing white space on save, useful for some filetypes ;)
""fun! CleanExtraSpaces()
""    let save_cursor = getpos(".")
""    let old_query = getreg('/')
""    silent! %s/\s\+$//e
""    call setpos('.', save_cursor)
""    call setreg('/', old_query)
""endfun
""
""if has("autocmd")
""    autocmd BufWritePre *.txt,*.js,*.py,*.wiki,*.sh,*.coffee :call CleanExtraSpaces()
""endif
""
""
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""" => Spell checking
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""" Pressing ,ss will toggle and untoggle spell checking
""map <leader>ss :setlocal spell!<cr>
""
""" Shortcuts using <leader>
""map <leader>sn ]s
""map <leader>sp [s
""map <leader>sa zg
""map <leader>s? z=
""
""
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""" => Misc
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""" Remove the Windows ^M - when the encodings gets messed up
""noremap <Leader>m mmHmt:%s/<C-V><cr>//ge<cr>'tzt'm
""
""" Quickly open a buffer for scribble
""map <leader>q :e ~/buffer<cr>
""
""" Quickly open a markdown buffer for scribble
""map <leader>x :e ~/buffer.md<cr>
""
""" Toggle paste mode on and off
""map <leader>pp :setlocal paste!<cr>
""
""
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""" => Helper functions
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""" Returns true if paste mode is enabled
""function! HasPaste()
""    if &paste
""        return 'PASTE MODE  '
""    endif
""    return ''
""endfunction
""
""" Don't close window, when deleting a buffer
""command! Bclose call <SID>BufcloseCloseIt()
""function! <SID>BufcloseCloseIt()
""    let l:currentBufNum = bufnr("%")
""    let l:alternateBufNum = bufnr("#")
""
""    if buflisted(l:alternateBufNum)
""        buffer #
""    else
""        bnext
""    endif
""
""    if bufnr("%") == l:currentBufNum
""        new
""    endif
""
""    if buflisted(l:currentBufNum)
""        execute("bdelete! ".l:currentBufNum)
""    endif
""endfunction
""
""function! CmdLine(str)
""    call feedkeys(":" . a:str)
""endfunction 
""
""function! VisualSelection(direction, extra_filter) range
""    let l:saved_reg = @"
""    execute "normal! vgvy"
""
""    let l:pattern = escape(@", "\\/.*'$^~[]")
""    let l:pattern = substitute(l:pattern, "\n$", "", "")
""
""    if a:direction == 'gv'
""        call CmdLine("Ack '" . l:pattern . "' " )
""    elseif a:direction == 'replace'
""        call CmdLine("%s" . '/'. l:pattern . '/')
""    endif
""
""    let @/ = l:pattern
""    let @" = l:saved_reg
""endfunction
