scriptencoding utf-8
" Dateityp-Erkennung für Parity UXE / Formularinterpreter
"   *.uxe            UXE im Customizing (<paket>/uxe.cust)
"   *.uxe.bsp        Standard-Beispiele (<paket>/uxe)
"   *.tcsv           CSV-Templates
"   sonst            jede Datei, deren erste Zeile mit %( beginnt
"                    (ASCII-Formulare in frm.cust, Login-UXE <prog>.<login>)
autocmd BufNewFile,BufRead *.uxe,*.uxe.bsp,*.tcsv  setfiletype uxe
autocmd BufRead * if !did_filetype() && getline(1) =~# '^\s*%(\s*$' | setfiletype uxe | endif
