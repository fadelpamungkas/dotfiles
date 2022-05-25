set ttyfast
set showmatch
set ignorecase
set smartcase
set nohlsearch
set incsearch
set autoindent
set smartindent
set number
set clipboard=unnamedplus
set mouse=a
set tabstop=2
set softtabstop=2
set shiftwidth=2
set expandtab

lua require('impatient').enable_profile()
lua require('initial')
lua require('plugins')
lua require('configs.alpha')
lua require('configs.toggleterm')
