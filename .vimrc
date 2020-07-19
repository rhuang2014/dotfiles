" vim: et sw=4 ts=4
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" install tools needed by plugins
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" ycm-core/YouCompleteMe
if has("unix")
    let s:uname = system("uname -s")
    if s:uname == "Linux\n"
        if empty(glob('/usr/bin/cmake'))
            silent !sudo apt -y install build-essential cmake vim vim-nox python3-dev exuberant-ctags python3-venv
        endif
    endif
    if s:uname == "Darwin\n"
        if empty(glob('/usr/local/bin/cmake'))
            silent !brew install cmake
        endif
    endif
endif
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" vim-plug setup
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Auto installing vim-plug - A minimalist Vim plugin manager.
if empty(glob('~/.vim/autoload/plug.vim'))
    silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
      \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall | source ~/.vimrc
endif

" Make sure you use single quotes
let g:plug_timeout = 1000
call plug#begin('~/.vim/bundle')

" A Vim plugin which shows a git diff in the 'gutter' (sign column).
Plug 'airblade/vim-gitgutter'
let g:gitgutter_max_signs = 500  " default value
" don't want vim-gitgutter to set up any mappings at all
let g:gitgutter_map_keys = 0

" Themes and colors
Plug 'altercation/vim-colors-solarized'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

"Plug 'alvan/vim-closetag'
"Plug 'elzr/vim-json'

" Track the engine.
Plug 'SirVer/ultisnips'
" Snippets are separated from the engine. Add this if you want them:
Plug 'honza/vim-snippets'
" Trigger configuration. Do not use <tab> if you use https://github.com/Valloric/YouCompleteMe.
let g:UltiSnipsExpandTrigger = "<c-s>"
let g:UltiSnipsJumpForwardTrigger = "<c-b>"
let g:UltiSnipsJumpBackwardTrigger = "<c-z>"
" brew install vim --with-python3 --with-lua
" for this plugin to work properly
let g:UltiSnipsUsePythonVersion = 3
" If you want :UltiSnipsEdit to split your window.
let g:UltiSnipsEditSplit = "vertical"

" Perform all your vim insert mode completions with Tab
Plug 'ervandew/supertab'

function! BuildYCM(info)
  " info is a dictionary with 3 fields
  " - name:   name of the plugin
  " - status: 'installed', 'updated', or 'unchanged'
  " - force:  set on PlugInstall! or PlugUpdate!
  " install.py
  " - Compiling YCM with semantic support for C-family languages through libclang:
  " - ./install.py --clang-completer
  " - Compiling YCM with semantic support for C-family languages through clangd:
  " - ./install.py --clangd-completer
  if a:info.status == 'installed' || a:info.force
    !./install.py --clangd-completer
  endif
endfunction
" sudo apt -y install build-essential cmake vim vim-nox python3-dev exuberant-ctags python3-venv
Plug 'ycm-core/YouCompleteMe', { 'do': function('BuildYCM') }
let g:ycm_autoclose_previw_window_after_insertion = 1
"Special instructions: When YCM updates, it often needs a recompile
"By default, that is done by running ~/.vim/bundle/YouCompleteMe/install.sh

" Check syntax (linting) and fix files asynchronously
Plug 'w0rp/ale'
" ALE requires NeoVim >= 0.2.0 or Vim 8 with +timers +job +channel

" Jsonnet filetype plugin for Vim
Plug 'google/vim-jsonnet'

" Plugin outside ~/.vim/plugged with post-update hook
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --bin --no-update-rc --no-bash --no-fish' }
Plug 'junegunn/fzf.vim'

"Plug 'junegunn/vim-easy-align'
" Start interactive EasyAlign in visual mode (e.g. vipga)
"xmap ga <Plug>(EasyAlign)
" Start interactive EasyAlign for a motion/text object (e.g. gaip)
"nmap ga <Plug>(EasyAlign)

Plug 'luochen1990/rainbow'
let g:rainbow_active = 1 "0 if you want to enable it later via :RainbowToggle
" https://github.com/luochen1990/rainbow#configure
let g:rainbow_conf = { 'separately': { '*': {} }}

"Plug 'nathanaelkane/vim-indent-guides'
"let g:indent_guides_enable_on_vim_startup = 1

" Defaults everyone can agree on
Plug 'tpope/vim-sensible'

Plug 'tpope/vim-commentary'
autocmd FileType apache setlocal commentstring=#\ %s
" Use gcc to comment out a line (takes a count)
" gcap to comment out a paragraph
" gc in visual mode to comment out the selection

" wisely add "end" in ruby, endfunction/endif/more in vim script, etc
Plug 'tpope/vim-endwise'

"Plug 'tpope/vim-fugitive'
"Plug 'tpope/vim-git'
"Plug 'tpope/vim-rails'
"Plug 'tpope/vim-rake'
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'

" Vim plugins for chef (syntax highliting and autocomplete snipmate)
Plug 'vadv/vim-chef'

" Perl-related syntax and helper files for Perl 5
"Plug 'vim-perl/vim-perl', { 'for': 'perl', 'do': 'make clean carp dancer highlight-all-pragmas moose test-more try-tiny' }

"Plug 'vim-ruby/vim-ruby'
"Plug 'vim-scripts/taglist.vim'

" Full path fuzzy file, buffer, mru, tag, ... finder for Vim
Plug 'ctrlpvim/ctrlp.vim'
let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'
let g:ctrlp_working_path_mode = 'ra'
" 'c' - the directory of the current file.
" 'a' - the directory of the current file, unless it is a subdirectory of the cwd
" 'r' - the nearest ancestor of the current file that contains one of these directories or files: .git .hg .svn .bzr _darcs
" 'w' - modifier to 'r': start search from the cwd instead of the current file's directory
" 0 or '' (empty string) - disable this feature.

" Markdown Vim Mode
Plug 'godlygeek/tabular' | Plug 'plasticboy/vim-markdown'
let g:vim_markdown_folding_disabled = 1
let g:vim_markdown_toc_autofit = 1
let g:vim_markdown_fenced_languages = ['csharp=cs', 'c++=cpp', 'viml=vim', 'bash=sh', 'ini=dosini']
" This will cause the following to be highlighted using the cs filetype syntax.
" Default is ['c++=cpp', 'viml=vim', 'bash=sh', 'ini=dosini']
let g:vim_markdown_json_frontmatter = 1

"Plug 'morhetz/gruvbox'

" https://feici02.github.io/2017/07/20/pep8.html
"Plug 'tell-k/vim-autopep8'
"let g:autopep8_on_save = 1
"Plug 'chiel92/vim-autoformat'
"Plug 'google/yapf'

" https://w.wol.ph/2015/02/17/checking-python-version-vim-version-vimrc/
" Check python3 version if available
"if has("python3")
"    python3 import vim; from sys import version_info as v; vim.command('let python3_version=%d' % (v[0] * 100 + v[1]))
"else
"    let python3_version=0
"endif
"if python3_version >= 360
"    Plug 'psf/black', { 'branch': 'master' }
"endif
"if has("python3")
"    Plug 'psf/black', { 'branch': 'master' }
"endif

" Add plugins to &runtimepath
call plug#end()

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" General
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
filetype off " detect the type of file
filetype plugin indent on " load filetype, indent plugins
filetype indent on " Enable filetype-specific indenting
set nocompatible " get out of horrible vi-compatible mode
set history=1000 " How many lines of history to remember
set cf " enable error files and error jumping
"set clipboard+=unnamed " turns out I do like is sharing windows clipboard
set clipboard=
set ffs=unix,mac,dos " support all three, in this order
set viminfo+=! " make sure it can save viminfo
set isk+=_,$,@,%,#,- " none of these should be word dividers, so make them not be
set autoread " auto read when a file is changed from the outside
set noswapfile " turn off backups and files
set nobackup " don't keep a backup file
set magic " special characters that can be used in search patterns
set timeoutlen=450 ttimeoutlen=0  " Time to wait after ESC (default causes an annoying delay)
" The length of time Vim waits after you stop typing before it triggers the
" plugin is governed by the setting updatetime. This defaults to 4000
" milliseconds which is rather too long.
" http://www.polarhome.com/vim/manual/v57/options.html#'timeoutlen'
set updatetime=750
set number " add line numbering
setglobal modeline " auto set options for vim on file edit
setglobal modelines=2 " the first or last 2 line are check for modeline
set noshowmode " disable the -- INSERT -- mode line since it's showing on the status bar

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Code folding
" you can toggle folding with za. You can fold everything with zM and unfold
" everything with zR. zm and zr can be used to get those folds just right.
" Always remember the almighty help file at “help :folding” if you get stuck.
"
"     Vim folding commands
"     ---------------------------------
"     zf#j creates a fold from the cursor down # lines.
"     zf/ string creates a fold from the cursor to string .
"     zj moves the cursor to the next fold.
"     zk moves the cursor to the previous fold.
"     za toggle a fold at the cursor.
"     zo opens a fold at the cursor.
"     zO opens all folds at the cursor.
"     zc closes a fold under cursor.
"     zm increases the foldlevel by one.
"     zM closes all open folds.
"     zr decreases the foldlevel by one.
"     zR decreases the foldlevel to zero -- all folds will be open.
"     zd deletes the fold at the cursor.
"     zE deletes all folds.
"     [z move to start of open fold.
"     ]z move to end of open fold.
"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set foldmethod=indent " fold based on indent
set foldnestmax=10 " deepest fold is 10 levels
set nofoldenable " dont fold by default
set foldlevel=2 " level to fold

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" status/tabline
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set statusline=%F%m%r%h%w\ [FORMAT=%{&ff}]\ [TYPE=%Y]\ [ASCII=\%03.3b]\ [HEX=\%02.2B]\ [POS=%04l,%04v][%p%%]\ [LEN=%L]
set laststatus=2 " always show the status line

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Theme/Colors
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set t_Co=265 " To enable 256 colors in vim
let g:solarized_termcolors=256
let g:solarized_base16 = 1
let g:airline_theme='solarized'
if !empty(glob('~/.vim/bundle/vim-colors-solarized/colors/solarized.vim'))
    syntax enable
    set background=dark
    colorscheme solarized
endif

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Rainbow Parentheses Improved section
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"colorscheme dracula
let g:rainbow_active=1

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Vim UI
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set lsp=0 " space it out a little more (easier to read)
set wildmenu " turn on wild menu
set ruler " Always show current positions along the bottom
set cmdheight=2 " the command bar is 2 high
"set number " turn on line numbers
set lz " do not redraw while running macros (much faster) (LazyRedraw)
set hid " you can change buffer without saving
"set backspace=2 " make backspace work normal
set backspace=indent,eol,start " more powerful backspacing
set whichwrap+=<,>,h,l  " backspace and cursor keys wrap to
"set mouse=a " use mouse everywhere
set shortmess=atI " shortens messages to avoid 'press a key' prompt
set report=0 " tell us when anything is changed via :...
set noerrorbells " don't make noise make the splitters between windows be blank
set fillchars=vert:\ ,stl:\ ,stlnc:\

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Visual Cues
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set showmatch " show matching brackets
set mat=5 " how many tenths of a second to blink matching brackets for
"set nohlsearch " do not highlight searched for phrases
set hlsearch " hightlight all search matches
set incsearch " BUT do highlight as you type you search phrase
set listchars=tab:\|\ ,trail:.,extends:>,precedes:<,eol:$ " what to show when I hit :set list
"set lines=80 " 80 lines tall
"set columns=160 " 160 cols wide
set so=10 " Keep 10 lines (top/bottom) for scope
set novisualbell " don't blink
set noerrorbells " no noises

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Text Formatting/Layout
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set fo=tcrqn " See Help (complex)
set ai " autoindent
set et " expandtab, converted to an equivalent number of spaces
set si " smartindent
set cindent " do c-style indenting
set tabstop=4 " tab spacing (settings below are just to unify it)
set softtabstop=4 " unify
set shiftwidth=4 " unify
"set noexpandtab " real tabs please!
set nowrap " do not wrap lines
"set smarttab " use tabs at the start of a line, spaces elsewhere
set encoding=utf-8 " set default-encoding to utf-8
" reformat text paragraphs or chunks of code
" Options to change how automatic formatting is done:
" :set formatoptions (default "tcq")
"   t - textwidth
"   c - comments (plus leader -- see :help comments)
"   q - allogw 'gq' to work
"   n - numbered lists
"   2 - keep second line indent
"   1 - single letter words on next line
"   r - (in mail) comment leader after

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Syntastic section
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" user call :SyntasticCheck inside vim to perform syntastic check of current
" file
" exclude rules in config file
"let g:syntastic_sh_shellcheck_args="-e SC2059,SC2148"

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Indent Guides section
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" let g:indent_guides_auto_colors = 0
" autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd  guibg=red   ctermbg=3
" autocmd VimEnter,Colorscheme * :hi IndentGuidesEven guibg=green ctermbg=4

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Python section
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let python_highlight_all = 1
au FileType python syn keyword pythonDecorator True None False self

au BufNewFile,BufRead *.jinja set syntax=htmljinja
au BufNewFile,BufRead *.mako set ft=mako

au FileType python inoremap <buffer> $r return
au FileType python inoremap <buffer> $i import
au FileType python inoremap <buffer> $p print
au FileType python inoremap <buffer> $f #--- PH ----------------------------------------------<esc>FP2xi
au FileType python map <buffer> <leader>1 /class
au FileType python map <buffer> <leader>2 /def
au FileType python map <buffer> <leader>C ?class
au FileType python map <buffer> <leader>D ?def

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" PHP section
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! PhpSyntaxOverride()
  hi! def link phpDocTags  phpDefine
  hi! def link phpDocParam phpType
endfunction

augroup phpSyntaxOverride
  autocmd!
  autocmd FileType php call PhpSyntaxOverride()
augroup END

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" JavaScript section
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
au FileType javascript call JavaScriptFold()
au FileType javascript setl fen
au FileType javascript setl nocindent

au FileType javascript imap <c-t> AJS.log();<esc>hi
au FileType javascript imap <c-a> alert();<esc>hi

au FileType javascript inoremap <buffer> $r return
au FileType javascript inoremap <buffer> $f //--- PH ----------------------------------------------<esc>FP2xi

function! JavaScriptFold()
    setl foldmethod=syntax
    setl foldlevelstart=1
    syn region foldBraces start=/{/ end=/}/ transparent fold keepend extend

    function! FoldText()
        return substitute(getline(v:foldstart), '{.*', '{...}', '')
    endfunction
    setl foldtext=FoldText()
endfunction

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Taglist section
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let Tlist_Use_Right_Window=1
let Tlist_Auto_Open=0
let Tlist_Enable_Fold_Column=0
let Tlist_Compact_Format=0
let Tlist_WinWidth=28
let Tlist_Exit_OnlyWindow=1
let Tlist_File_Fold_Auto_Close = 1
nmap <LocalLeader>tt :Tlist<cr>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Editing mappings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Delete trailing white space, useful for Python
func! DeleteTrailingWS()
    exe "normal mz"
    %s/\s\+$//ge
    exe "normal `z"
endfunc
autocmd BufWrite *.py :call DeleteTrailingWS()

" automatically remove trailing whitespace when saving a file and keep cursor
" position
func! <SID>StripTrailingWhitespaces()
    let l = line(".")
    let c = col(".")
    %s/\s\+$//e
    call cursor(l, c)
endfunc
" Using file extension
autocmd BufWritePre *.h,*.c,*.java :call <SID>StripTrailingWhitespaces()
" Often files are not necessarily identified by extension, if so use e.g.:
"autocmd BufWritePre * if &ft =~ 'sh\|perl\|python' | :call <SID>StripTrailingWhitespaces() | endif
" Or if you want it to be called when file-type i set
"autocmd FileType sh,perl,python  :call <SID>StripTrailingWhitespaces()
" do it for all file
"autocmd BufWritePre * :call <SID>StripTrailingWhitespaces()
com! StripTrailingWhitespaces :call <SID>StripTrailingWhitespaces()

" delete all spaces in a file
com! DeleteAllSpaces %s/\(\S\) \+\(\S\)/\1\2/g

" Format JSON
com! FormatJSON %!python -m json.tool

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Autocommands
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
autocmd BufEnter * :syntax sync fromstart " ensure every file does syntax highlighting (full)
" for Makefiles
" added some special formatting in Makefiles
autocmd BufEnter ?akefile* set noet ts=8 sw=8 nocindent list lcs=tab:>-,trail:x
" for source code
autocmd BufEnter *.cpp,*.h,*.c,*.java,*.pl set et ts=4 sw=4 cindent
autocmd BufEnter *.lua set et ts=4 sw=4 nocindent
" for html
autocmd BufEnter *.html,*htm set et ts=4 sw=4 wm=8 nocindent
" for ruby
autocmd BufEnter *.rb set et tabstop=2 shiftwidth=2 softtabstop=2 autoindent
" email format
"autocmd BufEnter * set noet ts=4 sw=4 nocindent noai nosi nosmarttab
" There's no built-in way to prevent .netrwhist generation at the current
" time.  However, you could delete the file immediately after it was
" generated.
autocmd VimLeave * if filereadable("${HOME}/.vim/.netrwhist")|call delete("${HOME}/.vim/.netrwhist")|endif
" CloseTag
"autocmd FileType html,htmldjango,jinjahtml,eruby,mako let b:closetag_html_style=1
"autocmd FileType html,xhtml,xml,htmldjango,jinjahtml,eruby,mako source ~/.vim/bundle/closetag.vim/plugin/closetag.vim
autocmd FileType ruby compiler ruby
autocmd FileType make setlocal noexpandtab
" add yaml stuffs
au! BufNewFile,BufReadPost *.{yaml,yml} set filetype=yaml foldmethod=indent
autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab
" override ba(sh) script with zsh syntax
autocmd FileType sh setlocal syntax=zsh
" To run Black on save
"autocmd BufWritePre *.py execute ':Black'
" http://vim.wikia.com/wiki/Forcing_Syntax_Coloring_for_files_with_odd_extensions
" override a previous filetype detection, but only set a filetype if the
" filetype was not detected at all:
"augroup filetypedetect
"    au BufRead,BufNewFile *.foo setfiletype php
"    " associate *.foo with php filetype
"augroup END

" override any filetype which was already detected
