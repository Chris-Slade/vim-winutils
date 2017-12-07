" winutils: Things that should be provided for working with windows, but aren't
" Last Change: 2017-12-07
" Maintainer: Chris-Slade (GitHub)
" License: MIT

if exists('g:loaded_winutils') || &cp | finish | endif
let g:loaded_winutils = 1
let s:savecpo = $cpo
set cpo&vim

if !exists('g:winutils_no_lsw')
    command! Lsw :call winutils#ListWindows()
endif

" Restore options
let &cpo = s:savecpo
unlet s:savecpo
