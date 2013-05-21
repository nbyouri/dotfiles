" key mapings redesign for colemak layout
"
"
"Author: ask
"Email: a.skurihin@gmail.com
"
" Navigation
noremap n h
noremap o l
noremap i k
noremap e j
noremap k n
" Shift-u/e page up/down
noremap U <C-u>
noremap E <C-d>

" Plugins remapings
nmap <C-u> <Plug>BisectUp
nmap <C-e> <Plug>BisectDown
xmap <C-u> <Plug>VisualBisectUp
xmap <C-e> <Plug>VisualBisectDown

map <silent><C-J> :<C-U>YRReplace '-1', 'P'<CR>
map <silent><C-L> :<C-U>YRReplace '-1', 'p'<CR>

" Word navigation
noremap q b
noremap Q B
noremap p e
noremap P E

"" Copy/paste
noremap j y
noremap J Y
noremap l p
noremap L P

"" Undo/redo
noremap b u
noremap B U
noremap <silent> w :redo<CR>


" M record a macro
noremap M q

" h/H join/help
noremap h J
noremap H K

" t change to insert mode
noremap t i
noremap T I
nnoremap gt gi
nnoremap gT gI

" folds
nnoremap zj zu
nnoremap zk ze

inoremap tt <right><esc>
" Make new line creating more comfortable
noremap s o
noremap S O
"noremap o s

"noremap O S

" Help-file navigation
autocmd FileType help nnoremap <buffer> <CR> <C-]>
autocmd FileType help nnoremap <buffer> <Backspace> <C-t>
