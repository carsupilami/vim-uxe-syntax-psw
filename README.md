# vim-uxe-syntax-psw

Vim-Unterstützung für **Parity UXE** und den **Parity Formularinterpreter** (ParityERP 5.x):
Syntax-Highlighting, Dateityp-Erkennung, Kommentar-/Matchit-Einstellungen, Einrückung und
optionale Faltung je Subroutine. Läuft unter Windows und Linux mit Vim ≥ 8.0 und Neovim.

| Datei | Inhalt |
|---|---|
| `syntax/uxe.vim` | Highlighting: `%( )%`, Kommentare `/* */`, Strings, Druckmasken (`wert:"###0,00-"`), PMF-Steuerzeichen (`#BBOLD#`), Platzhalter `%1`, Schlüsselwörter (`if/else/endif`, `while/endwhile`, `for`, `subroutine/endsub`, `call`, `return`, `forminit`, `beginff`), eingebaute Funktionen, DB-Befehle, Dateivariablen (`artikel.art_nr$`), Systemvariablen (`POS_BETRAG`, `SB_MASKE$`), `UXERET` |
| `ftdetect/uxe.vim` | Dateityp `uxe` für `*.uxe`, `*.uxe.bsp`, `*.tcsv` und jede Datei, deren erste Zeile `%(` ist (ASCII-Formulare in `frm.cust`, Login-UXE `<programm>.<login>`) |
| `ftplugin/uxe.vim` | `commentstring`, `comments`, `iskeyword+=$` (`name$` ist ein Wort), Matchit-Paare für `%` |
| `indent/uxe.vim` | Einrückung nach `if`, `else`, `while`, `for`, `subroutine`, `forminit`, `beginff`, `{` |

## Installation

Empfohlen ist ein Klon als Vim-Paket (`pack/*/start`), dann genügt später ein `git pull`.
Voraussetzung: SSH-Zugriff auf `git.epcdocker001` (siehe Skill `forgejo-client-setup`).

### Linux

```sh
mkdir -p ~/.vim/pack/epc/start
git clone git@git.epcdocker001:epc/vim-uxe-syntax-psw.git ~/.vim/pack/epc/start/vim-uxe-syntax-psw
```

### Windows (Vim/gVim)

PowerShell:

```powershell
New-Item -ItemType Directory -Force "$env:USERPROFILE\vimfiles\pack\epc\start"
git clone git@git.epcdocker001:epc/vim-uxe-syntax-psw.git "$env:USERPROFILE\vimfiles\pack\epc\start\vim-uxe-syntax-psw"
```

### Neovim

| System | Zielverzeichnis |
|---|---|
| Linux | `~/.local/share/nvim/site/pack/epc/start/vim-uxe-syntax-psw` |
| Windows | `%LOCALAPPDATA%\nvim-data\site\pack\epc\start\vim-uxe-syntax-psw` |

### Ohne Git

Die Ordner `syntax`, `ftdetect`, `ftplugin`, `indent` in das eigene Vim-Verzeichnis kopieren
(Linux `~/.vim/`, Windows `%USERPROFILE%\vimfiles\`). Bestehende Dateien gleichen Namens gibt es
dort normalerweise nicht; vorher prüfen.

### vimrc

In `~/.vimrc` bzw. `%USERPROFILE%\_vimrc` (bei `defaults.vim`/gVim meist schon gesetzt):

```vim
filetype plugin indent on
syntax on
" UXE-Dateien sind UTF-8 (teils mit BOM), ältere Kundendateien noch ISO-8859-1:
set fileencodings=ucs-bom,utf-8,latin1
```

Mit `fileencodings` wie oben öffnet Vim beide Varianten richtig und speichert in der erkannten
Kodierung zurück (`:set fenc?` zeigt sie, `:set bomb?` die BOM). Zeilenenden bleiben, wie sie sind
(`:set ff?`); UXE-Dateien sind LF.

Neue UXE werden in UTF-8 angelegt. Eine Latin-1-Datei (`fenc=latin1`) stellt man beim Ändern um:
`:set fenc=utf-8` und dann `:w`. Der Interpreter liest beide Kodierungen.

### Prüfen

Eine `.uxe`-Datei öffnen und `:set ft?` eingeben → `filetype=uxe`. Wird nichts hervorgehoben:
`:syntax on` und `:scriptnames` (wird `.../syntax/uxe.vim` geladen?). Debian/Ubuntu-Minimal-
installationen haben oft nur `vim.tiny` ohne Syntax-Highlighting → Paket `vim` installieren.

## Optionen

```vim
let g:uxe_folding = 1        " Faltung je subroutine ... endsub (zo/zc/zR/zM)
let g:uxe_no_indent = 1      " eigene Einrückung abschalten (nur autoindent)
let g:uxe_no_sysvar = 1      " GROSS geschriebene Systemvariablen nicht hervorheben
let g:uxe_no_operators = 1   " Operatoren (&& || == ...) nicht hervorheben
```

Die Optionen vor dem Öffnen der Datei setzen (vimrc).

## Aktualisieren

```sh
cd ~/.vim/pack/epc/start/vim-uxe-syntax-psw && git pull
```

Windows: im Verzeichnis `%USERPROFILE%\vimfiles\pack\epc\start\vim-uxe-syntax-psw` `git pull`.

## Hinweise

- Grundlage ist das Programmierhandbuch Formularinterpreter 5.2. Sprachreferenz, Index aller
  Standard-UXE und Muster stehen im Claude-Skill `uxe` (Marketplace `epc`, Plugin `epc-skills`).
- Die Syntaxprüfung ersetzt kein `flint` auf dem Parity-System: Syntaxfehler in einer UXE brechen
  das Programm beim Start ab.
- Hervorgehoben werden die dokumentierten Funktionen nur vor `(`; ein gleichnamiger Variablenname
  (`pos`, `sub`) bleibt dadurch unmarkiert.
