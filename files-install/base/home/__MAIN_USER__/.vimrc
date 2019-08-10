" Don't be vi compatible
set nocompatible
filetype off

" PLUGINS
call plug#begin('~/.vim/plugins')

Plug 'leafgarland/typescript-vim'
Plug 'ncm2/ncm2'

" enable ncm2 for all buffers
autocmd BufEnter * call ncm2#enable_for_buffer()

" IMPORTANT: :help Ncm2PopupOpen for more information
set completeopt=noinsert,menuone,noselect

" NOTE: you need to install completion sources to get completions. Check
" our wiki page for a list of sources: https://github.com/ncm2/ncm2/wiki
Plug 'ncm2/ncm2-bufword'
Plug 'ncm2/ncm2-path'

Plug 'roxma/nvim-yarp'
Plug 'jalvesaq/Nvim-R'
Plug 'gaalcaras/ncm-R'

" Optional: for snippet support
" Further configuration might be required, read below
Plug 'sirver/UltiSnips'
Plug 'ncm2/ncm2-ultisnips'

" Optional: better Rnoweb support (LaTeX completion)
Plug 'lervag/vimtex'

Plug 'roxma/vim-hug-neovim-rpc'

" Plug 'oblitum/YouCompleteMe'

let g:ycm_global_ycm_extra_conf = "~/.vim/.ycm_extra_conf.py"

call plug#end()

" Enable filetype detection
filetype plugin indent on

" enable syntax highlighting
syntax on

" backspace over indent, \n, start
set backspace=indent,eol,start

" automatically indent
set autoindent

" smart indent
set smartindent

" stop certain movements from always going to first char of line
set nostartofline

" ask for confirmation on :q instead of just failing
set confirm

" Reflect changes when a file is changed from the outside
set autoread

" :W saves file with sudo
command W w !sudo tee % > /dev/null

" good color scheme
colorscheme elflord

" Cursor only moves screen 6 lines
set scrolloff=6

" Better command-line completion
set wildmenu

" Show line number
set number

" Highlight current line
set cursorline

" Show current position
set ruler

" Command bar height
set cmdheight=2

" Show matching brackets
set showmatch

" Blink matching brackets
set mat=2

" No bells on errors
set noerrorbells
set novisualbell
set t_vb=
set tm=500

" set utf8 as standard encoding
set encoding=utf8

" Case-insensitive searches / try to guess case when searching
set ignorecase
set smartcase

" highlight current search
set hlsearch

" clear search highlighting with <Space>
nnoremap <Space> :nohl<CR><C-L>

" web-browser like searches
set incsearch

" wrap lines
set wrap

" don't skip over wrapped lines
nnoremap j gj
nnoremap k gk
nnoremap ^ g^
nnoremap $ g$

" tabs appear as 4 spaces. tab key inserts '\t'
set shiftwidth=4
set noexpandtab
set tabstop=4

" remove trailing whitespace when I save file
autocmd BufWritePre * %s/\s\+$//e

" don't indent case labels or c++ access specifiers
set cinoptions+=:0,g0,N-s,j1,(0,ws,Ws

" better ycm highlighting
highlight Pmenu ctermfg=2 ctermbg=16 guifg=#ffffff guibg=#0000ff

function! CppNoNamespaceAndTemplateIndent()
	let l:cline_num = line('.')
	let l:cline = getline(l:cline_num)
	let l:pline_num = prevnonblank(l:cline_num - 1)
	let l:pline = getline(l:pline_num)
	while l:pline =~# '\(^\s*{\s*\|^\s*//\|^\s*/\*\|\*/\s*$\)'
		let l:pline_num = prevnonblank(l:pline_num - 1)
		let l:pline = getline(l:pline_num)
	endwhile
	let l:retv = cindent('.')
	let l:pindent = indent(l:pline_num)
	if l:pline =~# '^\s*template\s*'
		let l:retv = l:pindent
	elseif l:pline =~# '\s*typename\s*.*,\s*$'
		let l:retv = l:pindent
	elseif l:cline =~# '^\s*>\s*$'
		let l:retv = l:pindent - &shiftwidth
	elseif l:pline =~# '\s*typename\s*.*>\s*$'
		let l:retv = l:pindent - &shiftwidth
	elseif l:pline =~# '^\s*namespace.*'
		let l:retv = 0
	endif
	return l:retv
endfunction

if has("autocmd")
	autocmd BufEnter *.{cc,cxx,cpp,h,hh,hpp,hxx} setlocal indentexpr=CppNoNamespaceAndTemplateIndent()
endif

let R_assign = 2
