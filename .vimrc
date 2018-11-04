" Load Plugins
so ~/.vimpluginit

" Tab config
set tabstop=4
set softtabstop=4
set shiftwidth=4
set noexpandtab
autocmd Filetype python setlocal expandtab tabstop=4 shiftwidth=4

" YouCompleteMe Config
nnoremap <leader>gg :YcmCompleter GoToDeclaration<CR>
nnoremap <leader>gf :YcmCompleter GoToDefinition<CR>

" Nerdtree config
map <C-n> :NERDTreeToggle<CR>
let NERDTreeIgnore = ['\.pyc$', '.egg-info$', 'build', 'dist', '__pycache__', 'compile_commands.json']

" ALE Config
let g:ale_linters = {
\   'cpp': ['clangcheck', 'clangtidy', 'cppcheck'],
\}

" Tagbar
nmap <F8> :TagbarToggle<CR>

" FSwitch
au! BufEnter *.cpp,*.cxx,*.cc let b:fswitchdst = 'hpp,h' | let b:fswitchlocs = '.'
au! BufEnter *.h,*.hpp let b:fswitchdst = 'cpp,cxx,cc' | let b:fswitchlocs = '.'
nmap <silent> <Leader>of :FSHere<cr>
nmap <silent> <Leader>ok :FSAbove<cr>
nmap <silent> <Leader>oj :FSBelow<cr>

" Color scheme config
set background=dark
colorscheme PaperColor
syntax enable
if has('gui_running')
	"colorscheme solarized
	set background=light
endif

" Custom build commands
command Ninja ! ninja -C build
command CMNinja ! cd build && cmake -DCMAKE_CXX_COMPILER=/usr/bin/clang++ -DCMAKE_C_COMPILER=/usr/bin/clang -DCMAKE_EXPORT_COMPILE_COMMANDS=ON -G Ninja ..
let &makeprg = "ninja -C build"

" Configure ack to use ag
if executable('ag')
  let g:ackprg = 'ag --vimgrep --ignore .git --ignore build --ignore "**/*.pyc" --ignore __pycache__ --ignore dist --ignore "**/*.egg-info" --ignore compile_commands.json'
endif

" Clipbard/mouse/etc.
set number
set mouse=a
set clipboard=unnamedplus

set exrc
set secure
