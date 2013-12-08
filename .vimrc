filetype off 
set laststatus=0
set nocompatible
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

set expandtab
set tabstop=8       " set tab keys to 2 spaces
set shiftwidth=4
" set autoindent     " set noautoindent to prevent vim from
                     " inserting unwanted indents when pasting
" backspace
set bs=2

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

map <C-f> :FufFile /home/bohoomil/<CR>

set tags+=ftags


"      "
" misc "
"      "
" allow writing to files with root priviledges
cmap w!! w !sudo tee % > /dev/null

" Show syntax highlighting groups for word under cursor
nmap <C-S-P> :call <SID>SynStack()<CR>
function! <SID>SynStack()
  if !exists("*synstack")
    return
  endif
  echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
endfunc

"                        "
" gvim specific settings "
"                        "
if has ("gui_running")
    " only initialize window size if it has not been initialized yet
    if !exists ("s:my_windowInitialized_variable")
        let s:my_windowInitialized_variable=1

	" feel free to :set background=light for a different style
  set mouse=a

    set guifont=Monaco\ 10

    " geometry
	set lines=70 columns=120

	set winaltkeys=no

    " menubar / toolbar on / off
    map <silent> <F2> :if &guioptions =~# 'T' <Bar>
	\set guioptions-=T <Bar>
	\set guioptions-=m <bar>
	\else <Bar>
	\set guioptions+=T <Bar>
	\set guioptions+=m <Bar>
	\endif<CR>
	
    " remove scrollbars in gVim
	set guioptions+=LlRrb
	set guioptions-=LlRrb
	
    " turn off toolbar
    "set guioptions+=T
	"set guioptions-=T

	" toolbar -- exclusions
	aunmenu ToolBar.Make
	aunmenu ToolBar.RunCtags
	aunmenu ToolBar.SaveSesn
	aunmenu ToolBar.LoadSesn
	aunmenu ToolBar.SaveAll
	aunmenu ToolBar.FindHelp

	endif
endif
" + after config "

function! StartUp()
		    if 0 == argc()
	        NERDTree
		    end
endfunction

autocmd VimEnter * call StartUp()

let NERDTReeShowHidden=1

colorscheme  neverland
set rtp+=/usr/local/go/misc/vim
filetype plugin indent on
syntax on

