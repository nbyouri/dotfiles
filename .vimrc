"
"
" yrmt february 2015
"
"
set nocompatible              " be iMproved, required
filetype off                  " required
set laststatus=2
set encoding=utf8
set modeline
filetype plugin on
syntax on
set mouse=a

"    "
" ui "
"    "
"if &t_Co < 256
set t_Co=256
set guicursor=a:blinkon0
"set nu!                    " line numbering
set smartindent

" wrap'n'jump by display lines
set wrap
set linebreak
set display+=lastline

set ruler         " show the cursor position all the time
set showcmd       " display incomplete commands

" buftabs
noremap <F11> :bprev<CR>
noremap <F12> :bnext<CR>
let g:buftabs_only_basename=1
let g:buftabs_separator = "."
let g:buftabs_marker_start = "["
let g:buftabs_marker_end = "]"
let g:buftabs_marker_modified = "*"

" statusline
"set cmdheight=0    " command line height
set ruler           " show cursor position in status line
set showmode        " show mode in status line
set showcmd         " show partial commands in status line
" fileformat, encoding, type, buffer num, RO/HELP/PREVIEW, mod flag, filepath; spacer;  line pos, line/total, percentage
set statusline=%{&ff}\ \%{&fenc}\ \b%1.3n\ \%#StatusFTP#\%Y\ \%#StatusRO#\%R\ \%#StatusHLP#\%H\ \%#StatusPRV#\%W\ \%#StatusModFlag#\%M\ \%#StatusLine#\%f\%=\%1.7c\ \%1.7l/%L\ \%p%%

" automatically give executable permissions if file 
" begins with #! and contains '/bin/' in the path
function ModeChange()
	if getline(1) =~ "^#!"
		if getline(1) =~ "/bin/"
			silent !chmod a+x <afile> 
		endif
	endif
endfunction
au BufWritePost * call ModeChange()

augroup mkd
	autocmd BufRead *.mkd  set ai formatoptions=tcroqn2 comments=n:&gt;
augroup END

" tab key in visual mode
vmap <tab> >gv
vmap <S-tab> <gv

if has('mouse')
	set mouse=a
endif
set mousemodel=popup_setpos

" improves redrawing for newer computers
set tf
set nolazyredraw        " turn off lazy redraw
set nohlsearch          " highlight no search results
set wildmenu
set clipboard=unnamed   " yank and copy to X clipboard

"                     "
" searching & history "
"                     "
set hlsearch          " highlight all search results
set incsearch         " increment search
set ignorecase        " case-insensitive search; opposite noignorecase
set smartcase         " uppercase causes case-sensitive search
set wrapscan          " searches wrap back to the top of file

set nobackup          " don't create backup files
set noswapfile        " don't create swap file

set history=50        " keep 50 lines of command line history
set incsearch         " do incremental searching

set tags+=ftags

"      "
" misc "
"      "
" allow writing to files with root priviledges
cmap w!! w !sudo tee % > /dev/null
colorscheme  neverland

set colorcolumn=80
set cinoptions=t0,+4,(4,u4,w1
set shiftwidth=8
set softtabstop=8
set tabstop=8
set autoindent
set showmatch
set tags=./tags,tags,/usr/src/sys/arch/amd64/tags,/var/db/libc.tags
set hlsearch
set incsearch
set backspace=indent,eol,start
set showcmd             " display incomplete commands
set ttyfast             " needed to make laggy connections work fast enough
" show KNF violations
highlight OverLength ctermbg=red ctermfg=white guibg=#592929
match OverLength /\%81v.*/
let c_space_errors=1

" line
set cinoptions=:0,t0,+4,(4
