set tabstop=4

so ~/.vimpluginit

" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)

" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)

set tabstop=4
set softtabstop=4
set shiftwidth=4
set noexpandtab

nnoremap <leader>gl :YcmCompleter GoToDeclaration<CR>
nnoremap <leader>gf :YcmCompleter GoToDefinition<CR>
nnoremap <leader>gg :YcmCompleter GoToDefinitionElseDeclaration<CR>
nnoremap <leader>gh :YcmCompleter GoToImplementationElseDeclaration<CR>

" autocmd StdinReadPre * let s:std_in=1
" autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
" autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in") | exe 'NERDTree' argv()[0] | wincmd p | ene | endif

map <C-n> :NERDTreeToggle<CR>
source $VIMRUNTIME/mswin.vim
behave mswin
set keymodel-=stopsel
let g:usemarks = 0
nmap <F8> :TagbarToggle<CR>
let g:ctrlp_cmd = 'CtrlPMixed'
let g:ctrlp_cache_dir = $HOME . '/.cache/ctrlp'
let g:ctrlp_user_command = 'ag %s -i --nocolor --nogroup --hidden
  \ --ignore .git
  \ --ignore .svn
  \ --ignore .hg
  \ --ignore .DS_Store
  \ --ignore "**/*.pyc"
  \ --ignore build
  \ -g ""'
set background=light
colorscheme PaperColor
command Ninja ! cd build && ninja
command CMNinja ! cd build && cmake -DCMAKE_CXX_COMPILER=/usr/bin/clang++ -DCMAKE_C_COMPILER=/usr/bin/clang -DCMAKE_EXPORT_COMPILE_COMMANDS=ON -G Ninja ..
hi CursorLine cterm=NONE ctermbg=darkred ctermfg=white guibg=darkred guifg=white
if executable('ag')
  let g:ackprg = 'ag --vimgrep --ignore .git --ignore build --ignore "**/*.pyc"'
endif
