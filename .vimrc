" .vimrc of NONVME
" Overview
" ========
"
" This .vimrc is made for neovim It requires:
" pip install
"
" Before installing necessary packages, set up your default python installation to a python 3.8, and set your
" PYTHONPATH to point to this python installation.
"
" If some plugin functionality is not working, make sure that you have installed the corresponding packages globally.
"
" Note:
" A lot of plugins are commented out so that I remember what I have decided to not use per default.


if (has("termguicolors"))
  set termguicolors
endif

if has('nvim')
    set inccommand=nosplit
    set guicursor+=a:-blinkwait175-blinkoff150-blinkon175 " Возвращяем мигание курсора
else
    "CLI Specific
    "Change cursor shape in different modes
    if has("autocmd")
      au VimEnter,InsertLeave * silent execute '!echo -ne "\e[1 q"' | redraw!
      au InsertEnter,InsertChange *
        \ if v:insertmode == 'i' |
        \   silent execute '!echo -ne "\e[5 q"' | redraw! |
        \ elseif v:insertmode == 'r' |
        \   silent execute '!echo -ne "\e[3 q"' | redraw! |
        \ endif
      au VimLeave * silent execute '!echo -ne "\e[ q"' | redraw!
    endif
endif

"-----------
"Поиск
"-----------
set hlsearch "Подсветка найденного
set incsearch " перемещение курсора уже во время набора строки поиска
set ignorecase " игнорирование регистра при поиске
set smartcase " но только если сама строка поиска в нижнем регистре

"-----------
"Мыш
"-----------
set mousehide  "прятать курсор мыши при наборе текста
set mouse=a "Включение скролла мыши
nmap <silent> // :nohlsearch<CR> " '//' выключает подсветку поиска

"-----------
"История
"-----------
set nobackup " выключение вимовских бэкапов
set nowb
set noswapfile
set viminfo="" "Отключить сохранение истории
" Allow saving of files as sudo when I forgot to start vim using sudo.
" :w !sudo tee %
cmap w!! w !sudo tee > /dev/null %

"-----------
"Функционал
"-----------
" замена табов пробелами
" Или https://github.com/Vimjas/vim-python-pep8-indent
set expandtab
set tabstop=4
set shiftwidth=4
set softtabstop=4

au BufNewFile,BufRead *.py
    \ set tabstop=4 |
    \ set softtabstop=4 |
    \ set shiftwidth=4 |
    \ set textwidth=79 |
    \ set expandtab |
    \ set autoindent |
    \ set fileformat=unix

au BufNewFile,BufRead *.js, *.html, *.css
    \ set tabstop=2 |
    \ set softtabstop=2 |
    \ set shiftwidth=2
"Backspase  в режиме вставки
set backspace=eol,start,indent
set complete-=i
"Меню в строке статуса по Tab
set completeopt=longest,menu,preview
set wildmenu                    " Show menu instead of auto-complete
set wildmode=list:longest,full  " command <Tab> completion: list
                                " all.


" Copy to clipboard
set clipboard=unnamedplus
imap <ESC>"+pa <ESC>"+pa
vmap <C-c> "+y
" Удаление текста без потери буфера
nnoremap x "_x
nnoremap X "_X
nnoremap d "_d
nnoremap D "_D
vnoremap d "_d

if has('unnamedplus')
  set clipboard=unnamed,unnamedplus
  nnoremap <leader>d "+d
  nnoremap <leader>D "+D
  vnoremap <leader>d "+d
else
  set clipboard=unnamed
  nnoremap <leader>d "*d
  nnoremap <leader>D "*D
  vnoremap <leader>d "*d
endif

"-----------
"Прочее
"-----------
"set foldmethod=indent "автоматом сворачивает функции кода za
set scrolloff=3 " Оставлять 3 строки при скролле
set showcmd
set ttyfast
set lazyredraw
set timeoutlen=200 ttimeoutlen=0 "Убираем задержку переключения режимов
set number "Номера строк
filetype plugin indent on "Автоматическое определение типов файлов
set secure "Заперещает внешним .vimrc писать и выполнять
let skip_defaults_vim=1 "Отключить чтение дефолтного файла конфига
set langmap=ФИСВУАПРШОЛДЬТЩЗЙКЫЕГМЦЧНЯ;ABCDEFGHIJKLMNOPQRSTUVWXYZ,фисвуапршолдьтщзйкыегмцчня;abcdefghijklmnopqrstuvwxyz
set wrap linebreak nolist "Перенос строк по словам
set encoding=utf-8 "Ставит кодировку UTF-8
syntax enable "Включает подсветку синтаксиса
set helplang=ru,en "help Vim version 6.3. Последнее изменение: 2004 May 04

" Горячие клавиши -->
" Ускоренное передвижение по тексту
    nmap <C-H> 10h
    nmap <C-J> 10j
    nmap <C-K> 10k
    nmap <C-L> 10l

    vmap <C-H> 10h
    vmap <C-J> 10j
    vmap <C-K> 10k
    vmap <C-L> 10l
    vmap <C-f> <pagedown>zz
    vmap <C-b> <pageup>zz
" Клавиши быстрого редактирования строки в режиме вставки
" и в режиме редактирования командной строки.
    imap <C-H> <Left>
    imap <C-J> <UP>
    imap <C-K> <Down>
    imap <C-L> <Right>
    imap <C-f> <pagedown><Esc>zzi
    imap <C-b> <pageup><Esc>zzi
" и в режиме редактирования командной строки.
    cmap <C-H> <Left>
    cmap <C-L> <Right>

"-----------
"Плагины
"-----------
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/bundle')
Plug 'arcticicestudio/nord-vim'
Plug '907th/vim-auto-save'
Plug 'vim-airline/vim-airline'
Plug 'ntpeters/vim-better-whitespace'
"Plug 'SirVer/ultisnips'
"Plug 'honza/vim-snippets'
Plug 'jiangmiao/auto-pairs'
Plug 'preservim/nerdcommenter'
Plug 'yuttie/comfortable-motion.vim'
Plug 'dense-analysis/ale' "Linter
if has('nvim')
    Plug 'numirias/semshi', {'do': ':UpdateRemotePlugins'} "Syntax highlighting
endif
Plug 'davidhalter/jedi-vim' "Python autocompletion
Plug 'majutsushi/tagbar'
Plug 'airblade/vim-gitgutter'
call plug#end()

"nord-vim
colorscheme nord
let g:nord_uniform_diff_background = 1
set cursorline                    "подсветка
hi clear CursorLine               "номера
hi cursorlinenr guifg=LightGray   "строки

"vim-airline
let g:airline_powerline_fonts = 1 "Включить поддержку Powerline шрифтов
let g:airline_section_z = "\ue0a1:%l/%L Col:%c" "Кастомная графа положения курсора
let g:Powerline_symbols='unicode'
let g:airline#extensions#hunks#enabled = 1 "GIT status
let g:airline#extensions#hunks#non_zero_only = 1 " Показывать GIT status если есть изминения
let g:airline#extensions#ale#enabled = 1
let g:airline#extensions#whitespace#enabled = 0
"let g:airline#extensions#ale#error_symbol = 'E222:'
"let g:airline#extensions#ale#warning_symbol = 'W111:'
"GITgutter
let g:gitgutter_enabled = 1

"Comfortable Motion Scrolling
let g:comfortable_motion_scroll_down_key = "j"
let g:comfortable_motion_scroll_up_key = "k"

"ALE
let g:ale_linters = {
      \   'python': ['flake8', 'pylint'],
      \}

"      \   'javascript': ['eslint'],

let g:ale_fixers = {
      \    'python': ['yapf'],
      \}

"For AutoComlete
set pumheight=15 " Кол-во строк в выподающем меню

"Tagbar
nmap <F8> :TagbarToggle<CR>
" autofocus on tagbar open
let g:tagbar_autofocus = 1

nmap <F9> :lopen<CR>
set wcm=<Tab>
menu Exec.Python    :!python % <CR>
menu Exec.bash      :!/bin/bash<CR>
menu Exec.Perl      :!perl % <CR>
menu Exec.Ruby      :!ruby % <CR>
map <F7> :emenu Exec.Python<Tab>
nmap <F10> :ALEFix<CR>
nmap <silent> <C-m> <Plug>(ale_next_wrap)

"NerdCommenter
nmap <C-_> <leader>c<Space>
vmap <C-_> <leader>c<Space>

"vim-auto-save
let g:auto_save = 1  " enable AutoSave on Vim startup
let g:auto_save_silent = 1  " do not display the auto-save notification

"ntpeters/vim-better-whitespace
"let g:better_whitespace_enabled=1
let g:strip_whitespace_on_save=1
