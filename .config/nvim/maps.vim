" Description: Keymaps

nnoremap <S-C-p> "0p
" Delete without yank
nnoremap <leader>d "_d
nnoremap x "_x

" Increment/decrement
nnoremap + <C-a>
nnoremap - <C-x>

" Delete a word backwards
nnoremap dw vb"_d

" Clear search result
nmap <ESC><ESC> :noh<CR>

" Select all
nmap <C-a> gg<S-v>G
" Save with root permission
command! W w !sudo tee > /dev/null %

" Search for selected text, forwards or backwards.
vnoremap <silent> * :<C-U>
  \let old_reg=getreg('"')<Bar>let old_regtype=getregtype('"')<CR>
  \gvy/<C-R><C-R>=substitute(
  \escape(@", '/\.*$^~['), '\_s\+', '\\_s\\+', 'g')<CR><CR>
  \gV:call setreg('"', old_reg, old_regtype)<CR>
vnoremap <silent> # :<C-U>
  \let old_reg=getreg('"')<Bar>let old_regtype=getregtype('"')<CR>
  \gvy?<C-R><C-R>=substitute(
  \escape(@", '?\.*$^~['), '\_s\+', '\\_s\\+' 'g')<CR><CR>
  \gV:call setreg('"', old_reg, old_regtype)<CR>

"-----------------------------
" Tabs

" Open current directory
nmap te :tabedit 
nmap <S-Tab> :tabprev<Return>
nmap <Tab> :tabnext<Return>

"------------------------------
" Windows

" Split window
nmap ss :split<Return><C-w>w
nmap sv :vsplit<Return><C-w>w
" Move window
nmap <Space> <C-w>w
map s<left> <C-w>h
map s<up> <C-w>k
map s<down> <C-w>j
map s<right> <C-w>l
map sh <C-w>h
map sk <C-w>k
map sj <C-w>j
map sl <C-w>l
" Resize window
nmap <C-w><left> <C-w><
nmap <C-w><right> <C-w>>
nmap <C-w><up> <C-w>+
nmap <C-w><down> <C-w>-

"------------------------------
" fzf
let mapleader = "d"
nnoremap <silent> <Leader>. :<C-u>FZFFileList<CR>
nnoremap <silent> <Leader>, :<C-u>FZFMru<CR>
nnoremap <silent> <Leader>l :<C-u>Lines<CR>
nnoremap <silent> <Leader>b :<C-u>Buffers<CR>
nnoremap <silent> <Leader>k :<C-u>Rg<CR>
command! FZFFileList call fzf#run({
           \ 'source': 'rg --files --hidden',
           \ 'sink': 'e',
           \ 'options': '-m --border=none',
           \ 'down': '20%'})
command! FZFMru call fzf#run({
           \ 'source': v:oldfiles,
           \ 'sink': 'e',
           \ 'options': '-m +s --border=none',
           \ 'down':  '20%'})

let g:fzf_layout = {'up':'~90%', 'window': { 'width': 0.8, 'height': 0.8,'yoffset':0.5,'xoffset': 0.5, 'border': 'none' } }

augroup vimrc_fzf
autocmd!
autocmd FileType fzf tnoremap <silent> <buffer> <Esc> <C-g>
autocmd FileType fzf set laststatus=0 noshowmode noruler
     \| autocmd BufLeave <buffer> set laststatus=2 noshowmode ruler
augroup END

function! RipgrepFzf(query, fullscreen)
   let command_fmt = 'rg --column --hiddden --line-number --no-heading --color=always --smart-case %s || true'
   let initial_command = printf(command_fmt, shellescape(a:query))
   let reload_command = printf(command_fmt, '{q}')
   let spec = {'options': ['--phony', '--query', a:query, '--bind', 'change:reload:'.reload_command]}
   call fzf#vim#grep(initial_command, 1, fzf#vim#with_preview(spec), a:fullscreen)
endfunction

command! -nargs=* -bang RG call RipgrepFzf(<q-args>, <bang>0)

"------------------------------
" ddu

call ddu#custom#patch_global({
\   'ui': 'ff',
\   'sources': [
\     {
\       'name': 'file_rec',
\       'params': {
\         'ignoredDirectories': ['.git', 'node_modules', 'vendor', '.next']
\       }
\     }
\   ],
\   'sourceOptions': {
\     '_': {
\       'matchers': ['matcher_substring'],
\     },
\   },
\   'filterParams': {
\     'matcher_substring': {
\       'highlightMatched': 'Title',
\     },
\   },
\   'kindOptions': {
\     'file': {
\       'defaultAction': 'open',
\     },
\   },
\   'uiParams': {
\     'ff': {
\       'startFilter': v:true,
\       'prompt': '> ',
\       'split': 'floating',
\     }
\   },
\ })

call ddu#custom#patch_local('grep', {
\   'sourceParams' : {
\     'rg' : {
\       'args': ['--column', '--no-heading', '--color', 'never'],
\     },
\   },
\   'uiParams': {
\     'ff': {
\       'startFilter': v:false,
\     }
\   },
\ })


autocmd FileType ddu-ff call s:ddu_my_settings()
function! s:ddu_my_settings() abort
  nnoremap <buffer><silent> <CR>
    \ <Cmd>call ddu#ui#ff#do_action('itemAction', {'name': 'open', 'params': {'command': 'vsplit'}})<CR>

  nnoremap <buffer><silent> <Space>
    \ <Cmd>call ddu#ui#ff#do_action('itemAction', {'name': 'open', 'params': {'command': 'split'}})<CR>

  nnoremap <buffer><silent> a
    \ <Cmd>call ddu#ui#ff#do_action('openFilterWindow')<CR>

  nnoremap <buffer><silent> p
    \ <Cmd>call ddu#ui#ff#do_action('preview')<CR>

  nnoremap <buffer><silent> <Esc>
    \ <Cmd>call ddu#ui#ff#do_action('quit')<CR>
endfunction

autocmd FileType ddu-ff-filter call s:ddu_filter_my_settings()
function! s:ddu_filter_my_settings() abort
  inoremap <buffer><silent> <CR>
    \ <Esc><Cmd>close<CR>

  inoremap <buffer><silent> <Esc>
    \ <Esc><Cmd>close<CR>

  nnoremap <buffer><silent> <CR>
    \ <Cmd>close<CR>

  nnoremap <buffer><silent> <Esc>
    \ <Cmd>close<CR>
endfunction

nmap <silent> ;f <Cmd>call ddu#start({})<CR>
nmap <silent> ;g <Cmd>call ddu#start({
\   'name': 'grep',
\   'sources':[
\     {'name': 'rg', 'params': {'input': expand('<cword>')}}
\   ],
\ })<CR>
