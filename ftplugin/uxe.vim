scriptencoding utf-8
" Dateityp-Einstellungen für Parity UXE / Formularinterpreter
"
" Options:
"   let g:uxe_folding = 1    Faltung je subroutine ... endsub

if exists('b:did_ftplugin')
  finish
endif
let b:did_ftplugin = 1

let s:cpo_save = &cpo
set cpo&vim

" name$ als ein Wort (Suche mit *, Wortbewegungen)
setlocal iskeyword+=$
setlocal commentstring=/*\ %s\ */
setlocal comments=s1:/*,mb:*,ex:*/,:**
setlocal formatoptions-=t formatoptions+=croql

let b:undo_ftplugin = 'setlocal iskeyword< commentstring< comments< formatoptions<'

" matchit: % springt zwischen den Blockgrenzen
if exists('loaded_matchit') || exists('g:loaded_matchit')
  let b:match_ignorecase = 0
  let b:match_words =
        \ '\<if\>:\<else\>:\<endif\>,' .
        \ '\<while\>:\<endwhile\>,' .
        \ '\<subroutine\>:\<return\>:\<endsub\>,' .
        \ '\<forminit\>:\<endforminit\>,' .
        \ '\<beginff\>:\<endff\>,' .
        \ '%(:)%'
  let b:match_skip = 's:Comment\|String'
  let b:undo_ftplugin .= ' | unlet! b:match_ignorecase b:match_words b:match_skip'
endif

if get(g:, 'uxe_folding', 0)
  setlocal foldmethod=expr foldexpr=UxeFoldExpr(v:lnum)
  let b:undo_ftplugin .= ' | setlocal foldmethod< foldexpr<'
  if !exists('*UxeFoldExpr')
    function UxeFoldExpr(lnum) abort
      let l = getline(a:lnum)
      if l =~# '^\s*subroutine\>'
        return '>1'
      elseif l =~# '^\s*endsub\>'
        return '<1'
      endif
      return '='
    endfunction
  endif
endif

let &cpo = s:cpo_save
unlet s:cpo_save
