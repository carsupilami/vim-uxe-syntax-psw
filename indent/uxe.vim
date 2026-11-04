scriptencoding utf-8
" Einrückung für Parity UXE / Formularinterpreter
"   Einrücken nach:   if, else, while, for, subroutine, forminit, beginff, Zeile endet mit {
"   Ausrücken bei:    else, endif, endwhile, endsub, endforminit, endff, Zeile beginnt mit }
" Ausschalten:  let g:uxe_no_indent = 1

if exists('b:did_indent') || get(g:, 'uxe_no_indent', 0)
  finish
endif
let b:did_indent = 1

setlocal indentexpr=GetUxeIndent(v:lnum)
setlocal indentkeys=0{,0},0),!^F,o,O,=else,=endif,=endwhile,=endsub,=endforminit,=endff
setlocal autoindent
let b:undo_indent = 'setlocal indentexpr< indentkeys< autoindent<'

if exists('*GetUxeIndent')
  finish
endif

function s:InComment(lnum) abort
  let col = match(getline(a:lnum), '\S') + 1
  return col > 0 && synIDattr(synID(a:lnum, col, 1), 'name') =~# 'Comment'
endfunction

function GetUxeIndent(lnum) abort
  " Kommentarzeilen nicht anfassen
  if s:InComment(a:lnum)
    return -1
  endif

  " vorige Codezeile (Kommentare überspringen)
  let p = prevnonblank(a:lnum - 1)
  while p > 0 && s:InComment(p)
    let p = prevnonblank(p - 1)
  endwhile
  if p == 0
    return 0
  endif

  let ind  = indent(p)
  let prev = substitute(getline(p), '/\*.\{-}\*/', '', 'g')
  let cur  = getline(a:lnum)

  " 'if ( ... ) {' zählt nur einmal
  if prev =~# '^\s*\%(if\|else\|while\|for\|subroutine\|forminit\|beginff\)\>' || prev =~# '{\s*$'
    let ind += shiftwidth()
  endif
  if cur =~# '^\s*\%(else\|endif\|endwhile\|endsub\|endforminit\|endff\)\>' || cur =~# '^\s*}'
    let ind -= shiftwidth()
  endif
  return ind < 0 ? 0 : ind
endfunction
