set guifont=Menlo:h12

" Solarized
set background=dark
colorscheme solarized

if has("gui_macvim")
  map <D-1> 1gt
  map <D-2> 2gt
  map <D-3> 3gt
  map <D-4> 4gt
  map <D-5> 5gt
  map <D-6> 6gt
  map <D-7> 7gt
  map <D-8> 8gt
  map <D-9> 9gt
  map <D-0> 1gt
endif


" vim-yankstack
if has("gui_macvim")
  :set macmeta
endif
