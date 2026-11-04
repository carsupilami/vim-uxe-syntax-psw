scriptencoding utf-8
" Vim syntax file
" Language:     Parity UXE / Formularinterpreter (ParityERP 5.x)
" Files:        *.uxe, *.uxe.bsp, *.tcsv, ASCII-Formulare (Inhalt beginnt mit %( )
" Maintainer:   EPC (epc/vim-uxe-syntax-psw)
" Last Change:  2026-11-04
" Reference:    Parity Programmierhandbuch Formularinterpreter 5.2
"
" Options:
"   let g:uxe_no_sysvar = 1        Großgeschriebene Systemvariablen nicht hervorheben
"   let g:uxe_no_operators = 1     Operatoren nicht hervorheben

if exists('b:current_syntax')
  finish
endif

let s:cpo_save = &cpo
set cpo&vim

syn case match

" --- Rahmen ----------------------------------------------------------------
syn match   uxeDelimiter   "%("
syn match   uxeDelimiter   ")%"

" --- Kommentare ------------------------------------------------------------
syn keyword uxeTodo        contained TODO FIXME XXX HINWEIS ACHTUNG WICHTIG DEBUG
syn region  uxeComment     start="/\*" end="\*/" contains=uxeTodo,@Spell extend

" --- Zahlen und Strings ----------------------------------------------------
syn match   uxeNumber      "\<\d\+\%(\.\d\+\)\=\>"
syn match   uxeNumber      "\.\d\+\>"

syn match   uxePmf         contained "#[A-Z][A-Z0-9]*\%([ =][^#"]*\)\=#"
syn match   uxePlaceholder contained "%[1-9]"
syn region  uxeString      start=+"+ end=+"+ oneline contains=uxePmf,uxePlaceholder

" Druckmaske nach ':'   wert : "#####0,00-"
syn match   uxeMask        +\%(:\s*\)\@<="[-#0-9,. ]*"+

" --- Schlüsselwörter -------------------------------------------------------
syn keyword uxeConditional if else endif
syn keyword uxeRepeat      while endwhile for
syn keyword uxeStatement   call return
syn keyword uxeDefine      subroutine endsub
syn keyword uxeSection     forminit endforminit beginff endff
syn keyword uxeConstant    lf LF ff FF pff PFF bs BS

" Name nach subroutine / call
syn match   uxeSubName     "\%(\<\%(subroutine\|call\)\s\+\)\@<=\h\w*"

" --- Eingebaute Funktionen (nur vor '(') -----------------------------------
" Strings, Zahlen, Datum
syn match   uxeFunction    "\<\%(len\|pos\|sub\|trimmed\|to_upper\|to_lower\|val\|chr\|ord\|pm\|pm_subst\|getmsg\|makemask\|round\|abs\|dstr\|tb_datfunc\|tb_datfunc_s\)\ze\s*("
" Umgebung, Dialog, Rechte, Office, Medien, Programmaufruf
syn match   uxeFunction    "\<\%(getenv\|msg\|permchk\|userhasrole\|mediapath\|mkdocument\|mkarchive\|download\)\ze\s*("
" Attribute und indizierter Zugriff
syn match   uxeFunction    "\<\%(setnumattr\|setstrattr\|numattr\|strattr\|numvar\|strvar\|dbnumvar\|dbstrvar\)\ze\s*("
" Datenbank
syn match   uxeDbFunction  "\<\%(dbselinit\|dbselect\|dbfind\|dbnext\|dbinitrec\|mkdblog\)\ze\s*("
" Druck / Formular
syn match   uxePrint       "\<\%(print\|fmt\|fmtctl\|csvfmt\|at\|atp\|atrp\|atm\|atrm\|scp\|rcp\|picture\|exit\)\ze\s*("

" --- Variablen -------------------------------------------------------------
" Dateivariable  relation.feld  bzw.  relation.feld$
syn match   uxeDbField     "\<\l[a-z0-9_]*\.\h\w*\$\="

if !exists('g:uxe_no_sysvar')
  " Systemvariablen der Applikation: GROSS geschrieben, z.B. POS_BETRAG, SB_MASKE$
  syn match uxeSysVar      "\<\u[A-Z0-9_]*\%(\$\|\>\)"
endif
" Rückgabewert
syn keyword uxeUxeret      UXERET

" --- Operatoren ------------------------------------------------------------
if !exists('g:uxe_no_operators')
  syn match uxeOperator    "&&\|||\|==\|!=\|<=\|>=\|!"
endif

" --- Synchronisation: mehrzeilige /* */-Kommentare (Dateikopf, .bsp-Beschreibungen)
syn sync ccomment uxeComment minlines=100 maxlines=1000

" --- Verknüpfungen ---------------------------------------------------------
hi def link uxeDelimiter   PreProc
hi def link uxeComment     Comment
hi def link uxeTodo        Todo
hi def link uxeNumber      Number
hi def link uxeString      String
hi def link uxeMask        Special
hi def link uxePmf         SpecialChar
hi def link uxePlaceholder SpecialChar
hi def link uxeConditional Conditional
hi def link uxeRepeat      Repeat
hi def link uxeStatement   Statement
hi def link uxeDefine      Define
hi def link uxeSection     PreProc
hi def link uxeConstant    Constant
hi def link uxeSubName     Function
hi def link uxeFunction    Function
hi def link uxeDbFunction  Function
hi def link uxePrint       Function
hi def link uxeDbField     Type
hi def link uxeSysVar      Identifier
hi def link uxeUxeret      Special
hi def link uxeOperator    Operator

let b:current_syntax = 'uxe'

let &cpo = s:cpo_save
unlet s:cpo_save
