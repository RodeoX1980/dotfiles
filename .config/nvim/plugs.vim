if &compatible
  set nocompatible               " Be iMproved
endif

" Required:
set runtimepath+=/Users/niishunsuke/.cache/dein/repos/github.com/Shougo/dein.vim

if dein#load_state($HOME . '/.config/nvim/dein')
  " XDG base direcory compartible

  let g:dein#cache_directory = $HOME . '/.cache/dein'
  " Required:
  call dein#begin($HOME . '/.config/nvim/dein')
  
  " プラグインリストを収めた TOML ファイル
  " 予め TOML ファイル（後述）を用意しておく
  let s:toml_dir  = $HOME . '/.config/nvim/dein/toml' 
  let s:toml      = s:toml_dir . '/dein.toml'
  let s:lazy_toml = s:toml_dir . '/dein_lazy.toml'
  
  " TOML を読み込み、キャッシュしておく
  call dein#load_toml(s:toml,      {'lazy': 0})
  call dein#load_toml(s:lazy_toml, {'lazy': 1})
  
  call dein#end()
  call dein#save_state()

endif

" Required:
filetype plugin indent on
syntax enable

" If you want to install not installed plugins on startup.
"if dein#check_install()
"  call dein#install()
"endif
