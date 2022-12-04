colorscheme industry

" line number 
set number
set relativenumber

" search
set showmatch   " show matching brackets when text indicator is over them
set hlsearch
set incsearch
set ignorecase
set smartcase   " works as case-insensitive if you only use lowercase letters; otherwise, it will
                " search in case-sensitive mode

" format 
set textwidth=120
set autoindent
set expandtab
set tabstop=4
set shiftwidth=4

" mouse
set mouse=a

" display file name on the terminal title
set title

" turn backup off, since most stuff is in Git or else anyway...
set nobackup
set nowb
set noswapfile

" special mappings
nmap j gj
nmap k gk
vmap j gj
vmap k gk
nmap <C-s> <cmd>w<CR>
nmap <Space>q <cmd>q<CR>
