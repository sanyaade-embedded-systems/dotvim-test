" vim: set et sw=2 sts=2 fdm=marker fdl=0:

if v:version < 600
  echo 'ERROR: Vim version too old.  Upgrade to Vim 6.0 or later.'
  finish
endif


if has('win32')
  " We use this rather than 'behave mswin', as the latter makes GVim act like
  " other windows applications, rather than like Vim.
  source $VIMRUNTIME/mswin.vim
else
  let $TEMP = '/tmp'
endif
behave xterm

filetype off

" Bundles {{{1
set runtimepath+=~/.vim/vundle/
call vundle#rc()

" lazysnipmate {{{2
Bundle 'https://github.com/MarcWeber/vim-addon-mw-utils'
Bundle 'https://github.com/tomtom/tlib_vim'
Bundle 'https://github.com/vim-scripts/lazysnipmate'
" }}}2

Bundle "git://git.wincent.com/command-t"
Bundle "https://github.com/chrisbra/changesPlugin"
Bundle "https://github.com/ciaranm/detectindent"
Bundle "https://github.com/ciaranm/securemodelines"
Bundle "https://github.com/ehamberg/vim-cute-python"
Bundle "https://github.com/ervandew/supertab"
Bundle "https://github.com/godlygeek/tabular"
Bundle "https://github.com/guns/jellyx.vim"
Bundle "https://github.com/kergoth/aftersyntaxc.vim"
Bundle "https://github.com/kergoth/vim-HiLinkTrace"
Bundle "https://github.com/kergoth/vim-bitbake"
Bundle "https://github.com/kergoth/vim-golang"
Bundle "https://github.com/mattn/gist-vim"
Bundle "https://github.com/mileszs/ack.vim"
Bundle "https://github.com/rson/vim-conque"
Bundle "https://github.com/scrooloose/nerdcommenter"
Bundle "https://github.com/scrooloose/nerdtree"
Bundle "https://github.com/sjl/gundo.vim"
Bundle "https://github.com/timcharper/gitosis.vim"
Bundle "https://github.com/tmatilai/gitolite.vim"
Bundle "https://github.com/tpope/vim-fugitive"
Bundle "https://github.com/tpope/vim-git"
Bundle "https://github.com/tpope/vim-markdown"
Bundle "https://github.com/tpope/vim-pathogen"
Bundle "https://github.com/tpope/vim-repeat"
Bundle "https://github.com/tpope/vim-speeddating"
Bundle "https://github.com/tpope/vim-surround"
Bundle "https://github.com/tpope/vim-unimpaired"

Bundle "bufexplorer.zip"
Bundle "CountJump"
Bundle "CSApprox"
Bundle "diff_movement"
Bundle "easytags.vim"
Bundle "github-theme"
Bundle "help_movement"
Bundle "indentpython.vim--nianyang"
Bundle "LargeFile"
Bundle "luainspect.vim"
Bundle "ManPageView"
Bundle "matchit.zip"
Bundle "Modeliner"
Bundle "NERD_tree-Project"
Bundle "pyflakes.vim"
Bundle "pylint.vim"
Bundle "Python-2.x-Standard-Library-Reference"
Bundle "Python-3.x-Standard-Library-Reference"
Bundle "python_import.vim"
Bundle "reload.vim"
Bundle "session.vim--Odding"
Bundle "shell.vim--Odding"
Bundle "taglist.vim"
Bundle "vis"

" Functions {{{1
fun! Print(...)
  let l:colo = g:colors_name
  let l:printcolo = a:0 == 1 ? a:1 : g:print_syntax
  let l:bg = &background

  exe 'colo ' . l:printcolo
  let &background = 'light'
  ha
  exe 'colo ' . l:colo
  let &background = l:bg
endfun

" Via vimcasts / http://bit.ly/gktKmH
function! Preserve(command)
  " Preparation: save last search, and cursor position.
  let _s = @/
  let l = line(".")
  let c = col(".")

  execute a:command

  " Clean up: restore previous search history, and cursor position
  let @/ = _s
  call cursor(l, c)
endfunction

fun! SetFonts()
  if has('gui_gnome') && executable('gconftool')
    let gconf_path = '/desktop/gnome/interface/monospace_font_name'
    let gconf_font = system('gconftool --get ' . gconf_path)
    let &guifont = substitute(gconf_font, '\n', '', '')
  elseif has('gui_gtk2')
    let &guifont = g:gtkfont . ' ' . g:fontsize
  else
    let fontstrings = []
    for font in g:fonts
      if has('macunix') && has('gui')
        let fontstrings += [font . ':h' . g:fontsize]
      elseif has('gui_win32')
        let fontstrings += [font . ':h' . g:fontsize . 'cANSI']
      endif
    endfor
    let &guifont = join(fontstrings, ',')
  endif
endfun

fun! StatusLine_Tlist_Info()
  if exists('g:loaded_taglist') &&
        \ g:loaded_taglist == 'available'
    return Tlist_Get_Tagname_By_Line()
  else
    return ''
  endif
endfun

fun! StatusLine_FileName()
  try
    let fn = pathshorten(expand('%f')) . ' '
  catch
    let fn = expand('%f') . ' '
  endtry
  return fn
endfun

fun! StatusLine_GitBranch()
  if exists('g:loaded_fugitive')
    return fugitive#statusline()
  else
    return ''
  endif
endfun

fun! StatusLine_Pasting()
  if &paste
    return '[paste]'
  else
    return ''
  endif
endfun

" Keymaps and Commands {{{1
let mapleader = ","
let maplocalleader = ","

nmap <leader>del :g/^\s*$/d<CR>      " Delete Empty Lines
nmap <leader>ddql :%s/^>\s*>.*//<CR> " Delete Double Quoted Lines
nmap <leader>ddr :s/\.\+\s*/. /<CR>  " Delete Dot Runs
nmap <leader>dsr :s/\s\s\+/ /<CR>    " Delete Space Runs
nmap <leader>dtw :%s/\s\+$//<CR>     " Delete Trailing Whitespace

nmap <leader>l :set list!<CR>

" Reformat paragraph
noremap <Leader>gp gqap

" Reformat everything
noremap <Leader>gq gggqG

" Reindent everything
noremap <Leader>= gg=G

" Select everything
noremap <Leader>gg ggVG

" Pressing ,ss will toggle spell checking
nmap <leader>ss :set spell!<CR>

" Open a file in the same directory as the current file
nmap <leader>ew :e <C-R>=expand("%:p:h") . "/" <CR>
nmap <leader>es :sp <C-R>=expand("%:p:h") . "/" <CR>
nmap <leader>ev :vsp <C-R>=expand("%:p:h") . "/" <CR>
nmap <leader>et :tabe <C-R>=expand("%:p:h") . "/" <CR>

" quickfix things
nmap <Leader>cwc :cclose<CR>
nmap <Leader>cwo :botright copen 5<CR><C-w>p
nmap <Leader>ccn :cnext<CR>

" Arrow keys behavior
nmap <silent> <Up> :wincmd k<CR>
nmap <silent> <Down> :wincmd j<CR>
nmap <silent> <Left> :wincmd h<CR>
nmap <silent> <Right> :wincmd l<CR>

" Default to navigating by virtual lines, using the 'g' versions to move by
" physical lines
nnoremap k gk
nnoremap j gj
nnoremap gk k
nnoremap gj j

" Make 'Y' follow 'D' and 'C' conventions
nnoremap Y y$

" Select just-pasted text
nnoremap <leader>v V`]

" Ctrl+return to add a new line below the current line in insert mode
inoremap <c-cr> <esc>A<cr>

" Plugins
nmap <leader>im :Modeliner<CR>

nnoremap <Leader>s :TlistToggle<Enter>
nnoremap <Leader>S :TlistShowPrototype<Enter>

nnoremap <Leader>f :ToggleNERDTree<Enter>
nnoremap <Leader>F :NERDTreeFind<Enter>

nnoremap <silent> <Leader>yr :YRGetElem<CR>

" When selecting with the mouse, copy to clipboard on release.
vnoremap <LeftRelease> '+y<LeftRelease>gv
vnoremap <RightRelease> '+y<RightRelease>gv

" Execute an appropriate interpreter for the current file
" If there is no #! line at the top of the file, it will
" fall back to g:interp_<filetype>, and further to <filetype>.
fun! RunInterp()
  let l:interp = ''
  let line = getline(1)

  if line =~ '^#\!'
    let l:interp = strpart(line, 2)


  else
    if exists('g:interp_' . &filetype)
      let l:interp = g:interp_{&filetype}
    else
      let l_interp = &filetype
    endif
  endif
  if l:interp != ''
    exe '! ' . l:interp . ' %'
  endif
endfun
nnoremap <silent> <F9> :call RunInterp()<CR>
com! -complete=command Interp call RunInterp()

" Diff the current file contents against last saved
com! DiffOrig bel new | set bt=nofile | r # | 0d_ | diffthis
      \ | wincmd p | diffthis

" Change the current directory to the location of the
" file being edited.
com! -nargs=0 -complete=command Bcd lcd %:p:h

com! -bar -nargs=0 SudoWrite
      \ | :silent exe "write !sudo tee % >/dev/null" | silent edit!

command! -nargs=+ Grep execute 'silent grep! <args>' | redraw!
command! -nargs=0 LocalTags let g:easytags_file = './.tags' | HighlightTags
" }}}

" Settings {{{1
filetype plugin indent on

set secure
" Not vi compatible, we want spiffy Vim features, please.
if &compatible
    set nocompatible
endif
set nodigraph

" Don't manually sync the swap to disk on unix, since that's periodically done
" for us, so the risk of losing data is relatively small, and this should
" improve performance slightly.
if has('unix')
  set swapsync=
endif

" Reliant upon securemodelines.vim
set nomodeline
set modelines=5

" Fast terminal, bump sidescroll to 1
set sidescroll=1

" Show 2 rows/cols of context when scrolling
set scrolloff=2
set sidescrolloff=2

if has('mouse')
  set mouse=a
  if has('unix') &&
        \ ! has('gui_running')
    if &term == 'xterm'
      set ttymouse=xterm2
    else
      set ttymouse=xterm
    endif
  endif
endif

" Line numbering
if v:version >= 700
  set number
endif

" Don't use old weak encryption for Vim 7.3
if has('cryptv')
  try
    set cryptmethod=blowfish
  catch
  endtry
endif

" Allow setting window title for screen
if &term =~ '^screen'
  set t_ts=k
  set t_fs=\
endif

" Nice window title
set title
if has('title') && (has('gui_running') || &title)
  set titlestring=
  set titlestring+=%f                    " file name
  set titlestring+=%(\ %h%m%r%w%)        " flags
  set titlestring+=\ -\ %{v:progname}    " program name
endif
set titleold=

set ttyfast
set ttybuiltin
set lazyredraw

" Window resize behavior when splitting
set noequalalways
set eadirection=both

set splitright
set splitbelow

" No annoying beeps
set novisualbell
set noerrorbells
set vb t_vb=

set virtualedit+=block

" Indentation {{{2
set smarttab

" Disable insertion of tabs as compression / indentation
set expandtab

" How many spaces a hard tab in the file is shown as, and how many
" spaces are replaced with one hard tab when using sts != ts and noet.
set tabstop=8

" Indentation width (affects indentation plugins, indent based
" folding, etc, and when smarttab is on, is used instead of ts/sts
" for the indentation at beginning of line.
set shiftwidth=4

" Number of spaces that the tab key counts for when editing
" Only really useful if different from ts, or if using et.
" When 0, it is disabled.
set softtabstop=4

" Round indent to a multiple of 'shiftwidth'
set shiftround

set autoindent
set copyindent
set preserveindent
set nosmartindent

" Set the C indenting the way I like it
set cinoptions=>s,e0,n0,f0,{0,}0,^0,:s,=s,l0,g0,hs,ps,ts,+s,c3,C0,(0,us,\U0,w0,m0,j0,)20,*30
set cinkeys=0{,0},0),:,0#,!^F,o,O,e
" }}}2

" Default folding settings
if has('folding')
  set foldenable
  set foldcolumn=0
  set foldminlines=3
  set foldmethod=indent
  set foldlevel=5
endif

if has('conceal')
  set conceallevel=2
endif

" Cscope
if has("cscope")
  set csto=0
  set cst
  set nocsverb
  " add any database in current directory
  if filereadable("cscope.out")
    cs add cscope.out
    " else add database pointed to by environment
  elseif $CSCOPE_DB != ""
    cs add $CSCOPE_DB
  endif
  set csverb
endif

" Tags search path
set tags=./tags,tags,./.tags,.tags

" Nifty completion menu
set wildmenu
set wildignore+=*.o,*~,*.swp,*.bak,*.pyc,*.pyo

set wildmode=longest,list

set suffixes+=.in,.a,.lo,.o,.moc,.la,.closure

set whichwrap=<,>,h,l,[,]
set ruler
set showcmd
set textwidth=0

" Write backup files and do not remove them after exit.
set backup
set writebackup

" Rename the file to the backup when possible.
set backupcopy=auto

" Don't store all the backup and swap files in the current working dirctory.
set backupdir=~/.vim/tmp/backup
set directory=~/.vim/tmp/swap

" Persistent undo
if has('persistent_undo')
  set undofile
  set undodir=~/.vim/tmp/undo
endif

set pastetoggle=<Leader>P

set isk+=_,$,@,%,#,-
set shortmess=atItToO

set display+=lastline

" Buffer switching behaviors
" useopen   If included, jump to the first open window that
"           contains the specified buffer (if there is one).
" split     If included, split the current window before loading a buffer
set switchbuf+=useopen
" set switchbuf+=split

" Longer commandline and search history
if has('cmdline_hist')
  set history=500
endif

" Many levels of undo
set undolevels=500

" Viminfo file behavior
if has('viminfo')
  " f1  store file marks
  " '   # of previously edited files to remember marks for
  " :   # of lines of command history
  " /   # of lines of search pattern history
  " <   max # of lines for each register to be saved
  " s   max # of Kb for each register to be saved
  " h   don't restore hlsearch behavior
  let &viminfo = "f1,'1000,:1000,/1000,<1000,s100,h,r" . $TEMP
endif

" Only save the current tab page
set sessionoptions-=tabpages

" Don't save help windows
set sessionoptions-=help

set backspace=indent,eol,start
set noshowmatch
set nojoinspaces
set formatoptions=crqn
if executable('par')
  let &formatprg = 'par ' . &textwidth . 're'
endif

" Default to replace all in :s
set gdefault

" Case insensitivity
set ignorecase
set smartcase
set infercase

" No incremental searches or search highlighting
set noincsearch
set nohlsearch

" Syntax for printing
set popt+=syntax:y
set popt+=number:y
set popt+=paper:letter
set popt+=left:5pc

" Automatically write buffers on switch/make/exit
set nohidden
set autowrite
set autowriteall

" Allow editing of all types of files
if has('unix')
  set fileformats=unix,dos,mac
elseif has('mac')
  set fileformats=mac,unix,dos
else
  set fileformats=dos,unix,mac
endif

if has('gui_running')
  if has('vim_starting')
    set lines=50
    set columns=112
  endif

  " Hide the mouse cursor while typing
  set mh

  " Automatically activate the window the mouse pointer is on
  set mousef

  set go=Acgae

  " Prompt for confirmation where appropriate, rather than failing
  set confirm

  try
    set fuoptions=maxvert,maxhorz
  catch
  endtry
endif

" Make operations like yank, which normally use the unnamed register, use the
" * register instead (yanks go to the system clipboard).
set clipboard=autoselect,unnamed
if has('gui_running') && has('unix')
  set clipboard+=exclude:cons\|linux
end

" Wrap at column 78
set tw=78

" Keep cursor in the same column if possible (see help).
set nostartofline

" Ignore binary files matched with grep by default
set grepformat=%f:%l:%m,%f:%l%m,%f\ \ %l%m,%-OBinary\ file%.%#

" Use ack if available
if executable('ack')
  set grepprg=ack\ -H\ --nocolor\ --nogroup\ --column\ $*\ /dev/null
  set grepformat=%f:%l:%c:%m
elseif executable('ack-grep')
  set grepprg=ack-grep\ -H\ --nocolor\ --nogroup\ --column\ $*\ /dev/null
  set grepformat=%f:%l:%c:%m
endif

" Show the Vim7 tab line only when there is more than one tab page.
" See :he tab-pages for details.
try
  set showtabline = 1
catch
endtry

" Status Line {{{
set laststatus=2
if has('statusline')
  set statusline=
  set statusline+=%-3.3n\                      " buffer number
  set statusline+=%(%{StatusLine_FileName()}\ %) " filename
  set statusline+=%h%m%r%w                     " status flags
  set statusline+=%{StatusLine_Pasting()}      " 'paste' option state
  set statusline+=%{StatusLine_GitBranch()}    " current git branch
  set statusline+=%((%{StatusLine_Tlist_Info()})\ %) " tag name

  set statusline+=%(\[%{&ft}]%)               " file type
  set statusline+=%=                          " right align remainder
  set statusline+=%-14(%l,%c%V%)              " line, character
  set statusline+=%<%P                        " file position
endif

if has('autocmd') && v:version >= 700
  " Special statusbar for special windows
  " NOTE: only Vim7+ supports a statusline local to a window
  augroup KergothStatusLines
    au!
    au VimEnter,BufWinEnter __Tag_List__
          \ setlocal statusline=\[Tags\] |
          \ setlocal statusline+=%= |
          \ setlocal statusline+=%l

    au VimEnter,BufWinEnter TreeExplorer
          \ let w:numberoverride = 1 |
          \ set nonumber
  augroup END
endif

augroup KergothIndentation
  au!
  au BufReadPost * if exists("loaded_detectindent") | exe "DetectIndent" | endif
augroup END

" Encoding {{{2
" Termencoding will reflect the current system locale, but internally,
" we use utf-8, and for files, we use whichever encoding from
" &fileencodings was detected for the file in question.
let &termencoding = &encoding
if has('multi_byte')
  set encoding=utf-8
  " fileencoding value is used for new files
  let &fileencoding = &encoding
  set fileencodings=ucs-bom,utf-8,default,latin1
  " set bomb
endif

" Most printers are Latin1, inform Vim so it can convert.
set printencoding=latin1

set dictionary+=/usr/share/dict/words

if v:version >= 700
  set spelllang=en_us
endif

set fillchars=vert:\|

" Show nonprintable characters like hard tabs
set nolist

if (&termencoding == 'utf-8') || has('gui_running')
  set showbreak=↪

  set listchars=tab:»·,extends:…,precedes:…,eol:¬

  if v:version >= 700
    set listchars+=nbsp:‗
  endif

  if (! has('gui_running')) && (&t_Co < 3)
    set listchars+=trail:·
  endif
else
  let &showbreak = '> '

  set listchars=tab:>-,extends:>

  if v:version >= 700
    set listchars+=nbsp:_
  endif

  if (! has('gui_running')) && (&t_Co < 3)
    set listchars+=trail:.
  endif
endif

" Colors {{{2
" Make sure the gui is initialized before setting up syntax and colors
if has('gui_running')
  gui
endif

if has('syntax')
  syntax enable
endif

" Inside of screen, we don't care about colorterm
if &term !~ '^screen'
  " Set colors to 16 for gnome-terminal and xfce4-terminal
  if ($COLORTERM == 'gnome-terminal') || ($COLORTERM == 'Terminal')
    set t_Co=16
  elseif ($COLORTERM == 'rxvt-xpm') && (&term == 'rxvt')
    " try to set colors correctly for mrxvt
    set t_Co=256
  elseif ($COLORTERM == 'putty')
    set t_Co=256
  endif
endif

if &t_Co > 2 || has('gui_running')
  if exists('g:colors_name')
      unlet g:colors_name
  endif
  set background=dark

  if has('gui')
    colo baycomb
  else
    colo zellner
  endif

  " Colors red both trailing whitespace:
  "  foo   
  "  bar	
  " And spaces before tabs:
  "  foo 	bar
  hi def link RedundantWhitespace Error
  match RedundantWhitespace /\s\+$\| \+\ze\t/

  " Highlighting of Vim modelines, and hiding of fold markers
  hi def link vimModeline Special
  hi def link foldMarker NonText

  " The default coloring of concealed items is terrible
  hi! def link Conceal SpecialKey

  if has('autocmd')
    augroup KergothMatches
      au!
      if has('conceal')
        au BufRead,BufNewFile *
              \ syn match foldMarker contains= contained conceal /{{{[1-9]\?\|}}}[1-9]\?/
      else
        au BufRead,BufNewFile *
              \ syn match foldMarker contains= contained /{{{[1-9]\?\|}}}[1-9]\?/
      endif
      au BufRead,BufNewFile * syn match vimModeline contains=@NoSpell contained /vim:\s*set[^:]\{-1,\}:/
    augroup END
  endif
endif

" Autocommands {{{1
if has('autocmd')
  augroup Kergoth
    au!

    au VimEnter * if empty(&guifont) | call SetFonts() | endif

    if has('persistent_undo')
      au BufReadPre .netrwhist set noundofile
      au BufReadPre $TEMP/* set noundofile
      au BufReadPre .git/COMMIT_EDITMSG set noundofile
    endif

    autocmd BufReadPost fugitive://* set bufhidden=delete

    " Reload file with the correct encoding if fenc was set in the modeline
    au BufReadPost * let b:reloadcheck = 1
    au BufWinEnter *
          \ if exists('b:reloadcheck') |
          \   if &mod != 0 && &fenc != '' |
          \     exe 'e! ++enc=' . &fenc |
          \   endif |
          \   unlet b:reloadcheck |
          \ endif

    " When editing a file, always jump to the last known cursor position.
    " Don't do it when the position is invalid or when inside an event handler
    " (happens when dropping a file on GVim).
    func! <SID>RestorePosition()
      if &ft == 'gitcommit'
        return
      endif

      if line("'\"") > 0 && line ("'\"") <= line('$')
        exe "normal g'\""
      endif
    endfun
    au BufReadPost * call <SID>RestorePosition()

    " Set the compiler to the filetype by default
    au FileType * try | exe 'compiler ' . &filetype | catch | endtry

    try
      " if we have a Vim which supports QuickFixCmdPost (Vim7),
      " give us an error window after running make, grep etc, but
      " only if results are available.
      au QuickFixCmdPost * botright cwindow 5
    catch
    endtry

    " Close out the quickfix window if it's the only open window
    fun! <SID>QuickFixClose()
      if &buftype == 'quickfix'
        " if this window is last on screen quit without warning
        if winbufnr(2) == -1
          quit!
        endif
      endif
    endfun
    au BufEnter * call <SID>QuickFixClose()

    " Special less.sh and man modes {{{
    fun! <SID>check_pager_mode()
      if exists('g:loaded_less') && g:loaded_less
        " we're in vimpager / less.sh / man mode
        set laststatus=0
        set ruler
        set foldmethod=manual
        set foldlevel=99
        set nolist
        " Make <space> in normal mode go down a page rather than left a
        " character
        noremap <space> <C-f>
      endif
    endfun
    au VimEnter * :call <SID>check_pager_mode()
    " }}}
  augroup END
endif

" Script options {{{1
let g:fullname = 'Chris Larson'
let g:email = 'clarson@kergoth.com'
" In order of preference, best to worst
let g:fonts = ['Consolas', 'Inconsolata', 'Menlo', 'DejaVu Sans Mono',
            \  'Monaco', 'Andale Mono', 'Courier']
let g:gtkfont = 'Inconsolata'
let g:fontsize = "11"

let g:print_syntax = 'github' " color scheme to use for printing

" If we don't have ctags, silently don't load easytags
for name in ['ctags', 'exuberant-ctags', 'exctags']
  if executable(name)
    let g:easytags_cmd = name
  endif
endfor
if !exists('g:easytags_cmd')
  let g:loaded_easytags = 1
endif

let g:doxygen_enhanced_color = 0
let g:loaded_AlignMapsPlugin = '1'
let g:pyflakes_use_quickfix = 0
let g:snips_author = g:fullname . ' <' . g:email . '>'
let g:NTPNames = ['build.xml', 'Makefile', '.project', '.lvimrc', 'SConstruct',
                \ 'CMakeLists.txt', 'setup.py', 'configure.ac', 'configure.in']
let g:session_autosave = 1
let g:session_autoload = 0
let g:ConqueTerm_InsertOnEnter = 1
let g:ConqueTerm_CWInsert = 1
let g:ConqueTerm_Color = 0
let g:ConqueTerm_ReadUnfocused = 1
let g:ConqueTerm_CloseOnEnd = 1
if has('file_in_path')
  let miscdir = finddir("misc", &runtimepath)
  if miscdir
    let g:lua_inspect_path = miscdir
  endif
endif
if !has('lua') && !executable('lua')
  let g:loaded_luainspect = 1
endif
let g:SuperTabDefaultCompletionType = 'context'
let g:CSApprox_verbose_level = 0
let g:pylint_onwrite = 0
let g:syntastic_disabled_filetypes = ['python']
let g:syntastic_enable_signs=1
let g:syntastic_auto_loc_list=1
let g:detectindent_preferred_expandtab = 1
let g:detectindent_preferred_indent = 4
let g:LargeFile = 10
let g:secure_modelines_verbose = 1
let g:secure_modelines_allowed_items = [
            \ "textwidth",    "tw",
            \ "softtabstop",  "sts",
            \ "tabstop",      "ts",
            \ "shiftwidth",   "sw",
            \ "expandtab",    "et",   "noexpandtab", "noet",
            \ "filetype",     "ft",
            \ "fileencoding", "fenc",
            \ "foldmethod",   "fdm",
            \ "foldlevel",    "fdl",
            \ "readonly",     "ro",   "noreadonly", "noro",
            \ "rightleft",    "rl",   "norightleft", "norl",
            \ "wrap", "nowrap",
            \ ]
let g:NERDCommentWholeLinesInVMode = 1
let g:NERDTreeQuitOnOpen = 1
let g:Modeliner_format = 'fenc= sts= sw= ts= et'

let g:Tlist_Ctags_Cmd = 'ctags'
let g:Tlist_Exit_OnlyWindow = 1
let g:Tlist_Show_Menu = 0
let g:Tlist_Enable_Fold_Column = 0
let g:Tlist_WinWidth = 28
let g:Tlist_Compact_Format = 1
let g:Tlist_File_Fold_Auto_Close = 1
let g:Tlist_Use_Right_Window = 1
let g:Tlist_Sort_Type = 'order'
let g:Tlist_Close_On_Select = 0
if has('gui_running')
  let g:Tlist_Inc_Winwidth = 1
else
  let g:Tlist_Inc_Winwidth = 0
endif

let g:bufExplorerDefaultHelp = 0
let g:bufExplorerSortBy = 'mru'
let g:bufExplorerSplitType = 'v'
let g:bufExplorerOpenMode = 1

" Per machine vim settings {{{1
if !exists('$HOSTNAME') && executable('hostname')
  let $HOSTNAME = substitute(system('hostname'), "\n", "", "")
endif

augroup VimrcReload
  au!
  au BufWritePost vimrc source %
  au BufWritePost vimrc.$HOSTNAME source %
augroup END
runtime vimrc.$HOSTNAME
