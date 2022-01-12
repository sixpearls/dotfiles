"""""""""""""""""
" vundle config "
"""""""""""""""""

call plug#begin('~/.vim/plugged')
Plug 'chriskempson/base16-vim'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'tpope/vim-fugitive'
Plug 'w0rp/ale'
Plug 'sheerun/vim-polyglot'
Plug 'junegunn/goyo.vim'
Plug 'owickstrom/vim-colors-paramount'
Plug 'gotcha/vimpdb'
call plug#end()

set scrolloff=10
" let g:base16_shell_path=base16-builder/output/shell/

""""""""""""""""""
" general config "
""""""""""""""""""

" better backspacing
set backspace=indent,eol,start
" don't make backup files
set nobackup
" show selection size in visual mode
set showcmd
" show matches as a search string is typed
set incsearch
" ignore case in searches...
set ignorecase
" ...unless you search using uppercase letters
set smartcase
" copy indent form current line with <CR> or o or O
set autoindent
" show line numbers
set number
" always insert 4 spaces for tabs
set tabstop=4
set shiftwidth=4
set expandtab
" highlight line of the cursor
set cursorline
" use gui colors specified in the theme (requires +termguicolors)
set termguicolors
" use the mouse
set mouse=a
" keep search matches highlighted
set hlsearch
" wraps lines while keeping words intact
set linebreak
" use unnamed to allow yank/paste from system-wide selection
set clipboard=unnamed
" allow for multiple unwritten buffers
set hidden
" command-line completion
set wildmenu
set wildmode=longest:full,full
" ignore some file types in completion list
set wildignore+=*.pdf,*.aux,*.blg,*.log,*.bbl,*.synctex,*.lof,*.lot,*.toc
" set shell to bash for Vundle
" (https://github.com/VundleVim/Vundle.vim/issues/312)
set shell=/bin/bash
" don't set folds when opening files
set nofoldenable
set nowrap

" some diff options
" set diffopt=filler,internal,algorithm:histogram,indent-heuristic

" space bar is a great map leader
let mapleader = "\<space>"

" enable filetype-dependent indenting
filetype plugin indent on

" enable syntax highlighting
syntax on

" nice colorscheme
" let base16colorspace=256
" I like base16-ashes, but don't use vim for OSX
" colorscheme base16-ashes

" fugitive colors
hi! DiffAdd      guibg=#003300
hi! DiffChange   guibg=#003300
hi! DiffDelete   guifg=#330000 guibg=#330000
hi! DiffText     guibg=#990000   

" visual navigation of wrapped lines
noremap j gj
noremap k gk
noremap gj j
noremap gk k
noremap $ g$
noremap ^ g^
noremap g^ ^
noremap g$ $

" splits
" nnoremap <C-J> <C-W><C-J>
" nnoremap <C-K> <C-W><C-K>
" nnoremap <C-L> <C-W><C-L>
" nnoremap <C-H> <C-W><C-H>

set splitbelow
set splitright

" flying buffer changes
"nnoremap <leader>b :ls<CR>:b<space>

" mapping to build
nnoremap <leader>m :make<CR>

" highlight word nearest cursor without jumping to next match
" thanks to Antony on #vim freenode
nnoremap <leader>* :let @/='\<<c-r><c-w>\>'\|set hls<cr>

" use silver surfer for search
let g:ackprg = 'ag --nogroup --nocolor --column'

" juggling with quickfix entries
nnoremap <End>  :cnext<CR>
nnoremap <Home> :cprevious<CR>

" load 'stub' tex files as regular latex
let g:tex_flavor = "latex"

""""""""""""""""
" netrw config "
""""""""""""""""

" tree view by default
let g:netrw_liststyle = 3
" percentage of split for netrw (great with :Lexplore)
let g:netrw_winsize = 25
" toggle left explorer
nnoremap <leader>e :Lexplore<cr>
" no banner at the top
let g:netrw_banner = 0
let g:netrw_browse_split = 4


"""""""""""""""""""
" file type stuff "
"""""""""""""""""""

" give Makefiles tabs instead of spaces
autocmd FileType make setlocal noexpandtab
" break text files at 88
autocmd FileType text,python setlocal textwidth=88
" highlight texwidth column
set colorcolumn=+1
" turn on spelling
" autocmd FileType text,tex,md,markdown,rst setlocal spell
" don't add a comment char when adding a line below/above a comment line
autocmd FileType * setlocal formatoptions-=o
autocmd FileType markdown setlocal wrap

"hi clear SpellBad
"hi SpellBad cterm=underline

" change bad capitalization to underline
"hi clear SpellCap
"hi SpellCap cterm=underline


" syntax highlighting for files with weird extensions
au BufNewFile,BufRead *.al set filetype=
au BufNewFile,BufRead *.launch set filetype=xml
au BufNewFile,BufRead *.ino set filetype=c
au BufNewFile,BufRead *.pde set filetype=c
au BufNewFile,BufRead *.urdf set filetype=xml
au BufNewFile,BufRead *.sdf set filetype=xml
au BufNewFile,BufRead *.c.src set filetype=c

" jump to last known position in the file
autocmd BufReadPost *
    \ if line("'\"") > 1 && line("'\"") <= line("$") |
    \   exe "normal! g`\"" |
    \ endif


"""""""""""
" linting "
"""""""""""

let g:ale_linters = {'python': ['pycodestyle']}
let g:ale_python_pycodestyle_options = '--ignore=E501,E226'
let g:ale_sign_column_always = 1
let g:ale_lint_on_text_changed = 'never'
let g:ale_set_highlights = 0
let g:ale_completion_enbaled = 1

let g:ale_fixers = {'python': ['black']}
nnoremap <leader>l :ALEFix<cr>


"""""""""""""""""""""""""""
" fix trailing whitespace "
"""""""""""""""""""""""""""

" highlight trailing whitespace, http://vim.wikia.com/wiki/Highlight_unwanted_spaces
highlight default ExtraWhitespace ctermbg=darkred guibg=#663434
autocmd ColorScheme * highlight default ExtraWhitespace ctermbg=darkred guibg=darkred
autocmd BufRead,BufNew * match ExtraWhitespace /\\\@<![\u3000[:space:]]\+$/

function! s:FixWhitespace(line1,line2)
    let l:save_cursor = getpos(".")
    silent! execute ':' . a:line1 . ',' . a:line2 . 's/\\\@<!\s\+$//'
    call setpos('.', l:save_cursor)
endfunction

command! -range=% FixWhitespace call <SID>FixWhitespace(<line1>,<line2>)

""""""""""""""""""""""
" custom status line "
""""""""""""""""""""""

set laststatus=2
if has('statusline')
    " file name + modified flag
    set statusline=%<%f%m
    " fugitive
    set statusline+=%{fugitive#statusline()}
    " right justify
    set statusline+=%=
    " current column, current line, total lines
    set statusline+=\|%c\ -%l/%L
    " vim-pencil mode
    " set statusline+=\ %{PencilMode()}%{PencilAutoformat()}
endif


"""""""""""""
" fzf stuff "
"""""""""""""

" fuzzy find files
nnoremap <leader>f :Files<cr>
" fuzzy ag search
nnoremap <leader>g :Ag<cr>
" open a split with current buffers, use number to switch
nnoremap <leader>b :Buffers<cr>


" Hex read
nmap <Leader>hr :%!xxd<CR> :set filetype=xxd<CR>

" Hex write
nmap <Leader>hw :%!xxd -r<CR> :set binary<CR> :set filetype=<CR>


